//
//  ShowAlert.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/1/3.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit

class ShowAlert: NSObject {
    
    class func showAlert(title:String, controller:UIViewController){
        
        let alertView = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        controller.presentViewController(alertView, animated: false, completion: nil)
        
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
