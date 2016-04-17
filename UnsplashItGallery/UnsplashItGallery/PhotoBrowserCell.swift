//
//  PhotoBrowserCell.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/3/28.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit
import Kingfisher


class PhotoBrowserCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView_full: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var progressView: ProgressView!
    
    var tempImageURL : NSURL?
    
    var imageURL : NSURL? {
        didSet {
            
            self.progressView.hidden = false
            
            imageView_full.kf_setImageWithURL(imageURL!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
                })
            }) { (image, error, cacheType, imageURL) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.progressView.hidden = true
                })
                if (error != nil && image == nil) {
                    self.imageView_full.kf_setImageWithURL(self.tempImageURL!)
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
}

extension PhotoBrowserCell : UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView_full
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.frame
        var contentsFrame = self.imageView_full.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - scrollView.scrollIndicatorInsets.top - scrollView.scrollIndicatorInsets.bottom - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        self.imageView_full.frame = contentsFrame
    }
    
    func zoomInZoomOut(point: CGPoint!) {
        let newZoomScale = self.scrollView.zoomScale > (self.scrollView.maximumZoomScale/2) ? self.scrollView.minimumZoomScale : self.scrollView.maximumZoomScale
        
        let scrollViewSize = self.scrollView.bounds.size
        
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let x = point.x - (width / 2.0)
        let y = point.y - (height / 2.0)
        
        let rectToZoom = CGRect(x: x, y: y, width: width, height: height)
        
        self.scrollView.zoomToRect(rectToZoom, animated: true)
    }
    
}