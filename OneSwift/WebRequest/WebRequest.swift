//
//  WebRequest.swift
//  SwiftDemo01
//
//  Created by Angel Arce Carrillo on 20/05/16.
//  Copyright © 2016 Angel Arce Carrillo. All rights reserved.
//

import Foundation
import UIKit

class WebRequest: NSObject {
    
    func sendAsynchronousRequestForGET(url: String, inViewController: UIViewController, completionHandler: (response: String) -> ()) {
        
        if !NetworkUtil().isConnectedToNetwork() {
            
            self.showAlertControllerFailed(inViewController)
            
            completionHandler(response: String("No internet connection"))
            print("No hay internet")
            return
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!);
        let session = NSURLSession.sharedSession();
        request.HTTPMethod = "GET"
        
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if (error != nil) {
                print("Error peticion GET, url = \(url)")
            }
            
            if (data != nil) {
                completionHandler(response: String(data: data!, encoding: NSUTF8StringEncoding)!)
                //NSLog("response = \(String(data: data!, encoding: NSUTF8StringEncoding))")
            }
        })
        
        task.resume()
    }
    
    func sendAsynchronousRequestForPOST(url: String, json: Dictionary<String, AnyObject>, inViewController: UIViewController, completionHandler: (response: String) -> ()) {
        
        if !NetworkUtil().isConnectedToNetwork() {
            
            self.showAlertControllerFailed(inViewController)
            
            completionHandler(response: String("No internet connection"))
            print("No hay internet")
            return
        }
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!);
        let session = NSURLSession.sharedSession();
        request.HTTPMethod = "POST"
        
        request.HTTPBody = jsonData
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if (error != nil) {
                print("Error peticion POST, url = \(url)")
            }
            
            if (data != nil) {
                completionHandler(response: String(data: data!, encoding: NSUTF8StringEncoding)!)
                //NSLog("response = \(String(data: data!, encoding: NSUTF8StringEncoding))")
            }
        })
        
        task.resume()
    }
    
    func showAlertControllerFailed(inViewController: UIViewController) {
        
        let alert = UIAlertController(title: "Advertencia", message: "Conecte su dispositivo a Internet", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
        inViewController.self.presentViewController(alert, animated: true, completion: nil)
    }
}