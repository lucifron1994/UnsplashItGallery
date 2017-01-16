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
    var urls:ImageURLModel?
    
    required init(){}
}
