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
        self.getHomeDetailModel()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
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
        let singerTap = UITapGestureRecognizer(target: self, action: #selector(MeetDetailViewController.meetImmediately))
        singerTap.numberOfTouchesRequired = 1
        singerTap.numberOfTapsRequired = 1
        self.bottomView.addGestureRecognizer(singerTap)
        let label = UILabel(frame: self.bottomView.bounds)
        label.text = "立即约见"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.init(hexString: "FFFFFF")
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        self.bottomView.addSubview(label)
        self.view.addSubview(self.bottomView)
    }
    
    func meetImmediately(){
        if !UserInfo.isLoggedIn(){
            let meStoryBoard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
            let resgisterVc = meStoryBoard.instantiateViewControllerWithIdentifier("weChatResgisterNavigation")
            self.presentViewController(resgisterVc, animated: true, completion: {
                
            });
        }else{
            let meetView = MeetWebViewController()
            meetView.url = "https://jinshuju.net/f/yzVBmI"
            self.navigationController?.pushViewController(meetView, animated: true)
        }
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
            self.setUpBottomView()
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
        if self.otherUserModel.cover_photo != nil {
            if self.otherUserModel.cover_photo!.photo != "" &&  self.otherUserModel.cover_photo!.photo != nil{
                tempArray.addObject(self.otherUserModel.cover_photo!.photo)
            }
        }
        if self.otherUserModel.user_info!.detail != nil {
            let details = self.otherUserModel.user_info!.detail
            let dtailArray = Detail.mj_objectArrayWithKeyValuesArray(details)
            for detailModel in dtailArray {
                let photos = (detailModel as! Detail).photos
                let photosModel = Photos.mj_objectArrayWithKeyValuesArray(photos)
                for model in photosModel {
                    if model.photo != "" {
                        tempArray.addObject(model.photo!)
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
            let array = descriptions!.componentsSeparatedByString("\n")
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
            let string = item as! String
            if string != "" {
                height = height + item.heightWithFont(UIFont.init(name: "PingFangTC-Light", size: 14.0), constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 38) + 10
            }
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
        cell.configCell(self.otherUserModel.real_name, position: self.otherUserModel.job_label, meetNumber: "\(self.otherUserModel.location! as String)    和你相隔 \(self.otherUserModel.distance as String)", interestCollectArray: self.personalArray as [AnyObject])
    }
    
    func configNewMeetCell(cell:NewMeetInfoTableViewCell, indxPath:NSIndexPath)
    {
        cell.configCell(self.otherUserModel.engagement?.introduction_other, array: self.inviteArray as [AnyObject])
    }

}

extension MeetDetailViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 3 {
            let mainStory = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
            let otherInfo = mainStory.instantiateViewControllerWithIdentifier("OtherViewController") as! OtherViewController
            otherInfo.uid = user_id
            self.navigationController?.pushViewController(otherInfo, animated: true)
        }else if indexPath.section == 1 && indexPath.row == 1 && self.otherUserModel.user_info!.highlight != ""  && self.otherUserModel.web_url != ""{
            let meetWebView = AboutDetailViewController()
            meetWebView.url = "\(RequestBaseUrl)\(self.otherUserModel.web_url)"
            self.navigationController?.pushViewController(meetWebView, animated: true)
        }
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
        if self.otherUserModel.user_info!.highlight == "" || self.otherUserModel.user_info?.highlight == nil {
            return 2
        }else{
            return 3

        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.otherUserModel.user_info?.highlight == "" || self.otherUserModel.user_info?.highlight == nil {
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
        }else {
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
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.otherUserModel.user_info?.highlight == "" || self.otherUserModel.user_info?.highlight  == nil {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return (UIScreen.mainScreen().bounds.size.width - 20)*236/355
                case 1:
                    return tableView.fd_heightForCellWithIdentifier(meetInfoTableViewCell, configuration: { (cell) in
                        self.configCell(cell as! MeetInfoTableViewCell, indxPath: indexPath)
                    })
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
                    return tableView.fd_heightForCellWithIdentifier(newMeetInfoTableViewCell, cacheByKey: self.user_id, configuration: { (cell) in
                        self.configNewMeetCell(cell as! NewMeetInfoTableViewCell, indxPath: indexPath)

                    })
                }
            default:
                switch indexPath.row {
                case 0:
                    return 49
                default:
                    return 123
                }
            }
        }else{
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return (UIScreen.mainScreen().bounds.size.width - 20)*236/355
                case 1:
                    return tableView.fd_heightForCellWithIdentifier(meetInfoTableViewCell, configuration: { (cell) in
                        self.configCell(cell as! MeetInfoTableViewCell, indxPath: indexPath)
                    })
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
                    return tableView.fd_heightForCellWithIdentifier(newMeetInfoTableViewCell, cacheByKey: self.user_id, configuration: { (cell) in
                        self.configNewMeetCell(cell as! NewMeetInfoTableViewCell, indxPath: indexPath)
                        
                    })
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
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.otherUserModel.user_info?.highlight == "" || self.otherUserModel.user_info?.highlight  == nil {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(photoTableViewCell, forIndexPath: indexPath) as! PhotoTableViewCell
                    cell.configCell(self.images as [AnyObject], gender: self.otherUserModel.gender , age: self.otherUserModel.age)
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
//                    cell.userInteractionEnabled = false
                    return cell
                default:
                    let identifier = "MoreTableViewCell"
                    let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! AllInfoTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.Blue
                    return cell
                }
            case 1:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.configCell("meetdetail_newmeet", titleString: "\(personTypeString)的邀约")
                    return cell
                default:
                    let cell = tableView.dequeueReusableCellWithIdentifier(newMeetInfoTableViewCell, forIndexPath: indexPath) as! NewMeetInfoTableViewCell
                    self.configNewMeetCell(cell, indxPath: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.userInteractionEnabled = false
                    return cell
                }
            default:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.configCell("meetdetail_wantmeet", titleString: "更多想见的人")
                    return cell
                default:
                    let cell = tableView.dequeueReusableCellWithIdentifier(wantMeetTableViewCell, forIndexPath: indexPath) as! WantMeetTableViewCell
                    cell.textLabel?.text = "更多想见的人"
                    return cell
                }
            }
        }else{
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(photoTableViewCell, forIndexPath: indexPath) as! PhotoTableViewCell
                    cell.configCell(self.images as [AnyObject], gender: self.otherUserModel.gender , age: self.otherUserModel.age)
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
                    cell?.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell!
                }
            case 1:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                    cell.configCell("meetdetail_aboutus", titleString: "关于\(personTypeString)")
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                default:
                    let cell = tableView.dequeueReusableCellWithIdentifier(aboutUsInfoTableViewCell, forIndexPath: indexPath) as! AboutUsInfoTableViewCell
                    cell.configCell(self.dataArray as [AnyObject], withUrl: self.otherUserModel.web_url)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
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
}


