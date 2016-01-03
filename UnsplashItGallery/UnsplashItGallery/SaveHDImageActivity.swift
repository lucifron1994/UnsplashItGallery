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
    
    var imageModel:ImageModel!
    
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
        print("here with item\(activityItems[0]) and imageModel\(self.imageModel)")
        
        let tempImageView = UIImageView()
//        self.progressView.hidden = false
//        self.progressView.progress = 0.0
//        self.tempView.hidden = false
        
        let num = imageModel!.imageId
        let width = imageModel.width
        let height = imageModel.height
        let url = NSURL(string:"https://unsplash.it/\(width!)/\(height!)?image=\(num!)")
        
        tempImageView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) -> () in
//            self.progressView.progress = (Float(receivedSize)) / (Float(totalSize))
            print("Download Progress: \(receivedSize)/\(totalSize)")
            
            }) { (image, error, cacheType, imageURL) -> () in
                if image != nil {
                    UIImageWriteToSavedPhotosAlbum(image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
                }else{
                    
                }
//                self.progressView.hidden = true
//                self.tempView.hidden = true
                print("Downloaded and set!")
        }

    }
    
    override func performActivity() {
        print("perform Activity")
        activityDidFinish(true)
    }
    
}
