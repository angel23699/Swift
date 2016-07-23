//
//  DownloadImageWithURL.swift
//  SwiftDemo01
//
//  Created by Angel Arce Carrillo on 22/05/16.
//  Copyright © 2016 Angel Arce Carrillo. All rights reserved.
//

import Foundation
import UIKit

class DownloadImageWithURL: NSObject {
    
    func downloadImage(url: NSURL, imageView: UIImageView){
        //print("Download Started")
        //print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                //print(response?.suggestedFilename ?? "")
                //print("Download Finished")
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
}