//
//  ImageModel.swift
//  UnsplashItGallery
//
//  Created by WangHong on 15/12/30.
//  Copyright © 2015年 WangHong. All rights reserved.
//

import UIKit
import HandyJSON

class ImageModel: HandyJSON {
    var id:String?
    var created_at:String?
    var width:Int?
    var height:Int?
    var urls:ImageURLModel?
    
    required init(){}
}


/* Get At 17-1-14
 {
 "id":"usNcrgrSTqM",
 "created_at":"2017-01-13T14:35:14-05:00",
 "width":5400,
 "height":3600,
 "color":"#EAEDF4",
 "likes":16,
 "liked_by_user":false,
 "user":Object{...},
 "current_user_collections":Array[0],
 "urls":{
 "raw":"https://images.unsplash.com/photo-1484336002386-fc52e35b9742",
 "full":"https://images.unsplash.com/photo-1484336002386-fc52e35b9742?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&s=36731ed4106237e7e7e921bbfc95adb2",
 "regular":"https://images.unsplash.com/photo-1484336002386-fc52e35b9742?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=3d278c65926427626f5d3608fcade1d7",
 "small":"https://images.unsplash.com/photo-1484336002386-fc52e35b9742?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&s=69b351439dfbda8796a3a07c6e71f965",
 "thumb":"https://images.unsplash.com/photo-1484336002386-fc52e35b9742?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=45c6ce5b505d9a7117974b730be2344f"
 },
 "categories":Array[0],
 "links":Object{...}
 },
 */
