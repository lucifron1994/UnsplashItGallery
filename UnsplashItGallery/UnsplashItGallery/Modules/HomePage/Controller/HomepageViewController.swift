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
import SnapKit


private let kToPhotoBrowserSegue = "photoBrowserSegue"
private let kCellID = "imageCell"


class HomepageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var randomItem: UIBarButtonItem!
    var loadingItem: UIBarButtonItem?
    
    private let viewModel = HomepageViewModel()
    private var isGettingMoreData = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        //初始化数据库数据
        viewModel.initDatabase()
        
        //请求第一页数据
        getLatestData()
        
        //检测网络
        checkNetConnection()
    }
    
    private func setUI(){
        tableView.separatorStyle = .none
        tableView.rowHeight = kWidth/16.0*9.0
        
        //TableFooter
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 35))
        footerView.backgroundColor = UIColor.black
        //Footer indeicator
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        footerView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalTo(footerView.snp.center)
        }
        indicator.startAnimating()
        tableView.tableFooterView = footerView
        
        
        //Add pullToRefresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.getLatestData()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshBackgroundColor(UIColor.white)
        tableView.dg_setPullToRefreshFillColor(UIColor.black)
        
        
        //Loading Random Image
        let loadingItemView = UIView(frame: CGRect(x: 5, y: 0, width: 36, height: 36))
        loadingItemView.backgroundColor = UIColor.clear
        let randomIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        randomIndicator.startAnimating()
        loadingItemView.addSubview(randomIndicator)
        randomIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(loadingItemView.center)
        }
        loadingItem = UIBarButtonItem(customView: loadingItemView)
        
    }

    private func checkNetConnection(){
        
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
    
    //MARK: - Pull Up Refresh
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("当前滚动位置 \(scrollView.contentOffset.y + scrollView.frame.size.height) \(scrollView.contentSize.height)")

        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height{
            if isGettingMoreData {
                return
            }
            isGettingMoreData = true
            viewModel.getMoreData(completion: { (succeed) in
                self.isGettingMoreData = false
                if succeed {
                    self.tableView.reloadData()
                }
            })
            
        }

    }
    
    //MARK: - Action
    @IBAction func getRandomImage(_ sender: AnyObject) {
        
        navigationItem.rightBarButtonItem = loadingItem
        
        viewModel.getRandomPhoto { (succeed, imageModel) in
            
            self.navigationItem.rightBarButtonItem = self.randomItem
            
            if succeed {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let detailVC = sb.instantiateViewController(withIdentifier: "photoBrowser") as! PhotoBrowserController
                detailVC.modalTransitionStyle = .crossDissolve
                detailVC.imagesList = [imageModel!]
                detailVC.currentIndexPath = NSIndexPath(item: 0, section: 0)
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }
    
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
            detail.imagesList = viewModel.imagesList
        }
    }
    
}
