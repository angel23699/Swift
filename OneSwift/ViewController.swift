//
//  ViewController.swift
//  OneSwift
//
//  Created by Angel Arce Carrillo on 27/05/16.
//  Copyright © 2016 Angel Arce Carrillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    let cellIdentifier = "miCelda"
    var dataSet = [CancionDTO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Espere por favor")
        refreshControl.addTarget(self, action:#selector(self.pullToRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.makeRequest(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeRequest(showProgress: Bool) {
        
        if showProgress {
            let alert = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            alert.label.text = "Espere por favor..."
        }
        
        // Realizo la peticion
        WebRequest().sendAsynchronousRequestForGET(ConstantsUtil.URL_REQUEST, inViewController: self, completionHandler: {(response: String) -> () in
            
            if response == "No internet connection" {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.refreshControl.endRefreshing()
                    
                    if showProgress {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                })
                return
            }
            
            self.self.dataSet = [CancionDTO]()
            
            //NSLog("response = \(response)")
            
            // convert String to NSData
            let data: NSData = response.dataUsingEncoding(NSUTF8StringEncoding)!
            
            // convert NSData to 'AnyObject'
            let anyObject: AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            
            // convert AnyObject to Array
            let array = (anyObject as! NSArray) as Array
            
            for dictionary in array {
                //print("El dato es \(dato)")
                self.dataSet.append(CancionParser().parserSongWithDictionary(dictionary as! NSMutableDictionary))
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
                if showProgress {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
            
            //print("El dataSet quedo de esta forma = \(self.dataSet)")
        })
    }
    
    func pullToRefresh(sender:AnyObject) {
        // Code to refresh table view
        self.makeRequest(false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSet.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! myTableViewCell
        
        let cancion = dataSet[indexPath.row] as CancionDTO
        
        DownloadImageWithURL().downloadImage(NSURL(string: cancion.urlImage)!, imageView: cell.miImagen)
        cell.labelNameSong.text = cancion.nameSong
        cell.labelArtist.text = cancion.nameArtist
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("Has selecionado el item numero \(indexPath.row)")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
}

