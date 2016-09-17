//
//  OtherViewController.swift
//  Meet
//
//  Created by Zhang on 7/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import MJExtension

class OtherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var baseInfo:NSMutableArray = NSMutableArray()
    var moreInfo:NSMutableArray = NSMutableArray()
    var workInfo:NSMutableArray = NSMutableArray()
    var eduInfo:NSMutableArray = NSMutableArray()
    
    var tableViewData:NSMutableArray = NSMutableArray()
    var viewModel:HomeViewModel!
    
    var moreInfoTitle = NSMutableArray()
    
    var sectionTitle = NSMutableArray()
    
    var detailModel:HomeDetailModel!
    var otherProfileModel:OhterProfileModel!
    
    var uid:String = ""
    let otherProfileCell = "OtherProfileTableViewCell"
    let otherProfileDetailCell = "OtherProfileInfoTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.setNavigationBar()
        self.talKingDataPageName = "Home-Detail-OtherProfile"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItemWithLineAndWihteColor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItemWhiteColorAndNotLine()
    }
    
    func loadData(){
        
        viewModel = HomeViewModel()
        viewModel.getOtherUserInfoProfile(uid, successBlock: { (dic) in
            self.otherProfileModel = OhterProfileModel.mj_object(withKeyValues: dic)
            
            self.baseInfo.add((self.otherProfileModel.base_info?.real_name)!)
            if self.otherProfileModel.base_info?.gender == 1 {
                self.baseInfo.add("男")
            }else{
                self.baseInfo.add("女")
            }
            self.baseInfo.add(String.init(format: "%d", (self.otherProfileModel.base_info?.age)!))
            self.baseInfo.add((self.otherProfileModel.base_info?.location)!)
            self.baseInfo.add((self.otherProfileModel.base_info?.job_label)!)
            self.tableViewData.add(self.baseInfo)
            self.setMoreData()
            self.setWorkeData()
            self.setEduData()
            if self.tableViewData.count > 0 {
                self.tableView.reloadData()
            }
            }, fail: { (dic) in
                
            }) { (msg) in
                
        }
    }
    
    func setMoreData(){
        let moreinfo = self.otherProfileModel.more_info
        let dicKey = ProfileKeyAndValue.shareInstance().appDic as NSDictionary
            
        if moreinfo?.industry != nil {
            let dic = dicKey.object(forKey: "industry") as! NSDictionary
            let industry = String.init(format: "%d", (moreinfo?.industry)!)
            if industry != "0" {
                moreInfo.add(dic.object(forKey: industry)!)
                moreInfoTitle.add("行业")
            }
            
        }
        if moreinfo?.income != nil {
            let dic = dicKey.object(forKey: "income") as! NSDictionary
            let income = String.init(format: "%d", (moreinfo?.income)!)
            if income != "0" {
                moreInfo.add(dic.object(forKey: income)!)
                moreInfoTitle.add("年收入")
            }
        }
        
        if moreinfo?.affection != nil {
            let dic = dicKey.object(forKey: "affection") as! NSDictionary
            let affection = String.init(format: "%d", (moreinfo?.affection)!)
            if affection != "0" {
                moreInfo.add(dic.object(forKey: affection)!)
                moreInfoTitle.add("情感状态")
            }
        }
        
        if moreinfo?.constellation != nil {
            let dic = dicKey.object(forKey: "constellation") as! NSDictionary
            let constellation = String.init(format: "%d", (moreinfo?.constellation)!)
            if constellation != "0" {
                moreInfo.add(dic.object(forKey: constellation)!)
                moreInfoTitle.add("星座")
            }
        }
        if moreInfo.count > 0 {
            sectionTitle.add("更多信息")
            self.tableViewData.add(moreInfo)
        }
    }
    
    func setWorkeData(){
        if self.otherProfileModel.work != nil{
            let workArray = Work.mj_objectArray(withKeyValuesArray: self.otherProfileModel.work)
            for workeModel in workArray! {
                let workString = "\((workeModel as AnyObject).company_name)-\((workeModel as AnyObject).profession)"
                workInfo.add(workString)
            }
        }
        if workInfo.count > 0 {
            sectionTitle.add("工作经历")
            self.tableViewData.add(workInfo)
        }
    }
    
    func setEduData(){
        if self.otherProfileModel.edu != nil{
            let eduArray = Edu.mj_objectArray(withKeyValuesArray: self.otherProfileModel.edu)
            for eduModel in eduArray! {
                let dic = ProfileKeyAndValue.shareInstance().appDic?["education"] as! NSDictionary
                let education = dic["\((eduModel as AnyObject).education)"] as! String
                let model = Edu.mj_object(withKeyValues: eduModel) as Edu
                let eduString = "\(model.graduated)-\(model.major)-\(education)"
                eduInfo.add(eduString)
            }
        }
        if eduInfo.count > 0 {
            sectionTitle.add("教育背景")
            self.tableViewData.add(eduInfo)
        }
    }
    
    func setUpTableView(){
        self.tableView.backgroundColor = UIColor.white
        self.tableView.register(UINib.init(nibName: "WorkeAndEduTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkeAndEduTableViewCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(color: UIColor.clear, size: CGSize(width: ScreenWidth, height: 0.5))

    }
    
    func setNavigationBar() {
        self.setNavigationItemBack()
        self.navigationController?.navigationBar.shadowImage = UIImage.init(color: UIColor.lightGray, size: CGSize(width: ScreenWidth, height: 0.5))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension OtherViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (tableViewData[section] as AnyObject).count
        }else{
            return (tableViewData[section] as AnyObject).count + 1
         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section > 0 {
            if (indexPath as NSIndexPath).row == 0 {
                return 65
            }
            if (sectionTitle[(indexPath as NSIndexPath).section - 1] as! String == "工作经历" || sectionTitle[(indexPath as NSIndexPath).section - 1] as! String == "教育背景" && (indexPath as NSIndexPath).row != 0){
                return 112
            }
        }
        return 50
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.000001
    }
}

extension OtherViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: otherProfileDetailCell, for: indexPath) as! OtherProfileInfoTableViewCell
            let stringArray = tableViewData.object(at: (indexPath as NSIndexPath).section)
            let string = String.init(format: "%@", (stringArray as AnyObject).object(at: (indexPath as NSIndexPath).row) as! String)
            cell.setData(viewModel.baseInfoTitle()[(indexPath as NSIndexPath).row] as! String , info: string )
            cell.isUserInteractionEnabled = false
            if baseInfo.count - 1 == (indexPath as NSIndexPath).row {
                cell.lineLabel.isHidden = true
            }
            return cell
        }else{
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: otherProfileCell, for: indexPath) as! OtherProfileTableViewCell
                cell.setData(sectionTitle[(indexPath as NSIndexPath).section - 1] as! String)
                cell.isUserInteractionEnabled = false
                return cell
            }else{
                if sectionTitle[(indexPath as NSIndexPath).section - 1] as! String == "更多信息" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: otherProfileDetailCell, for: indexPath) as! OtherProfileInfoTableViewCell
                    let stringArray = tableViewData.object(at: (indexPath as NSIndexPath).section)
                    let string = String.init(format: "%@", (stringArray as AnyObject).object(at: (indexPath as NSIndexPath).row - 1) as! String)
                    cell.setData(self.moreInfoTitle[(indexPath as NSIndexPath).row - 1] as! String , info: string )
                    if moreInfo.count == (indexPath as NSIndexPath).row {
                        cell.lineLabel.isHidden = true
                    }
                    cell.isUserInteractionEnabled = false
                    return cell
                }else if sectionTitle[(indexPath as NSIndexPath).section - 1] as! String == "工作经历"{
                    let CellIdentiferId = "WorkeAndEduTableViewCell"
                    var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentiferId)
                    if (cell == nil) {
                        let nibs = Bundle.main.loadNibNamed("WorkeAndEduTableViewCell", owner: nil, options: nil)! as [Any]
                        cell = nibs.last as! WorkeAndEduTableViewCell
                        
                    }
                    if (workInfo.count > 0) {
                        (cell as! WorkeAndEduTableViewCell).setWorkerData(workInfo[(indexPath as NSIndexPath).row - 1] as! String)
                    }
                    if (workInfo.count == (indexPath as NSIndexPath).row) {
                        (cell as! WorkeAndEduTableViewCell).lineLabel.isHidden = true
                    }
                    (cell as! WorkeAndEduTableViewCell).eidtImage.isHidden = true
                    cell!.isUserInteractionEnabled = false
                    return cell!
                }else {
                    let CellIdentiferId = "WorkeAndEduTableViewCell"
                    var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentiferId)
                    if (cell == nil) {
                        let nibs = Bundle.main.loadNibNamed("WorkeAndEduTableViewCell", owner: nil, options: nil)! as [Any]
                        cell = nibs.last as! WorkeAndEduTableViewCell
                        
                    }
                    if (eduInfo.count > 0) {
                        (cell as! WorkeAndEduTableViewCell).setEduData(eduInfo[(indexPath as NSIndexPath).row - 1] as! String)
                    }
                    if (eduInfo.count == (indexPath as NSIndexPath).row) {
                        (cell as! WorkeAndEduTableViewCell).lineLabel.isHidden = true
                    }
                    (cell as! WorkeAndEduTableViewCell).eidtImage.isHidden = true
                    cell!.isUserInteractionEnabled = false
                    return cell!
                }
                
            }
        }
    }
}
