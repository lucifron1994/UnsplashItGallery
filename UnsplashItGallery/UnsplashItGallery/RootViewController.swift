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

let kCellID = "imageCell"
let BaseUrl = "https://unsplash.it/list"


class RootViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagesList:[ImageModel]?
    
    var numberOfPage = 0
    var pageImagesCount = 10
    
    
    var jsonArray:[AnyObject]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Add pullToRefresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            
//            self!.getLatestData()
            
            self?.tableView.dg_stopLoading()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        
        jsonArray = [AnyObject]()
        
        //获得所有json数据
        getLatestData()
    }
    
    func getLatestData(){
        //Http Request
        Alamofire.request(.GET, BaseUrl, parameters: nil)
            .responseJSON { response in
                if let JSON : [AnyObject] = response.result.value as? [AnyObject]{
                    self.jsonArray = JSON
                }
                
                if self.jsonArray?.count != 0{
                    self.imagesList = [ImageModel]()
                    for (var i = (self.jsonArray?.count)!-1; i > ((self.jsonArray?.count)!-1-self.pageImagesCount); i=i-1){
                        let model = ImageModel()
                        model.imageId = self.jsonArray![i]["id"] as? Int
                        self.imagesList?.append(model)
                    }
                    
                    self.numberOfPage = 1
                    self.tableView.reloadData()
                }
        }

    }
    
    func loadTenOldData(){
        
        for (var i = (self.jsonArray?.count)!-1 - numberOfPage*pageImagesCount; i > ((self.jsonArray?.count)!-self.pageImagesCount-1 - numberOfPage*pageImagesCount); i=i-1){
            let model = ImageModel()
            model.imageId = self.jsonArray![i]["id"] as? Int
            self.imagesList?.append(model)
        }
        self.numberOfPage++
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Pull Up Refresh
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height - 50 > scrollView.contentSize.height{
                print("load more")
            //加载更旧的数据10条
            if numberOfPage != 0{
                loadTenOldData()
            }
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
        self.performSegueWithIdentifier("detailSegue", sender: nil)
    }
    
    
    //MARK: - Switch Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    
}
