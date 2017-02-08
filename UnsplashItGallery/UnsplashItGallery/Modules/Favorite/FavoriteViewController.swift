//
//  FavoriteViewController.swift
//  UnsplashItGallery
//
//  Created by wanghong on 2017/2/7.
//  Copyright © 2017年 WangHong. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBarItem: UIBarButtonItem!
    
    private let dbHelper = DataBaseHelper.shareHelper
    fileprivate var dataList:[ImageModel] = [ImageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initDBData()
        setUI()
    }
    
    private func initDBData(){
        dbHelper.createFavoriteTable()
        dbHelper.getFavoriteData { (models) in
            dataList = models
        }
    }
    
    private func setUI(){
        let backItem = UIBarButtonItem(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(self.popViewController))
        self.navigationItem.leftBarButtonItem = backItem
        backItem.imageInsets = UIEdgeInsetsMake(0, -15, 0, 15)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = kWidth/16.0*9.0
        tableView.tableFooterView = UIView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func deleteAllData(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Confirm", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        let ok = UIAlertAction(title: "Sure", style: .default) { (action) in
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    func popViewController(){
        _ = navigationController?.popViewController(animated: true)
    }
}


extension FavoriteViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainTableViewCell? = tableView.dequeueReusableCell(withIdentifier: kCellID, for: indexPath as IndexPath) as? MainTableViewCell
        
        if (indexPath.row < self.dataList.count){
            let model = self.dataList[indexPath.row]
            cell?.setImageDataSource(model)
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
        }
        return [delete]
    }
}
