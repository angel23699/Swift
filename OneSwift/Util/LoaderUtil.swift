//
//  LoaderUtil.swift
//  OneSwift
//
//  Created by Angel Arce Carrillo on 19/06/16.
//  Copyright © 2016 Angel Arce Carrillo. All rights reserved.
//

import UIKit

class LoaderUtil: NSObject {
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    func progressBarDisplayer(msg:String, indicator:Bool, inController:UIViewController){
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: inController.view.frame.midX - 90, y: inController.view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        inController.view.addSubview(messageFrame)
    }
    
    func removeProgressBarDisplay() {
        self.messageFrame.removeFromSuperview()
    }
}
