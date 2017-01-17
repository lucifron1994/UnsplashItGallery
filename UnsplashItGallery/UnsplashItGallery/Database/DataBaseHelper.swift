//
//  DataBaseHelper.swift
//  UnsplashItGallery
//
//  Created by wanghong on 2017/1/16.
//  Copyright © 2017年 WangHong. All rights reserved.
//

import UIKit
import FMDB

private let tableName = "homepage_table"

class DataBaseHelper: NSObject {
    
    var database:FMDatabase?
    
    private static let sharedInstance = DataBaseHelper()
    
    static var shareHelper : DataBaseHelper {
        return sharedInstance
    }
    
    private override init(){}

    
    
    func createDatabase(){
        
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = document.appending("/unsplash.sqlite")
        print("DB Path " + path)
        
        database = FMDatabase(path: path)
        //打开数据库
        if !(database?.open())! {
            print("打开数据库失败")
            return
        }
    }

    
    func createHomepageTable(){
        let sql = "create table if not exists \(tableName)(id integer PRIMARY KEY AUTOINCREMENT, imageId text,created_at text, thumb text, small text, regular text, full text, raw text);"
        
        do {
            try database?.executeUpdate(sql, values: nil)
        } catch {
            print("创建表失败")
        }
        
    }
    
    func deleteHomepageTable(){
        let sql = "drop table if exists \(tableName);"
        do {
            try database?.executeUpdate(sql, values: nil)
        } catch {
            print("删除表失败")
        }
        
        createHomepageTable()
    }
    
    func insertItem(model : ImageModel){
        if (model.id?.isEmpty)! || (model.created_at?.isEmpty)! {
            return
        }
        let sql = "insert into \(tableName) (imageId, created_at, thumb, small, regular, full, raw) values (?,?,?,?,?,?,?);"
        
        let arg : [String] = [model.id!, model.created_at!, (model.urls?.thumb)!, (model.urls?.small)!, (model.urls?.regular)!, (model.urls?.full)!,(model.urls?.raw)!]
        if !((database?.executeUpdate(sql, withArgumentsIn: arg))!) {
            print("插入数据失败")
        }
    }
    
    func insertItems(models : [ImageModel]){
        for model in models {
            insertItem(model: model)
        }
    }
    
    func getDataBaseData( completion : (_ images:[ImageModel])->()){
        
        let sql = "select * from \(tableName);"
        if let rs = database?.executeQuery(sql, withArgumentsIn: nil) {
            var images:[ImageModel] = []
            while rs.next() {
                let image = ImageModel()
                image.id = rs.string(forColumn: "imageId")
                image.created_at = rs.string(forColumn: "created_at")
                let urls = ImageURLModel()
                urls.thumb = rs.string(forColumn: "thumb")
                urls.small = rs.string(forColumn: "small")
                urls.regular = rs.string(forColumn: "regular")
                urls.full = rs.string(forColumn: "full")
                urls.raw = rs.string(forColumn: "raw")
                image.urls = urls
                
                images.append(image)
            }
            completion(images)
        }
    }
    
}
