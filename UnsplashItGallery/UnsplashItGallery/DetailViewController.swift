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
        //Download image with the frame equal to the device*2
        let url = NSURL(string:"https://unsplash.it/\(kHeight*2)/\(kWidth*2)?image=\(num!)")
        
        
        self.imageView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) -> () in
                self.progressView.progress = (Float(receivedSize)) / (Float(totalSize))
                print("Download Progress: \(receivedSize)/\(totalSize)")
            
            }) { (image, error, cacheType, imageURL) -> () in
                if (error != nil){
                   ShowAlert.showAlert("Error", controller: self)
                }
                
                self.progressView.hidden = true
                self.tempView.hidden = true
                print("Downloaded and set!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    //MARK: - Action
    @IBAction func tappedInScrollView(sender: AnyObject) {
        if toolBar.hidden{
            toolBar.hidden = false
        }else{
            toolBar.hidden = true
        }
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        // On iPad, you must present the view controller in a popover.
//        let saveHDImageActivity = SaveHDImageActivity()
//        saveHDImageActivity.imageModel = self.imageModel
        
        if let shareImage :UIImage = self.imageView.image {
            let activity = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
            self.presentViewController(activity, animated: true, completion: nil)
        }
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
        let url = NSURL(string:"https://unsplash.it/\(width!)/\(height!)?image=\(num!)")
        
        print(url)
        
        tempImageView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) -> () in
            
            self.progressView.progress = (Float(receivedSize)) / (Float(totalSize))
            print("Download Progress: \(receivedSize)/\(totalSize)")
            
            }) { (image, error, cacheType, imageURL) -> () in
                if error != nil {
                    ShowAlert.showAlert("Error", controller: self)
                }else{
                    if image != nil {
                        UIImageWriteToSavedPhotosAlbum(image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.imageView.image = image
                        })
                    }
                    
                }
                self.progressView.hidden = true
                self.tempView.hidden = true
                print("Downloaded and set!")
        }
      
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            ShowAlert.showAlert("Error", controller: self)
        }
    }
    
    
    //MARK: - ScrollView Delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                scrollView.setContentOffset(scrollView.contentOffset, animated: false)
            })
        }
    }
    
    
    //MARK: - Other Setting
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
 

}
