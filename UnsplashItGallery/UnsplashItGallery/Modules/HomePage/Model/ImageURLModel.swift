//
//  ImageURLModel.swift
//  UnsplashItGallery
//
//  Created by wanghong on 2017/1/14.
//  Copyright © 2017年 WangHong. All rights reserved.
//

import UIKit
import HandyJSON

class ImageURLModel: HandyJSON {
    var raw:String?
    var full:String?
    var regular:String?
    var small:String?
    var thumb:String?
    
    required init(){}
}
