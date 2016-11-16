//
//  RootViewController.swift
//  UnsplashItGallery
//
//  Created by WangHong on 15/12/30.
//  Copyright © 2015年 WangHong. All rights reserved.
//

import UIKit
import Alamofire

let kWidth = UIScreen.mainScreen().bounds.size.width
let kHeight = UIScreen.mainScreen().bounds.size.height

let kRootViewImageWidth = kWidth*2
let kRootViewImageHeight = kWidth/16*9*2


private let kPullUpOffset:CGFloat = 20.0
private let kToPhotoBrowserSegue = "photoBrowserSegue"
private let kCellID = "imageCell"
private let BaseUrl = "https://unsplash.it/list"


class RootViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    private var jsonArray:[AnyObject]?
    private var imagesList:[ImageModel]?
    
    private var numberOfPage = 0
    private var pageImagesCount = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        
        //Add pullToRefresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.getLatestData()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshBackgroundColor(UIColor.whiteColor())
        tableView.dg_setPullToRefreshFillColor(UIColor.blackColor())
        
        //检查JSON有的话先用旧的并刷新
        if  DataStorageTool.fileExist() {
            self.jsonArray = DataStorageTool.getJsonData()
            updateJSONData()
        }
        //获得最新json数据
        getLatestData()
        
        //检测网络
        checkNetConnection()
    }
    

    func checkNetConnection(){
        
       let reachability = try? Reachability.reachabilityForInternetConnection()
        //判断连接状态
        if reachability!.isReachable(){
//            print("网络可用")
        }else{
//            print("网络不可用")
            ShowAlert.showAlert(NSLocalizedString("noNetwork", comment: ""), controller: self)
        }
        
    }
    
    
    //MARK: - Fetch Data
    func getLatestData(){
        Alamofire.request(.GET, BaseUrl, parameters: nil)
            .responseJSON { response in
                
                if let JSON : [AnyObject] = response.result.value as? [AnyObject]{
                    
                    if (DataStorageTool.checkFileIsSame(JSON)){
                        return
                    }else{
                        self.jsonArray = [AnyObject]()
                        self.jsonArray = JSON
                        DataStorageTool.saveJsonData(JSON)
                        self.updateJSONData()
                    }
                    
                }else{
                    
                    ShowAlert.showAlert(NSLocalizedString("failedToGetLatestData", comment: ""), controller: self)
                }
                
        }

    }
    
    //结合JSON数据刷新UI
    func updateJSONData(){
        if self.jsonArray?.count != 0{
            self.imagesList = [ImageModel]()
            
            let frontIndex = (self.jsonArray?.count)! - 1
            let backIndex = ((self.jsonArray?.count)! - self.pageImagesCount)
            
            for i in (backIndex...frontIndex).reverse() {
                print(i)
                    let model = ImageModel()
                    model.imageId = self.jsonArray![i]["id"] as? Int
                    model.width = self.jsonArray![i]["width"] as? Int
                    model.height = self.jsonArray![i]["height"] as? Int
                    self.imagesList?.append(model)
            }
            
//            for (var i = (self.jsonArray?.count)!-1; i > ((self.jsonArray?.count)!-1-self.pageImagesCount); i=i-1){
//                 print(i)
//                let model = ImageModel()
//                model.imageId = self.jsonArray![i]["id"] as? Int
//                model.width = self.jsonArray![i]["width"] as? Int
//                model.height = self.jsonArray![i]["height"] as? Int
//                self.imagesList?.append(model)
//            }

            self.numberOfPage = 1
            self.tableView.reloadData()
        }
    }
    
    //获取10条旧数据
    func loadTenOldData(){
        let frontIndex = (self.jsonArray?.count)!-1 - numberOfPage*pageImagesCount
        let backIndex = ((self.jsonArray?.count)!-self.pageImagesCount - numberOfPage*pageImagesCount)
        for i in (backIndex...frontIndex).reverse() {
            print("old \(i)")
            let model = ImageModel()
            model.imageId = self.jsonArray![i]["id"] as? Int
            model.width = self.jsonArray![i]["width"] as? Int
            model.height = self.jsonArray![i]["height"] as? Int
            self.imagesList?.append(model)
        }
        
//        for (var i = (self.jsonArray?.count)!-1 - numberOfPage*pageImagesCount; i > ((self.jsonArray?.count)!-self.pageImagesCount-1 - numberOfPage*pageImagesCount); i=i-1){
//             print("old \(i)")
//            if (i>0){
//                let model = ImageModel()
//                model.imageId = self.jsonArray![i]["id"] as? Int
//                model.width = self.jsonArray![i]["width"] as? Int
//                model.height = self.jsonArray![i]["height"] as? Int
//                self.imagesList?.append(model)
//            }
//        }
        self.numberOfPage += 1
        self.tableView.reloadData()
    }
    
    
    //MARK: - Pull Up Refresh - add Old Data
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height - kPullUpOffset > scrollView.contentSize.height{
//                print("load more")
            //加载更旧的数据10条
            if numberOfPage != 0{
                loadTenOldData()
            }
        }
    }
    
    //MARK: - Action
    
    @IBAction func getRandomImage(sender: AnyObject) {
        if self.jsonArray != nil {
            let random: UInt32 = UInt32((self.jsonArray?.count)!)
            let randomIndex = Int(arc4random_uniform(random))
            let indexPath = NSIndexPath(forItem: randomIndex, inSection: 0)
            
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = sb.instantiateViewControllerWithIdentifier("photoBrowser") as! PhotoBrowserController
            detailVC.currentIndexPath = indexPath
            detailVC.jsonArray  = self.jsonArray?.reverse()
            detailVC.modalTransitionStyle = .CrossDissolve
            presentViewController(detailVC, animated: true, completion: nil)

        }
    }
    
    //MARK: - TableView Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kWidth/16.0*9.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.imagesList?.count == nil{
            return 0;
        }else {
            return (self.imagesList?.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainTableViewCell? = tableView.dequeueReusableCellWithIdentifier(kCellID, forIndexPath: indexPath) as? MainTableViewCell
        
        if (indexPath.row < self.imagesList?.count){
            let model = self.imagesList![indexPath.row]
            cell?.setImageDataSource(model)
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(kToPhotoBrowserSegue, sender: indexPath)
    }
    
    //MARK: - Switch Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kToPhotoBrowserSegue {
            let detail = segue.destinationViewController as! PhotoBrowserController
            detail.currentIndexPath = sender as? NSIndexPath
            detail.jsonArray  = self.jsonArray?.reverse()
        }
    }
    
}
