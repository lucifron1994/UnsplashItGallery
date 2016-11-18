//
//  ShowAlert.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/1/3.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit

class ShowAlert: NSObject {
    
    class func showAlert(_ title:String, controller:UIViewController){
        
        let alertView = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        controller.present(alertView, animated: false, completion: nil)
        
        let time: TimeInterval = 2.0
        
//        let delay = DispatchTime.now(dispatch_time_t(DispatchTime.now),
//            Int64(time * Double(NSEC_PER_SEC)))
//        dispatch_after(delay, DispatchQueue.main) {
//            alertView.dismiss(animated: true, completion: nil)
//        }

    }
    
}
