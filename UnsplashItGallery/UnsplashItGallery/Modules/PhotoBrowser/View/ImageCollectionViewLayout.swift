//
//  ImageCollectionViewLayout.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/3/28.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit

class ImageCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    
        scrollDirection = .horizontal
    }
    
}
