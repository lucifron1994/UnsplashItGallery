//
//  MainTableViewCell.swift
//  UnsplashItGallery
//
//  Created by WangHong on 15/12/30.
//  Copyright © 2015年 WangHong. All rights reserved.
//

import UIKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    func setImageDataSource(model: ImageModel){
        
        cellImageView.kf_showIndicatorWhenLoading = true
        let num = model.imageId
        let url = NSURL(string:"https://unsplash.it/\(kWidth*2)/\(kWidth/8*9)?image=\(num!)")
        self.cellImageView.kf_setImageWithURL(url!)
    }
    
}
