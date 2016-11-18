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
    @IBAction func clearCache(_ sender: AnyObject) {
        let cache = KingfisherManager.shared.cache
        cache.clearDiskCache()
    
        clearCacheButton.setTitle(NSLocalizedString("clearCache", comment: ""), for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Private 
    func getCacheSize(){
        
        DispatchQueue.global().async { 
            let fm = FileManager.default
            let rootPath:String = NSHomeDirectory() + "/Library/Caches/com.onevcat.Kingfisher.ImageCache.default/"
            var totolSize = 0
            let files = try? fm.contentsOfDirectory(atPath: rootPath)
            
            if fm.fileExists(atPath: rootPath){
                for item in files!{
                    let filePath = rootPath + item
                    totolSize += self.fileSizeAtPath(filePath)
                }
            }
            
            let mb = Double(totolSize) / (1000.0*1000.0)
            let cacheStr = String(format: "%@（%.2fMB)",NSLocalizedString("clearCache", comment: ""),mb)
            
            DispatchQueue.main.async(execute: {
                self.clearCacheButton.setTitle(cacheStr, for: .normal)
            });
            

        }
        
//        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0).asynchronously(DispatchQueue.global) { () -> Void in
//            
//            //            dispatch_get_main_queue().asynchronously(DispatchQueue.mainexecute: { () -> Void in
////                self.clearCacheButton.setTitle(cacheStr, for: .normal)
////            })
//        }
        
    }

    
    func fileSizeAtPath(_ filePath: String) -> Int{
        let fm = FileManager.default
        if fm.fileExists(atPath: filePath){
            let attr = try? fm.attributesOfItem(atPath: filePath)[FileAttributeKey.size]
            return attr as! Int
        }else{
            return 0
        }
    }
    
    //MARK: - Others Setting
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
}
