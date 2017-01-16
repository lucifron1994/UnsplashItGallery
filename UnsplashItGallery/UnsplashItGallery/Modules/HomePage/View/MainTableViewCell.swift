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
        self.cellImageView.kf.setImage(with: URL(string: (model.urls?.regular)!))
    }
    
}
