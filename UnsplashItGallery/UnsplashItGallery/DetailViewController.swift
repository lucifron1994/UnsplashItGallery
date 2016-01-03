//
//  DetailViewController.swift
//  UnsplashItGallery
//
//  Created by WangHong on 15/12/31.
//  Copyright © 2015年 WangHong. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var progressView:UIProgressView!
    @IBOutlet weak var tempView:UIView!
    
    var imageModel:ImageModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.addSubview(imageView)
        self.scrollView.contentSize =  CGSizeMake(kWidth, kHeight)
        
        let num = imageModel.imageId
//        let width = imageModel.width
//        let height = imageModel.height
        
        let url = NSURL(string:"https://unsplash.it/\(kHeight*2)/\(kWidth*2)?image=\(num!)")
        
        self.imageView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) -> () in
                self.progressView.progress = (Float(receivedSize)) / (Float(totalSize))
                print("Download Progress: \(receivedSize)/\(totalSize)")

            }) { (image, error, cacheType, imageURL) -> () in
                self.progressView.hidden = true
                self.tempView.hidden = true
               print("Downloaded and set!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        let imageViewSize = imageView.frame.size
//        let scrollViewSize = scrollView.bounds.size
//        
//        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
//        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
//        
//        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
//    }
//    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if toolBar.hidden{
//            toolBar.hidden = false
//            view.backgroundColor = UIColor.blackColor()
//        }else{
//            toolBar.hidden = true
//            view.backgroundColor = UIColor.whiteColor()
//        }
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        // On iPad, you must present the view controller in a popover.
        
       // let saveHDImageActivity = SaveHDImageActivity()

       //BUg 图片未加载就存
        let shareImage : UIImage = self.imageView.image!
        
        let activity = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        
        self.presentViewController(activity, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissVC(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveOriginalImage(){
        let tempImageView = UIImageView()
        self.progressView.hidden = false
        self.progressView.progress = 0.0
        self.tempView.hidden = false
        
        let num = imageModel.imageId
        let width = imageModel.width
        let height = imageModel.height
        let url = NSURL(string:"https://unsplash.it/\(height)/\(width))?image=\(num!)")
        
        tempImageView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) -> () in
            self.progressView.progress = (Float(receivedSize)) / (Float(totalSize))
            print("Download Progress: \(receivedSize)/\(totalSize)")
            
            }) { (image, error, cacheType, imageURL) -> () in
                self.progressView.hidden = true
                self.tempView.hidden = true
                print("Downloaded and set!")
        }

        UIImageWriteToSavedPhotosAlbum(tempImageView.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            print("错误")
            return
        }
        print("OK")
    }
    
    
    //MARK: - Other Setting
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
 

}
