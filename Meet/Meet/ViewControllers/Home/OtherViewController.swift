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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItemWithLineAndWihteColor()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItemWhiteColorAndNotLine()
    }
    
    func loadData(){
        
        viewModel = HomeViewModel()
        viewModel.getOtherUserInfoProfile(uid, successBlock: { (dic) in
            self.otherProfileModel = OhterProfileModel.mj_objectWithKeyValues(dic)
            
            self.baseInfo.addObject((self.otherProfileModel.base_info?.real_name)!)
            if self.otherProfileModel.base_info?.gender == 1 {
                self.baseInfo.addObject("男")
            }else{
                self.baseInfo.addObject("女")
            }
            self.baseInfo.addObject(String.init(format: "%d", (self.otherProfileModel.base_info?.age)!))
            self.baseInfo.addObject((self.otherProfileModel.base_info?.location)!)
            self.baseInfo.addObject((self.otherProfileModel.base_info?.job_label)!)
            self.tableViewData.addObject(self.baseInfo)
            self.setMoreData()
            self.setWorkeData()
            self.setEduData()
            if self.sectionTitle.count > 0 {
                self.tableView.reloadData()
            }
            }, failBlock: { (dic) in
                
            }) { (msg) in
                
        }
    }
    
    func setMoreData(){
        let moreinfo = self.otherProfileModel.more_info
        let dicKey = ProfileKeyAndValue.shareInstance().appDic as NSDictionary
            
        if moreinfo?.industry != nil {
            let dic = dicKey.objectForKey("industry") as! NSDictionary
            let industry = String.init(format: "%d", (moreinfo?.industry)!)
            if industry != "0" {
                moreInfo.addObject(dic.objectForKey(industry)!)
                moreInfoTitle.addObject("行业")
            }
            
        }
        if moreinfo?.income != nil {
            let dic = dicKey.objectForKey("income") as! NSDictionary
            let income = String.init(format: "%d", (moreinfo?.income)!)
            if income != "0" {
                moreInfo.addObject(dic.objectForKey(income)!)
                moreInfoTitle.addObject("年收入")
            }
        }
        
        if moreinfo?.affection != nil {
            let dic = dicKey.objectForKey("affection") as! NSDictionary
            let affection = String.init(format: "%d", (moreinfo?.affection)!)
            if affection != "0" {
                moreInfo.addObject(dic.objectForKey(affection)!)
                moreInfoTitle.addObject("情感状态")
            }
        }
        
        if moreinfo?.constellation != nil {
            let dic = dicKey.objectForKey("constellation") as! NSDictionary
            let constellation = String.init(format: "%d", (moreinfo?.constellation)!)
            if constellation != "0" {
                moreInfo.addObject(dic.objectForKey(constellation)!)
                moreInfoTitle.addObject("星座")
            }
        }
        if moreInfo.count > 0 {
            sectionTitle.addObject("更多信息")
            self.tableViewData.addObject(moreInfo)
        }
    }
    
    func setWorkeData(){
        if self.otherProfileModel.work != nil{
            let workArray = Work.mj_objectArrayWithKeyValuesArray(self.otherProfileModel.work)
            for workeModel in workArray! {
                let workString = "\(workeModel.company_name)-\(workeModel.profession)"
                workInfo.addObject(workString)
            }
        }
        if workInfo.count > 0 {
            sectionTitle.addObject("工作经历")
            self.tableViewData.addObject(workInfo)
        }
    }
    
    func setEduData(){
        if self.otherProfileModel.edu != nil{
            let eduArray = Edu.mj_objectArrayWithKeyValuesArray(self.otherProfileModel.edu)
            for eduModel in eduArray! {
                let education = (ProfileKeyAndValue.shareInstance().appDic as NSDictionary).objectForKey("education")?.objectForKey("\(eduModel.education)") as! String
                let model = Edu.mj_objectWithKeyValues(eduModel) as Edu
                let eduString = "\(model.graduated)-\(model.major)-\(education)"
                eduInfo.addObject(eduString)
            }
        }
        if eduInfo.count > 0 {
            sectionTitle.addObject("教育背景")
            self.tableViewData.addObject(eduInfo)
        }
    }
    
    func setUpTableView(){
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.registerNib(UINib.init(nibName: "WorkeAndEduTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkeAndEduTableViewCell")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(color: UIColor.clearColor(), size: CGSizeMake(ScreenWidth, 0.5))

    }
    
    func setNavigationBar() {
        self.setNavigationItemBack()
        self.navigationController?.navigationBar.shadowImage = UIImage.init(color: UIColor.lightGrayColor(), size: CGSizeMake(ScreenWidth, 0.5))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension OtherViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tableViewData[section].count
        }else{
            return tableViewData[section].count + 1
         }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section > 0 {
            if indexPath.row == 0 {
                return 65
            }
            if (sectionTitle[indexPath.section - 1] as! String == "工作经历" || sectionTitle[indexPath.section - 1] as! String == "教育背景" && indexPath.row != 0){
                return 112
            }
        }
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.000001
    }
}

extension OtherViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(otherProfileDetailCell, forIndexPath: indexPath) as! OtherProfileInfoTableViewCell
            let stringArray = tableViewData.objectAtIndex(indexPath.section)
            let string = String.init(format: "%@", stringArray.objectAtIndex(indexPath.row) as! String)
            cell.setData(viewModel.baseInfoTitle()[indexPath.row] as! String , info: string )
            cell.userInteractionEnabled = false
            if baseInfo.count - 1 == indexPath.row {
                cell.lineLabel.hidden = true
            }
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(otherProfileCell, forIndexPath: indexPath) as! OtherProfileTableViewCell
                cell.setData(sectionTitle[indexPath.section - 1] as! String)
                cell.userInteractionEnabled = false
                return cell
            }else{
                if sectionTitle[indexPath.section - 1] as! String == "更多信息" {
                    let cell = tableView.dequeueReusableCellWithIdentifier(otherProfileDetailCell, forIndexPath: indexPath) as! OtherProfileInfoTableViewCell
                    let stringArray = tableViewData.objectAtIndex(indexPath.section)
                    let string = String.init(format: "%@", stringArray.objectAtIndex(indexPath.row - 1) as! String)
                    cell.setData(self.moreInfoTitle[indexPath.row - 1] as! String , info: string )
                    if moreInfo.count == indexPath.row {
                        cell.lineLabel.hidden = true
                    }
                    cell.userInteractionEnabled = false
                    return cell
                }else if sectionTitle[indexPath.section - 1] as! String == "工作经历"{
                    let CellIdentiferId = "WorkeAndEduTableViewCell"
                    var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentiferId)
                    if (cell == nil) {
                        let nibs = NSBundle.mainBundle().loadNibNamed("WorkeAndEduTableViewCell", owner: nil, options: nil) as NSArray
                        cell = nibs.lastObject as! WorkeAndEduTableViewCell
                        
                    }
                    if (workInfo.count > 0) {
                        (cell as! WorkeAndEduTableViewCell).setWorkerData(workInfo[indexPath.row - 1] as! String)
                    }
                    if (workInfo.count == indexPath.row) {
                        (cell as! WorkeAndEduTableViewCell).lineLabel.hidden = true
                    }
                    (cell as! WorkeAndEduTableViewCell).eidtImage.hidden = true
                    cell!.userInteractionEnabled = false
                    return cell!
                }else {
                    let CellIdentiferId = "WorkeAndEduTableViewCell"
                    var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentiferId)
                    if (cell == nil) {
                        let nibs = NSBundle.mainBundle().loadNibNamed("WorkeAndEduTableViewCell", owner: nil, options: nil) as NSArray
                        cell = nibs.lastObject as! WorkeAndEduTableViewCell
                        
                    }
                    if (eduInfo.count > 0) {
                        (cell as! WorkeAndEduTableViewCell).setEduData(eduInfo[indexPath.row - 1] as! String)
                    }
                    if (eduInfo.count == indexPath.row) {
                        (cell as! WorkeAndEduTableViewCell).lineLabel.hidden = true
                    }
                    (cell as! WorkeAndEduTableViewCell).eidtImage.hidden = true
                    cell!.userInteractionEnabled = false
                    return cell!
                }
                
            }
        }
    }
}