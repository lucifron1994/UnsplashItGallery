//
//  InfoViewController.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/1/4.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit
import Kingfisher

class InfoViewController: UIViewController {
    
    @IBOutlet weak var clearCacheButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCacheSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Action
    @IBAction func clearCache(sender: AnyObject) {
        let cache = KingfisherManager.sharedManager.cache
        cache.clearDiskCache()
    
        clearCacheButton.setTitle(NSLocalizedString("clearCache", comment: ""), forState: .Normal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Private 
    func getCacheSize(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let fm = NSFileManager.defaultManager()
            let rootPath:String = NSHomeDirectory() + "/Library/Caches/com.onevcat.Kingfisher.ImageCache.default/"
            var totolSize = 0
            let files = try? fm.contentsOfDirectoryAtPath(rootPath)
            
            if fm.fileExistsAtPath(rootPath){
                for item in files!{
                    let filePath = rootPath + item
                    totolSize += self.fileSizeAtPath(filePath)
                }
            }
            let mb = Double(totolSize) / (1000.0*1000.0)
            let cacheStr = String(format: "%@（%.2fMB)",NSLocalizedString("clearCache", comment: ""),mb)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.clearCacheButton.setTitle(cacheStr, forState: .Normal)
            })
        }
        
    }

    
    func fileSizeAtPath(filePath: String) -> Int{
        let fm = NSFileManager.defaultManager()
        if fm.fileExistsAtPath(filePath){
            let attr = try? fm.attributesOfItemAtPath(filePath)[NSFileSize]
            return attr as! Int
        }else{
            return 0
        }
    }
    
    
    //MARK: - Others Setting
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
