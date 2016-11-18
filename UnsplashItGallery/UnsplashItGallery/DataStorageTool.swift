//
//  DataStorageTool.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/1/3.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit

let jsonFileName = "UnsplashItGalleryJsonData"

let cachePath:String = NSHomeDirectory() + "/Library/Caches" + jsonFileName

class DataStorageTool: NSObject {
 
    //MARK 检测数据表是否存在
    class func fileExist()->Bool{
        
        let fm = FileManager.default
        if fm.fileExists(atPath: cachePath){
             return true
        }else{
            return false
        }
    }
    
    //MARK 保存数据表
    class func saveJsonData(_ data: [AnyObject]){
        let array = NSArray(array: data)
        array.write(toFile: cachePath, atomically: true)
    }
    
    //MARK 读取数据表
    class func getJsonData()->[AnyObject]?{
        let jsonData = NSArray(contentsOfFile: cachePath)
        return jsonData as? [AnyObject]
    }
    
    
    //MARK 检查文件中内容个数是否相同
    class func checkFileIsSame(_ newData:[AnyObject]) -> Bool{
        let oldData = getJsonData()
        
        if oldData == nil{
            return false
        }
        
        if newData.count == oldData?.count{
            return true
        }else{
            return false
        }
        
    }
    
    
    
}
