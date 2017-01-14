//
//  HomepageViewController.swift
//  UnsplashItGallery
//
//  Created by WangHong on 15/12/30.
//  Copyright © 2015年 WangHong. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import ReachabilitySwift


private let kPullUpOffset:CGFloat = 20.0
private let kToPhotoBrowserSegue = "photoBrowserSegue"
private let kCellID = "imageCell"


class HomepageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomepageViewModel()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       setUI()
        //检查JSON有的话先用旧的并刷新
//        if  DataStorageTool.fileExist() {
//            self.jsonArray = DataStorageTool.getJsonData()
//            updateJSONData()s
//        }
        //获得最新json数据
        getLatestData()
        
        //检测网络
        checkNetConnection()
    }
    
    private func setUI(){
        tableView.separatorStyle = .none
        tableView.rowHeight = kWidth/16.0*9.0
        
        //Add pullToRefresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.getLatestData()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshBackgroundColor(UIColor.white)
        tableView.dg_setPullToRefreshFillColor(UIColor.black)
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
    private func getLatestData(){
        
        viewModel.getLatestData { (succeed) in
            if succeed {
                self.tableView.reloadData()
            }else{
                ShowAlert.showAlert(NSLocalizedString("failedToGetLatestData", comment: ""), controller: self)
            }
        }
    }
    
    //结合JSON数据刷新UI
//    func updateJSONData(){
//        if self.jsonArray?.count != 0{
//            self.imagesList = [ImageModel]()
//            
//            let frontIndex = (self.jsonArray?.count)! - 1
//            let backIndex = ((self.jsonArray?.count)! - self.pageImagesCount)
//            
//            for i in (backIndex...frontIndex).reversed() {
//                print(i)
//                    let model = ImageModel()
//                    model.imageId = self.jsonArray![i]["id"] as? Int
//                    model.width = self.jsonArray![i]["width"] as? Int
//                    model.height = self.jsonArray![i]["height"] as? Int
//                    self.imagesList?.append(model)
//            }
//
//            self.numberOfPage = 1
//            self.tableView.reloadData()
//        }
//    }
    
    
    //MARK: - Pull Up Refresh - add Old Data
    // 
    //  为footer增加旋转加载，。
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height - kPullUpOffset > scrollView.contentSize.height{
            viewModel.getMoreData(completion: { (succeed) in
                if succeed {
                    self.tableView.reloadData()
                }
            })
            
        }
    }
    
    //MARK: - Action
    
//    @IBAction func getRandomImage(_ sender: AnyObject) {
//        if self.jsonArray != nil {
//            let random: UInt32 = UInt32((self.jsonArray?.count)!)
//            let randomIndex = Int(arc4random_uniform(random))
//            let indexPath = NSIndexPath(row: randomIndex, section: 0)
//
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let detailVC = sb.instantiateViewController(withIdentifier: "photoBrowser") as! PhotoBrowserController
//            detailVC.currentIndexPath = indexPath
//            detailVC.imagesList  = imagesList;
//            detailVC.modalTransitionStyle = .crossDissolve
//            present(detailVC, animated: true, completion: nil)
//
//        }
//    }
    
    //MARK: - TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainTableViewCell? = tableView.dequeueReusableCell(withIdentifier: kCellID, for: indexPath as IndexPath) as? MainTableViewCell
        
        if (indexPath.row < self.viewModel.imagesList.count){
            let model = self.viewModel.imagesList[indexPath.row]
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
//            detail.imagesList = imagesList
        }
    }
    
}
