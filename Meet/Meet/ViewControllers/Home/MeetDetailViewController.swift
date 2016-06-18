//
//  MeetDetailViewController.swift
//  Demo
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import MJExtension

func meetHeight(meetString:String, instrestArray:NSArray) -> CGFloat
{
    var instresTitleString = "  ";
    for string in instrestArray {
        instresTitleString = instresTitleString.stringByAppendingString(string as! String)
        instresTitleString = instresTitleString.stringByAppendingString("    ")
    }
    
    let instrestHeight = instresTitleString.heightWithFont(UIFont.init(name: "PingFangTC-Light", size: 23.0), constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 40) + 10
    let titleHeight = meetString.heightWithFont(UIFont.init(name: "PingFangTC-Light", size: 14.0), constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 38)
    return titleHeight + instrestHeight + 60
}

enum PersonType {
    case Man
    case Women
    case Other
}


class MeetDetailViewController: UIViewController {

    var tableView:UITableView!
    var bottomView:UIView!
    let sectionInfoTableViewCell = "SectionInfoTableViewCell"
    let newMeetInfoTableViewCell = "NewMeetInfoTableViewCell"
    let wantMeetTableViewCell = "WantMeetTableViewCell"
    let aboutUsInfoTableViewCell = "AboutUsInfoTableViewCell"
    let photoTableViewCell = "PhotoTableViewCell"
    let meetInfoTableViewCell = "MeetInfoTableViewCell"
    let compayTableViewCell = "CompayTableViewCell"
    let viewModel = HomeViewModel()
    var otherUserModel = HomeDetailModel()
    var personType = PersonType.Women
    internal var user_id:String = ""
    var personTypeString:String = "她"
    var meetCellHeight:CGFloat = 159
    var images = NSMutableArray()
    
    override func viewDidLoad() {
//        self.navigationController?.navigationBar.translucent = false;
//        self.navigationController?.navigationBar.hidden = false;
//        self.showNavBarAnimated(true)
        self.view.backgroundColor = UIColor.init(hexString: "F2F2F2")
        super.viewDidLoad()
        self.setUpNavigationBar()
        self.setUpBottomView()
        self.getHomeDetailModel()
        // Do any additional setup after loading the view.
    }

    func setUpTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64 - 49), style: .Grouped)
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.registerClass(PhotoTableViewCell.self, forCellReuseIdentifier: photoTableViewCell)
        self.tableView.registerClass(CompayTableViewCell.self, forCellReuseIdentifier: compayTableViewCell)
        self.tableView.registerClass(MeetInfoTableViewCell.self, forCellReuseIdentifier: meetInfoTableViewCell)
        self.tableView.registerClass(AboutUsInfoTableViewCell.self, forCellReuseIdentifier: aboutUsInfoTableViewCell)
        self.tableView.registerClass(SectionInfoTableViewCell.self, forCellReuseIdentifier: sectionInfoTableViewCell)
        self.tableView.registerClass(NewMeetInfoTableViewCell.self, forCellReuseIdentifier: newMeetInfoTableViewCell)
        self.tableView.registerClass(WantMeetTableViewCell.self, forCellReuseIdentifier: wantMeetTableViewCell)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.view.addSubview(self.tableView)
        
        
    }
    
    func setUpBottomView(){
        self.bottomView = UIView(frame: CGRectMake(0,UIScreen.mainScreen().bounds.size.height - 49 - 64, ScreenWidth, 49))
        self.setPersonType(self.personType)
        let label = UILabel(frame: self.bottomView.bounds)
        label.text = "立即约见"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.init(hexString: "FFFFFF")
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        self.bottomView.addSubview(label)
        self.view.addSubview(self.bottomView)
    }
    
    func setUpNavigationBar(){

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeetDetailViewController.leftItemClick(_:)))
        self.navigaitonItemColor(UIColor.init(hexString: "202020"))
        /**
         第一个版本去除按钮
         
         - parameter hexString: 
         */
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.init(hexString: "202020")
//        let uploadBt = UIButton(type: UIButtonType.Custom)
//        uploadBt.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        uploadBt.setImage(UIImage(named: "navigationbar_upload"), forState: UIControlState.Normal)
//        uploadBt.frame = CGRectMake(0, 0, 40, 40);
//        let uploadItem = UIBarButtonItem(customView: uploadBt)
//        
//        let colloctBt = UIButton(type: UIButtonType.Custom)
//        colloctBt.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        colloctBt.setImage(UIImage(named: "navigationbar_collect"), forState: UIControlState.Normal)
//        colloctBt.frame = CGRectMake(0, 0, 60, 40);
//        colloctBt.titleLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 14.0)
//        colloctBt.setTitle(" 668", forState: UIControlState.Normal)
//        let colloctItem = UIBarButtonItem(customView: colloctBt)
//        self.navigationItem.rightBarButtonItems = [uploadItem,colloctItem]
    }
    
    func setPersonType(personType:PersonType){
        if personType == .Man {
            self.bottomView.backgroundColor = UIColor.init(hexString: "009FE8")
            personTypeString = "他"
        }else{
            self.bottomView.backgroundColor = UIColor.init(hexString: "FF4F4F")
            personTypeString = "她"
        }
    }
    
    func leftItemClick(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rigthItemClick(sender:UIBarButtonItem){
        
    }
    
    func getHomeDetailModel(){
        viewModel.getOtherUserInfo(user_id, successBlock: { (dic) in
            self.otherUserModel = HomeDetailModel.mj_objectWithKeyValues(dic)
            if self.otherUserModel.gender == 1 {
               self.personType = .Man
               self.setPersonType(self.personType)
            }
            self.personalArray = self.personalLabelArray
            self.images.addObjectsFromArray(self.imageArray.copy() as! [AnyObject])
            self.setUpTableView()
            }, failBlock: { (dic) in
                self.getHomeDetailModel()
        }) { (msg) in
            
        }
    }
    
    lazy var imageArray:NSArray = {
        let tempArray = NSMutableArray()
        if self.otherUserModel.user_info != nil {
            tempArray.addObject(self.otherUserModel.user_info!.cover_photo!)
            let details = self.otherUserModel.user_info!.detail
            let dtailArray = Detail.mj_objectArrayWithKeyValuesArray(details)
            for detailModel in dtailArray {
                for urlString in detailModel.photo! {
                    if urlString != "" {
                        tempArray.addObject(urlString)
                    }
                }
            }
        }
        return tempArray
    }()
    
    lazy var personalLabelArray:NSArray = {
        let tempArray = NSMutableArray()
        if self.otherUserModel.personal_label != nil {
            tempArray.addObjectsFromArray(self.otherUserModel.personal_label!.componentsSeparatedByString(","))
        }
        return tempArray
    }()
    
    lazy var dataArray:NSArray = {
        var tempArray = NSMutableArray()
        if self.otherUserModel.user_info!.detail != nil {
            let descriptions = self.otherUserModel.user_info!.highlight
            let array = descriptions!.componentsSeparatedByString("\r\n")
            tempArray.addObjectsFromArray(array)
        }
        print("我就运行一次")
        return tempArray
    }()
    
    lazy var inviteArray:NSArray = {
        let tempArray = NSMutableArray()
        let dic = (ProfileKeyAndValue.shareInstance().appDic as NSDictionary).objectForKey("invitation") as! NSDictionary
        if self.otherUserModel.engagement!.theme != nil {
            let themes = self.otherUserModel.engagement!.theme!
            let themesArray = Theme.mj_objectArrayWithKeyValuesArray(themes)
            for theme in themesArray {
                
                tempArray.addObject(dic.objectForKey(theme.theme!)!)
            }
        }
        print("我就运行一次")
        return tempArray
    }()
    
    lazy var personalArray:NSArray = {
        var tempArray = NSArray()
        if self.otherUserModel.personal_label == nil {
            
        }else{
            tempArray = (self.otherUserModel.personal_label?.componentsSeparatedByString(","))!
        }
        print("我就运行一次")
        return tempArray
    }()
    
    lazy var engagement:Engagement = {
        let engagement = Engagement.mj_objectWithKeyValues(self.otherUserModel.engagement)
        print("我就运行一次")
        return engagement
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aboutUsHeight(stringArray:NSArray) -> CGFloat {
        var height:CGFloat = 10.0
        for item in stringArray {
            _ = item as! String
            height = height + item.heightWithFont(UIFont.init(name: "PingFangTC-Light", size: 14.0), constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 38) + 10
        }
        
        return height
    }
    
    func meetInfoCellHeight(model:HomeDetailModel) -> CGFloat{
        var height:CGFloat = 62;
        if model.job_label != nil {
            if model.job_label != "" {
               height = height + 47
            }
        }
        height = height + 24;
        if self.personalArray.count > 0 {
            
        }else{
            height = height + 62
        }
        return height;
    }

    func configCell(cell:MeetInfoTableViewCell, indxPath:NSIndexPath)
    {
        cell.fd_enforceFrameLayout = false;
        // Enable to use "-sizeThatFits:"
        cell.configCell(self.otherUserModel.real_name, position: self.otherUserModel.job_label, meetNumber: "上海 浦东新区   和你相隔28200m", interestCollectArray: self.personalArray as [AnyObject])
    }
    
    func configNewMeetCell(cell:NewMeetInfoTableViewCell, indxPath:NSIndexPath)
    {
        cell.fd_enforceFrameLayout = false;
        // Enable to use "-sizeThatFits:"
        cell.configCell(self.otherUserModel.engagement?.engagement_desc, array: self.inviteArray as [AnyObject])
        let height = cell.getCellHeight(self.otherUserModel.engagement?.engagement_desc, array: self.inviteArray as [AnyObject])
        print("=================\(height)")
        if self.otherUserModel.engagement != nil {
            
        }
    }

    func aboutUsDetailBtPress(){
        print("ddddddd")
    }
}

extension MeetDetailViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension MeetDetailViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return (UIScreen.mainScreen().bounds.size.width - 20)*236/355
            case 1:
                return 195
            case 2:
                
                return 77
            default:
                return 49
            }
        case 1:
            switch indexPath.row {
            case 0:
                return 49
            default:
                return 210;
//                return self.aboutUsHeight(["毕业于中央戏剧学院表演系，是一名制片人，也是隐舍 THESECRET 的掌门人。","最不像表演系的表演系学生，这点从入学开始就逐渐暴露，同学和老师评价我是表演系里最会导演的，导演系里最会制片的，制片专业里长得最好看。","喜欢戏剧，喜欢电影，喜欢旅行，做过制片人，地产，投资，酒吧。"]) + 30 + 20
            }
        case 2:
            switch indexPath.row {
            case 0:
                return 49
            default:
                
                return 223
            }
        default:
            switch indexPath.row {
            case 0:
                return 49
            default:
                return 123
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return (UIScreen.mainScreen().bounds.size.width - 20)*236/355
            case 1:
                return tableView.fd_heightForCellWithIdentifier(meetInfoTableViewCell, configuration: { (cell) in
                    self.configCell(cell as! MeetInfoTableViewCell, indxPath: indexPath)
                })
//                if self.otherUserModel.real_name == nil {
//                    return 195;
//                }else{
//                    return 195
//                    //return self.meetInfoCellHeight(self.otherUserModel) + 20
//                }
//                
            case 2:
                return 104
                
            default:
                return 49
            }
        case 1:
            switch indexPath.row {
            case 0:
                return 49
            default:
                return self.aboutUsHeight(self.dataArray) + 30 + 50
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                return 49
            default:
                return meetCellHeight
//                if self.engagement.engagement_desc != nil {
//                    return tableView.fd_heightForCellWithIdentifier(newMeetInfoTableViewCell, configuration: { (cell) in
//                        self.configNewMeetCell(cell as! NewMeetInfoTableViewCell, indxPath: indexPath)
//                    })
////                    return meetHeight((self.otherUserModel.engagement?.engagement_desc)!, instrestArray: self.personalArray)
//                }else{
//                    return meetHeight("", instrestArray: self.personalArray)
//                }
            }
        default:
            switch indexPath.row {
            case 0:
                return 49
            default:
                return 123
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(photoTableViewCell, forIndexPath: indexPath) as! PhotoTableViewCell
                    cell.configCell(self.images as [AnyObject])
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCellWithIdentifier(meetInfoTableViewCell, forIndexPath: indexPath) as! MeetInfoTableViewCell
                    self.configCell(cell, indxPath: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.userInteractionEnabled = false
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCellWithIdentifier(compayTableViewCell, forIndexPath: indexPath) as! CompayTableViewCell
                    cell.configCell(self.otherUserModel.user_info?.auth_info)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.userInteractionEnabled = false
                    return cell
                default:
                    let identifier = "MoreTableViewCell"
                    var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
                    if cell == nil{
                        cell = AllInfoTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
                    }
                    return cell!
                }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                    cell.configCell("meetdetail_aboutus", titleString: "关于\(personTypeString)")
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(aboutUsInfoTableViewCell, forIndexPath: indexPath) as! AboutUsInfoTableViewCell
                cell.configCell(self.dataArray as [AnyObject], withGender: self.otherUserModel.gender)
                cell.aboutAll.addTarget(self, action: #selector(MeetDetailViewController.aboutUsDetailBtPress), forControlEvents: UIControlEvents.TouchUpInside)
                cell.block = { _ in
                    self.navigationController?.pushViewController(AboutDetailViewController(), animated: true)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = false
                return cell
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                cell.configCell("meetdetail_newmeet", titleString: "\(personTypeString)的邀约")
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(newMeetInfoTableViewCell, forIndexPath: indexPath) as! NewMeetInfoTableViewCell
                cell.block = { (height) in
                    self.meetCellHeight = height + 80
                    let index = NSIndexPath.init(forRow: 1, inSection: 2)
                
                    self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                self.configNewMeetCell(cell, indxPath: indexPath)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = false
                return cell
            }
        default:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                cell.configCell("meetdetail_wantmeet", titleString: "更多想见的人")
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(wantMeetTableViewCell, forIndexPath: indexPath) as! WantMeetTableViewCell
                cell.textLabel?.text = "更多想见的人"
                return cell
            }
        }
        
    }
}


