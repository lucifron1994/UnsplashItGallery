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
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            alertView.dismiss(animated: true, completion: nil)

        }


    }
    
}
