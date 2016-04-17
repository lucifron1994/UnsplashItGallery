//
//  PhotoBrowserController.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/3/21.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit
import Kingfisher

private let ImageCellID = "ImageCellID"
private let ImageMargin : CGFloat = 20


class PhotoBrowserController: UIViewController, UICollectionViewDataSource{
    
    var jsonArray : [AnyObject]?
    var currentIndexPath : NSIndexPath?
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var layout: ImageCollectionViewLayout!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var downloadProgressView: ProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        print("current \(currentIndexPath?.item)")
        mainCollectionView.registerNib(UINib.init(nibName: "PhotoBrowserCell", bundle: nil), forCellWithReuseIdentifier: ImageCellID)
        
        //滚动CollectionView到目标位置
        view.layoutIfNeeded()
        mainCollectionView.scrollToItemAtIndexPath(currentIndexPath!, atScrollPosition: .CenteredHorizontally, animated: false)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func share(sender: AnyObject) {
        
        let cell : PhotoBrowserCell = mainCollectionView.cellForItemAtIndexPath(getCurrentIndex()) as! PhotoBrowserCell
        
        if let shareImage :UIImage = cell.imageView_full.image {
            let activity = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                let ppc = activity.popoverPresentationController
                ppc?.sourceView = self.view
                ppc?.sourceRect = CGRect(x: 10, y: 10, width: 2, height: 2)
                ppc?.permittedArrowDirections = .Any
            }
            
            self.presentViewController(activity, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func savePhoto(sender: AnyObject) {
        
        tempView.hidden = false
        downloadProgressView.progress = 0.0
        
        let imageDic =  jsonArray![getCurrentIndex().item]
        
        let num = imageDic["id"] as!
        Int
        let width = imageDic["width"] as! Int
        let height = imageDic["height"] as! Int
        
        let url = NSURL(string:"https://unsplash.it/\(width)/\(height)?image=\(num)")
        
        let downloader = ImageDownloader(name: "downloader")
        downloader.downloadImageWithURL(url!, progressBlock: { (receivedSize, totalSize) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.downloadProgressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
            })
            
        }) { (image, error, imageURL, originalData) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tempView.hidden = true
            })
            
            if error != nil {
                ShowAlert.showAlert(NSLocalizedString("error", comment: ""), controller: self)
            }else{
                if image != nil {
                    UIImageWriteToSavedPhotosAlbum(image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
                    //                        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let cell = self.mainCollectionView.cellForItemAtIndexPath(self.getCurrentIndex()) as? PhotoBrowserCell
                        cell!.imageView_full.image = image
                    })
                }
                
            }
        }
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func tapView(sender: AnyObject) {
        if toolBar.hidden{
            toolBar.hidden = false
        }else{
            toolBar.hidden = true
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        let beforeWidth = size.height
        let afterWidth = size.width
        let beforeOffset = mainCollectionView.contentOffset.x
        let afterOffset = beforeOffset / (beforeWidth / afterWidth)
        
        UIView.animateWithDuration(0.3) {
            self.mainCollectionView.contentOffset = CGPoint(x: afterOffset, y: 0)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
}

// MARK:- CollectionView
extension PhotoBrowserController{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (jsonArray?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCellID, forIndexPath: indexPath) as! PhotoBrowserCell
//        print("Before \(cell.progressView.progress)")
        
        let idString = jsonArray![indexPath.item]["id"] as! Int
        let url = NSURL(string:"https://unsplash.it/\(kHeight*2)/\(kWidth*2)?image=\(idString)")
        cell.tempImageURL = NSURL(string:"https://unsplash.it/\(kRootViewImageWidth)/\(kRootViewImageHeight)?image=\(idString)")
        cell.imageURL = url!
        
        print(url)
        print(cell.tempImageURL)
//        print("After \(cell.progressView.progress)")
        
        return cell
    }
    
}

extension PhotoBrowserController{
    private  func getCurrentIndex()-> NSIndexPath {
        let index : Int = Int(mainCollectionView.contentOffset.x / self.view.frame.size.width)
        
        
        return NSIndexPath(forItem: index, inSection: 0)
    }
    
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            ShowAlert.showAlert(NSLocalizedString("error", comment: ""), controller: self)
        }else{
            ShowAlert.showAlert(NSLocalizedString("savedToPhoto", comment: ""), controller: self)
        }
    }
    
    
}
