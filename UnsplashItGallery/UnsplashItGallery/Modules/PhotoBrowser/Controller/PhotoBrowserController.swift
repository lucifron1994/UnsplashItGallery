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
    
    var imagesList:[ImageModel]?
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
    
        
        let index = getCurrentIndex().row
        let currentModel = self.imagesList?[index]
        
        let downloader = ImageDownloader(name: "downloader")
    
        downloader.downloadImage(with: URL(string:(currentModel?.urls?.full)!)!, options: nil, progressBlock: { (receivedSize, totalSize) in
            DispatchQueue.main.async {
                self.downloadProgressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
            }
            
            }) {(image, error, imageURL, originalData) in
                
                DispatchQueue.main.async {
                    self.tempView.isHidden = true
                }
                
                
                if error != nil {
                    ShowAlert.showAlert(NSLocalizedString("error", comment: ""), controller: self)
                }else{
                    if image != nil {
                        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
                        DispatchQueue.main.async {
                        
                            let cell = self.mainCollectionView.cellForItem(at: self.getCurrentIndex() as IndexPath) as! PhotoBrowserCell
                            cell.imageView_full.image = image
                        }
                    }
                    
                }

        }
        
        
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
        return (imagesList?.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellID, for: indexPath as IndexPath) as! PhotoBrowserCell
        
        let imageModel =  imagesList![indexPath.row]
        cell.imageModel = imageModel
        
        return cell
    }
    
}

extension PhotoBrowserController{
    fileprivate  func getCurrentIndex()-> NSIndexPath {
        let index : Int = Int(mainCollectionView.contentOffset.x / self.view.frame.size.width)
        
        return NSIndexPath(row: index, section: 0)
    }
    
    
    func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            ShowAlert.showAlert(NSLocalizedString("error", comment: ""), controller: self)
        }else{
            ShowAlert.showAlert(NSLocalizedString("savedToPhoto", comment: ""), controller: self)
        }
    }
    
    
}
