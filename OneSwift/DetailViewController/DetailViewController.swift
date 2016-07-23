//
//  DetailViewController.swift
//  SwiftDemo01
//
//  Created by Angel Arce Carrillo on 25/05/16.
//  Copyright © 2016 Angel Arce Carrillo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let segueIdentifierDetail = "prepareSegue"
    var itemSelectCollectionView = 0
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    let cellIdentifier = "miCeldaCollectionView"
    var dataSet = [CancionDTO]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Espere por favor")
        refreshControl.addTarget(self, action:#selector(self.pullToRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(refreshControl)
        self.collectionView.alwaysBounceVertical = true;
        
        self.makeRequest(true)
    }
    
    func makeRequest(showProgress: Bool) {
        
        if showProgress {
            let alert = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            alert.label.text = "Espere por favor..."
        }
        
        let dic = ["":""]
        
        // Realizo la peticion
        WebRequest().sendAsynchronousRequestForPOST(ConstantsUtil.URL_REQUEST, json: dic, inViewController: self, completionHandler: {(response: String) -> () in
            
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
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.collectionView.reloadData()
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! myCollectionViewCell
        
        let cancion = dataSet[indexPath.row]
        
        DownloadImageWithURL().downloadImage(NSURL(string: cancion.urlImage)!, imageView: cell.imagenCancion)
        cell.labelCancion.text = cancion.nameSong
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //print("Presionaste el item \(indexPath.row)")
        
        self.itemSelectCollectionView = indexPath.row
        self.performSegueWithIdentifier(self.segueIdentifierDetail, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.segueIdentifierDetail {
            let viewController = segue.destinationViewController as! FinalDetailViewController
            viewController.modelo = dataSet[self.itemSelectCollectionView]
        }
    }
}
