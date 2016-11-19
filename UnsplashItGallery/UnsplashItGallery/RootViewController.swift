//
//  RootViewController.swift
//  UnsplashItGallery
//
//  Created by WangHong on 15/12/30.
//  Copyright © 2015年 WangHong. All rights reserved.
//

import UIKit
import Alamofire
import DGElasticPullToRefresh
import ReachabilitySwift

let kWidth = UIScreen.main.bounds.size.width
let kHeight = UIScreen.main.bounds.size.height

let kRootViewImageWidth = kWidth*2
let kRootViewImageHeight = kWidth/16*9*2


private let kPullUpOffset:CGFloat = 20.0
private let kToPhotoBrowserSegue = "photoBrowserSegue"
private let kCellID = "imageCell"
private let BaseUrl = "https://unsplash.it/list"


class RootViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var jsonArray:[AnyObject]?
    fileprivate var imagesList:[ImageModel]?
    
    fileprivate var numberOfPage = 0
    fileprivate var pageImagesCount = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        //Add pullToRefresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.getLatestData()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshBackgroundColor(UIColor.white)
        tableView.dg_setPullToRefreshFillColor(UIColor.black)
        
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
        
       let reachability = Reachability.init()
        //判断连接状态
        if (reachability?.isReachable)!{
            print("网络可用")
        }else{
            print("网络不可用")
            ShowAlert.showAlert(NSLocalizedString("noNetwork", comment: ""), controller: self)
        }
        
    }
    
    
    //MARK: - Fetch Data
    func getLatestData(){
        
        Alamofire.request(BaseUrl).responseJSON { response in
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
            
            for i in (backIndex...frontIndex).reversed() {
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
        for i in (backIndex...frontIndex).reversed() {
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
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height - kPullUpOffset > scrollView.contentSize.height{
//                print("load more")
            //加载更旧的数据10条
            if numberOfPage != 0{
                loadTenOldData()
            }
        }
    }
    
    //MARK: - Action
    
    @IBAction func getRandomImage(_ sender: AnyObject) {
        if self.jsonArray != nil {
            let random: UInt32 = UInt32((self.jsonArray?.count)!)
            let randomIndex = Int(arc4random_uniform(random))
//            let indexPath = NSIndexPath(forItem: randomIndex, inSection: 0)
            let indexPath = NSIndexPath(row: randomIndex, section: 0)

            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "photoBrowser") as! PhotoBrowserController
            detailVC.currentIndexPath = indexPath
            detailVC.jsonArray  = self.jsonArray?.reversed()
            detailVC.modalTransitionStyle = .crossDissolve
            present(detailVC, animated: true, completion: nil)

        }
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kWidth/16.0*9.0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.imagesList?.count == nil{
            return 0;
        }else {
            return (self.imagesList?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainTableViewCell? = tableView.dequeueReusableCell(withIdentifier: kCellID, for: indexPath as IndexPath) as? MainTableViewCell
        
        if (indexPath.row < (self.imagesList?.count)!){
            let model = self.imagesList![indexPath.row]
            cell?.setImageDataSource(model)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          self.performSegue(withIdentifier: kToPhotoBrowserSegue, sender: indexPath)
    }
    
    //MARK: - Switch Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kToPhotoBrowserSegue {
            let detail = segue.destination as! PhotoBrowserController
            detail.currentIndexPath = sender as? NSIndexPath
            detail.jsonArray  = self.jsonArray?.reversed()
        }
    }
    
}
