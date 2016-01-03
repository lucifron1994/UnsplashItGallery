//
//  SaveHDImageActivity.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/1/1.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit

private let ActivityType = "com.UnsplashItGallery.activity.saveHDImage"

class SaveHDImageActivity: UIActivity {
    
    
    override func activityTitle() -> String? {
        return "Save HD Image"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "downloadAction")
    }
    
    override func activityType() -> String? {
        return ActivityType
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        print("here")
//        activityDidFinish(true)
    }
    
}
