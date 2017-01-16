//
//  HomepageViewModel.swift
//  UnsplashItGallery
//
//  Created by wanghong on 2017/1/14.
//  Copyright © 2017年 WangHong. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

class HomepageViewModel: NSObject {
    
    fileprivate var currentPage = 1
    fileprivate var numPerPage = 10
    
    var imagesList:[ImageModel] = [ImageModel]()
    
    /// 拉取首页数据
    func getLatestData( completion:@escaping (_ succeed:Bool)->() ){
        
        let url = BaseURL + GETPhotosURL
        print("请求首页数据 \(url)")
        
        let parameters = ["client_id" : ApplicationID,
                          "page" : 1,
                          "per_page" : numPerPage] as [String : Any]
        
        Alamofire.request(url, parameters:parameters).responseJSON { response in
            if let JSON : [AnyObject] = response.result.value as? [AnyObject]{
                print("First Page：\(JSON)")
                self.imagesList = [ImageModel]()
                for imageURL in JSON{
                    let model : ImageModel = JSONDeserializer.deserializeFrom(dict: imageURL as? NSDictionary)!
                    self.imagesList.append(model)
                }
                
                completion(true)
            }else{
                completion(false)
            }
            
        }
        
    }
    
    
    /// 拉取下一页数据
    func getMoreData( completion:@escaping (_ succeed:Bool)->() ){
    
        let url = BaseURL + GETPhotosURL
        print("加载更多数据 \(url)")

        currentPage = currentPage + 1
        let parameters = ["client_id" : ApplicationID,
                          "page" : self.currentPage,
                          "per_page" : numPerPage] as [String : Any]
        
        Alamofire.request(url, parameters:parameters).responseJSON { response in
            if let JSON : [AnyObject] = response.result.value as? [AnyObject]{
                print("Get More Data : \(JSON)")
                
                if JSON.count > 0 {
                    for imageURL in JSON{
                        let model : ImageModel = JSONDeserializer.deserializeFrom(dict: imageURL as? NSDictionary)!
                        self.imagesList.append(model)
                    }
                    completion(true)
                }else{
                    self.currentPage = self.currentPage-1
                    completion(false)
                }
                
            }else{
                self.currentPage = self.currentPage-1
                completion(false)
            }
            
        }
    }
    
    func getRandomPhoto(completion:@escaping (_ succeed:Bool,_ imageModel:ImageModel?)->()){
        let url = BaseURL + GETRandomPhotoURL
        let parameters = ["client_id" : ApplicationID]
        
        print("加载随机图片 \(url)")
        
        Alamofire.request(url, parameters:parameters).responseJSON { response in
            if let JSON : Dictionary<String, AnyObject> = response.result.value as! Dictionary? {
                
                print("Get Random : \(JSON)")
                let model : ImageModel = JSONDeserializer.deserializeFrom(dict: JSON as NSDictionary?)!
                completion(true, model)
                
            }else{
                completion(false, nil)
            }
            
        }
        
    }

}
