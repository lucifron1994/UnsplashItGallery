//
//  PhotoBrowserController.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/3/21.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit
//import Kingfisher

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
        
        mainCollectionView.register(UINib.init(nibName: "PhotoBrowserCell", bundle: nil), forCellWithReuseIdentifier: ImageCellID)
        
        //滚动CollectionView到目标位置
        view.layoutIfNeeded()
        mainCollectionView.scrollToItem(at: currentIndexPath! as IndexPath, at: .centeredHorizontally, animated: false)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func share(_ sender: AnyObject) {
        
        let cell : PhotoBrowserCell = mainCollectionView.cellForItem(at: getCurrentIndex() as IndexPath) as! PhotoBrowserCell
        
        if let shareImage :UIImage = cell.imageView_full.image {
            let activity = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let ppc = activity.popoverPresentationController
                ppc?.sourceView = self.view
                ppc?.sourceRect = CGRect(x: 10, y: 10, width: 2, height: 2)
                ppc?.permittedArrowDirections = .any
            }
            
            self.present(activity, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func savePhoto(_ sender: AnyObject) {
        
        tempView.isHidden = false
        downloadProgressView.progress = 0.0
        
//        let imageDic =  jsonArray![getCurrentIndex().item]
        
//        let num = imageDic["id"] as!
//        Int
//        let width = imageDic["width"] as! Int
//        let height = imageDic["height"] as! Int
//        
//        let url = NSURL(string:"https://unsplash.it/\(width)/\(height)?image=\(num)")
        
//        let downloader = ImageDownloader(name: "downloader")
//        
//        
//        downloader.downloadImageWithURL(url!, progressBlock: { (receivedSize, totalSize) in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.downloadProgressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
//            })
//            
//        }) { (image, error, imageURL, originalData) in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.tempView.hidden = true
//            })
//            
//            if error != nil {
//                ShowAlert.showAlert(NSLocalizedString("error", comment: ""), controller: self)
//            }else{
//                if image != nil {
//                    UIImageWriteToSavedPhotosAlbum(image!, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        let cell = self.mainCollectionView.cellForItemAtIndexPath(self.getCurrentIndex()) as? PhotoBrowserCell
//                        cell!.imageView_full.image = image
//                    })
//                }
//                
//            }
//        }
        
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tapView(_ sender: AnyObject) {
        if toolBar.isHidden{
            toolBar.isHidden = false
        }else{
            toolBar.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let beforeWidth = size.height
        let afterWidth = size.width
        let beforeOffset = mainCollectionView.contentOffset.x
        let afterOffset = beforeOffset / (beforeWidth / afterWidth)
        
        UIView.animate(withDuration: 0.3) {
            self.mainCollectionView.contentOffset = CGPoint(x: afterOffset, y: 0)
        }

    }
    
//    override func viewWillTransitionToSize(_ size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        
//            }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
}

// MARK:- CollectionView
extension PhotoBrowserController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (jsonArray?.count)!
    }
    
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellID, for: indexPath as IndexPath) as! PhotoBrowserCell
        //        print("Before \(cell.progressView.progress)")
        
        let idString = jsonArray![indexPath.item]["id"] as! Int
        let url = NSURL(string:"https://unsplash.it/\(kHeight*2)/\(kWidth*2)?image=\(idString)")
        cell.tempImageURL = NSURL(string:"https://unsplash.it/\(kRootViewImageWidth)/\(kRootViewImageHeight)?image=\(idString)")
        cell.imageURL = url!
        //        print(cell.tempImageURL)
        
        print("self \(view.frame.size.width) coll \(collectionView.frame.size.width) image:\(cell.imageView_full.frame.width)");
        
        return cell

    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//            }
    
}

extension PhotoBrowserController{
    fileprivate  func getCurrentIndex()-> NSIndexPath {
        let index : Int = Int(mainCollectionView.contentOffset.x / self.view.frame.size.width)
        
        return NSIndexPath(row: index, section: 0)
//        return NSIndexPath(forItem: index, inSection: 0)
    }
    
    
    func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            ShowAlert.showAlert(NSLocalizedString("error", comment: ""), controller: self)
        }else{
            ShowAlert.showAlert(NSLocalizedString("savedToPhoto", comment: ""), controller: self)
        }
    }
    
    
}
