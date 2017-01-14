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
    
    
    func setImageDataSource(_ model: ImageModel){
        
        
        cellImageView.kf.indicatorType = .activity
        
//        let num = model.imageId
//        let url = URL(string:"https://unsplash.it/\(kRootViewImageWidth)/\(kRootViewImageHeight)?image=\(num!)")
//        self.cellImageView.kf.setImage(with: url)
    }

    func setImageURLString(url : String){
        cellImageView.kf.indicatorType = .activity
        let u = URL(string: url)
        self.cellImageView.kf.setImage(with: u)
    }
}
