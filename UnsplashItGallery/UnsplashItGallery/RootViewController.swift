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

private let kPullUpOffset:CGFloat = 50.0

let kCellID = "imageCell"
let BaseUrl = "https://unsplash.it/list"


class RootViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var jsonArray:[AnyObject]?
    var imagesList:[ImageModel]?
    
    var numberOfPage = 0
    var pageImagesCount = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Path \(cachePath)")

//        let titleImageView = UIImageView(image: UIImage(named: "titleView"))
//        titleImageView.frame = CGRectMake(0, 0, 70, 70/16.0*9)
//        titleImageView.contentMode = .ScaleAspectFit
//        titleImageView.clipsToBounds = true
//        self.navigationItem.titleView  = titleImageView
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkNetConnection(){
        
       let reachability = try? Reachability.reachabilityForInternetConnection()
        //判断连接状态
        if reachability!.isReachable(){
            print("网络可用")
        }else{
            print("网络不可用")
            ShowAlert.showAlert(NSLocalizedString("noNetwork", comment: ""), controller: self)
        }
        
    }
    
    
    //MARK: - Fetch Data
    func getLatestData(){
        Alamofire.request(.GET, BaseUrl, parameters: nil)
            .responseJSON { response in
                
                if let JSON : [AnyObject] = response.result.value as? [AnyObject]{
                    print("JSONDATA")
                    
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
            for (var i = (self.jsonArray?.count)!-1; i > ((self.jsonArray?.count)!-1-self.pageImagesCount); i=i-1){
                let model = ImageModel()
                model.imageId = self.jsonArray![i]["id"] as? Int
                model.width = self.jsonArray![i]["width"] as? Int
                model.height = self.jsonArray![i]["height"] as? Int
                self.imagesList?.append(model)
            }
            
            self.numberOfPage = 1
            self.tableView.reloadData()
        }
    }
    
    //获取10条旧数据
    func loadTenOldData(){
        
        for (var i = (self.jsonArray?.count)!-1 - numberOfPage*pageImagesCount; i > ((self.jsonArray?.count)!-self.pageImagesCount-1 - numberOfPage*pageImagesCount); i=i-1){
            if (i>0){
                let model = ImageModel()
                model.imageId = self.jsonArray![i]["id"] as? Int
                model.width = self.jsonArray![i]["width"] as? Int
                model.height = self.jsonArray![i]["height"] as? Int
                self.imagesList?.append(model)
            }
        }
        self.numberOfPage++
        self.tableView.reloadData()
    }
    
    
    //MARK: - Pull Up Refresh - add Old Data
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height - kPullUpOffset > scrollView.contentSize.height{
                print("load more")
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
            
            let model = ImageModel()
            model.imageId = self.jsonArray![randomIndex]["id"] as? Int
            model.width = self.jsonArray![randomIndex]["width"] as? Int
            model.height = self.jsonArray![randomIndex]["height"] as? Int
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = sb.instantiateViewControllerWithIdentifier("detailVC") as! DetailViewController
            detailVC.imageModel = model
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
        
        if imagesList?.count != 0{
            let model = self.imagesList![indexPath.row]
            cell?.setImageDataSource(model)
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detailSegue", sender: indexPath)
    }
    
    
    //MARK: - Switch Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue"{
            let detail = segue.destinationViewController as! DetailViewController
            let indexPath = sender as! NSIndexPath
            detail.imageModel = self.imagesList?[indexPath.row]
        }
    }
    
}
