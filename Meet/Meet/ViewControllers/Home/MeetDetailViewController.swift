//
//  MeetDetailViewController.swift
//  Demo
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import MJExtension
import SDWebImage

func meetHeight(meetString:String, instrestArray:NSArray) -> CGFloat
{
    var instresTitleString = "  ";
    for string in instrestArray {
        instresTitleString = instresTitleString.stringByAppendingString(string as! String)
        instresTitleString = instresTitleString.stringByAppendingString("    ")
    }
    
    let instrestHeight = instresTitleString.heightWithFont(MeetDetailInterFont, constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 40) + 10
    let titleHeight = meetString.heightWithFont(LoginCodeLabelFont, constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 38)
    return titleHeight + instrestHeight + 60
}

enum PersonType {
    case Man
    case Women
    case Other
}


typealias ReloadHomeListLike = (isLike:Bool, number:NSInteger) -> Void

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
    let userInfoViewModel = UserInfoViewModel()
    
    let imageUrls = NSMutableArray()
    
    var plachImages = NSMutableArray()
    
    var actionSheetSelect:NSInteger! = 0
    
    var loginView:LoginView!
    var isOrderViewPush:Bool = false
    
    var likeButton:UIButton!
    
    var reloadHomeListLike:ReloadHomeListLike!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        super.viewDidLoad()
        self.getHomeDetailModel()
        self.talKingDataPageName = "Home-Detail"
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavigationBar()

        self.navigationController?.navigationBar.translucent = false;
    }
    
    func setUpTableView() {
        self.tableView = UITableView(frame: CGRectZero, style: .Grouped)
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
        self.tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        self.view.addSubview(self.tableView)
        
        
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            if self.bottomView != nil {
                make.bottom.equalTo(self.bottomView.snp_top).offset(0)
            }else{
                make.bottom.equalTo(self.view.snp_bottom).offset(0)
            }
        }
    }
    
    func setUpBottomView(){
        self.bottomView = UIView(frame: CGRectMake(0,ScreenHeight - 49, ScreenWidth, 49))
        self.bottomView.backgroundColor = UIColor.init(hexString: HomeViewWomenColor)
        self.setPersonType(self.personType)
        let singerTap = UITapGestureRecognizer(target: self, action: #selector(MeetDetailViewController.meetImmediately))
        singerTap.numberOfTouchesRequired = 1
        singerTap.numberOfTapsRequired = 1
        self.bottomView.addGestureRecognizer(singerTap)
        let label = UILabel(frame: self.bottomView.bounds)
        label.text = "立即约见"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.init(hexString: "FFFFFF")
        label.font = MeetDetailImmitdtFont
        self.bottomView.addSubview(label)
        self.view.addSubview(self.bottomView)
        
        self.bottomView.snp_makeConstraints { (make) in
            make.height.equalTo(49)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }
    
    func meetImmediately(){
        if UserInfo.isLoggedIn() {
            if UserInfo.sharedInstance().uid == self.user_id {
                MainThreadAlertShow("您不能约见自己哦", view: self.view)
                return
            }
        }
        let applyMeetVc = ApplyMeetViewController()
        applyMeetVc.allItems =  self.inviteArray.mutableCopy() as! NSMutableArray
        applyMeetVc.host = self.user_id
        applyMeetVc.realName = otherUserModel.real_name
        applyMeetVc.jobLabel = otherUserModel.job_label
        applyMeetVc.avater = otherUserModel.avatar
        self.navigationController?.pushViewController(applyMeetVc, animated: true)
    }
    
    func setUpNavigationBar(){
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
        self.setNavigationItemBack()
        self.navigationItemWithLineAndWihteColor()
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
        
        let moreBtn = UIBarButtonItem(image: UIImage.init(named: "navigationbar_more")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(MeetDetailViewController.rigthItemClick(_:)))
        
        
        likeButton = UIButton(type: UIButtonType.Custom)
        likeButton.addTarget(self, action: #selector(MeetDetailViewController.likeButtonPress(_:)), forControlEvents: .TouchUpInside)
        likeButton.frame = CGRectMake(0, 0, 20, 40)
        likeButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        likeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        let likeItem = UIBarButtonItem(customView: likeButton)
        self.navigationItem.rightBarButtonItems = [moreBtn,likeItem]
    }
    
    func setPersonType(personType:PersonType){
        if personType == .Man {
            personTypeString = "他"
        }else{
            personTypeString = "她"
        }
    }
    
    func likeButtonPress(sender:UIButton) {
        if sender.tag == 0 {
            self.otherUserModel.liked_count = self.otherUserModel.liked_count + 1
            self.otherUserModel.cur_user_liked = true
            sender.tag = 1
        }else{
            self.otherUserModel.liked_count = self.otherUserModel.liked_count - 1
            self.otherUserModel.cur_user_liked = false
            sender.tag = 0
        }
        self.changeLikeButton(self.otherUserModel.cur_user_liked)
    }
    
    func leftItemClick(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rigthItemClick(sender:UIBarButtonItem){
        let alertControl = UIAlertController(title: "选择您要进行的操作", message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (cancel) in
            
        }
        let reportAction = UIAlertAction(title: "投诉", style: .Default) { (reportAction) in
            self.actionSheetSelect = 1
            self.reportAction()
        }
        
        let blackListAction = UIAlertAction(title: "加入黑名单", style: .Destructive) { (blackList) in
            self.actionSheetSelect = 2
            self.blackListAction()
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(reportAction)
        alertControl.addAction(blackListAction)
        self.presentViewController(alertControl, animated: true) { 
            
        }
    }
    
    func reportAction() {
        if !UserInfo.isLoggedIn(){
            self.presentLoginView()
        }else{
            let reportVC = ReportViewController()
            reportVC.uid = user_id
            reportVC.myClouse = { _ in
                 MainThreadAlertShow("投诉成功", view: self.view)
            }
            self.navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    func blackListAction() {
        if !UserInfo.isLoggedIn(){
            self.presentLoginView()
        }else{
            let aletControl = UIAlertController.init(title: nil, message: "加入黑名单后，对方将不能再申请约见您；在 “设置-黑名单” 中可撤销此操作。", preferredStyle: UIAlertControllerStyle.Alert)
            let cancleAction = UIAlertAction.init(title: "暂不", style: UIAlertActionStyle.Cancel, handler: { (canCel) in
                (UserInviteModel.shareInstance().results[0]).is_active = true
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let doneAction = UIAlertAction.init(title: "拉黑", style: UIAlertActionStyle.Default, handler: { (canCel) in
                self.userInfoViewModel.makeBlackList(self.user_id, succes: { (dic) in
                    MainThreadAlertShow("拉入黑名单成功", view: self.view)
                    }, fail: { (dic) in
                        MainThreadAlertShow("拉入黑名单失败", view: self.view)
                })
            })
            aletControl.addAction(cancleAction)
            aletControl.addAction(doneAction)
            self.presentViewController(aletControl, animated: true) {
            }
        }
        
    }
    
    func presentLoginView(){
        let loginView = LoginViewController()
        let controller = UINavigationController(rootViewController: loginView)
        loginView.newUserLoginClouse = { _ in
            let baseUserInfo =  Stroyboard("Me", viewControllerId: "BaseInfoViewController") as! BaseUserInfoViewController
            baseUserInfo.user_id = self.user_id
            baseUserInfo.isDetailViewLogin = true
            baseUserInfo.detailViweActionSheetSelect = self.actionSheetSelect
            self.navigationController?.pushViewController(baseUserInfo, animated: true)
        }
        
        loginView.loginWithDetailClouse = { _ in
            if self.actionSheetSelect == 1 {
                self.reportAction()
            }else{
                self.blackListAction()
            }
        }
        
        self.presentViewController(controller, animated: true) { 
            
        }
        
    }
    
    func changeLikeButton(isLike:Bool) {
        self.otherUserModel.cur_user_liked = isLike
        let image = self.otherUserModel.cur_user_liked ? UIImage.init(named: "detail_liked_normal"):UIImage.init(named: "detail_like_normal")
        var number = ""
        if self.otherUserModel.liked_count == 0 {
            number = ""
        }else{
           number = " \(self.otherUserModel.liked_count)"

        }
        likeButton.tag = isLike ? 1:0
        likeButton.setTitle(number, forState: .Normal)
        likeButton.setImage(image, forState: .Normal)
        var frame = likeButton.frame
        frame.size.width = number.stringWidth(number, font: UIFont.systemFontOfSize(14.0), height: 20) + 20
        likeButton.frame = frame
        
        let imageHight = self.otherUserModel.cur_user_liked ? UIImage.init(named: "detail_liked_pressed") : UIImage.init(named: "detail_like_pressed")
        likeButton.setImage(imageHight, forState: .Highlighted)
        
        if self.reloadHomeListLike != nil {
            self.reloadHomeListLike(isLike: isLike,number: self.otherUserModel.liked_count)
        }
        
    }
    
    func getHomeDetailModel(){
        viewModel.getOtherUserInfo(user_id, successBlock: { (dic) in
            self.otherUserModel = HomeDetailModel.mj_objectWithKeyValues(dic)
            let coverPhoto = self.otherUserModel.cover_photo?.photo.componentsSeparatedByString("?")
            self.imageUrls.addObject(coverPhoto![0])
            if self.otherUserModel.head_photo_list != nil {
                var currentImage:NSInteger = 1
                let photoModels = Head_Photo_List.mj_objectArrayWithKeyValuesArray(self.otherUserModel.head_photo_list!)
                for model in photoModels {
                    let photoModel = model as! Head_Photo_List
                    self.imageUrls.addObject(photoModel.photo)
                    currentImage = currentImage + 1
                }
                self.getPlachImage()
            }

            if !self.isOrderViewPush {
                self.setUpBottomView()
                if self.otherUserModel.gender == 1 {
                    self.personType = .Man
                    self.setPersonType(self.personType)
                }
            }
            self.personalArray = self.personalLabelArray
            self.images.addObjectsFromArray(self.imageArray.copy() as! [AnyObject])
            self.setUpTableView()
            self.changeLikeButton(self.otherUserModel.cur_user_liked)
            }, failBlock: { (dic) in
                self.getHomeDetailModel()
        }) { (msg) in
            
        }
    }
    
    lazy var imageArray:NSArray = {
        let tempArray = NSMutableArray()
        
        if self.otherUserModel.user_info!.detail != nil {
            let details = self.otherUserModel.user_info!.detail
            let dtailArray = Detail.mj_objectArrayWithKeyValuesArray(details)
            for detailModel in dtailArray {
                
                let photos = (detailModel as! Detail).photo
                let photosModel = Photos.mj_objectArrayWithKeyValuesArray(photos)
                for model in photosModel {
                    if model.photo != "" {
                        let imageArray = model.photo!.componentsSeparatedByString("?")
                        tempArray.addObject(imageArray[0].stringByAppendingString(HomeDetailMoreInfoImageSize))
                    }
                }
            }
        }
        return tempArray
    }()
    
    lazy var personalLabelArray:NSArray = {
        let tempArray = NSMutableArray()
        tempArray.addObjectsFromArray(self.otherUserModel.personal_label.componentsSeparatedByString(","))
        return tempArray
    }()
    
    lazy var dataArray:NSArray = {
        var tempArray = NSMutableArray()
        let descriptions = self.otherUserModel.user_info!.highlight
        let array = descriptions.componentsSeparatedByString("\n")
        tempArray.addObjectsFromArray(array)
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
        return tempArray
    }()
    
    lazy var personalArray:NSArray = {
        var tempArray = NSArray()
        tempArray = (self.otherUserModel.personal_label.componentsSeparatedByString(","))
        return tempArray
    }()
    
    lazy var engagement:Engagement = {
        let engagement = Engagement.mj_objectWithKeyValues(self.otherUserModel.engagement)
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
                height = height + item.heightWithFont(LoginCodeLabelFont, constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 38) + 10
            }
        }
        
        return height
    }
    
    func meetInfoCellHeight(model:HomeDetailModel) -> CGFloat{
        var height:CGFloat = 62;
        if model.job_label != "" {
            height = height + 47
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
        if self.otherUserModel.distance == "" {
            cell.configCell(self.otherUserModel.real_name, position: self.otherUserModel.job_label, meetNumber: "\(self.otherUserModel.location as String)", interestCollectArray: self.personalArray as [AnyObject],autotnInfo: self.otherUserModel.user_info?.auth_info)
        }else{
            cell.configCell(self.otherUserModel.real_name, position: self.otherUserModel.job_label, meetNumber: "\(self.otherUserModel.location as String)    和你相隔 \(self.otherUserModel.distance as String)", interestCollectArray: self.personalArray as [AnyObject], autotnInfo: self.otherUserModel.user_info?.auth_info)
        }
    }
    
    func configNewMeetCell(cell:NewMeetInfoTableViewCell, indxPath:NSIndexPath)
    {
        cell.configCell(self.otherUserModel.engagement?.introduction_other, array: self.inviteArray as [AnyObject], andStyle: .ItemWhiteColorAndBlackBoard)
    }
    
    func configAboutCell(cell:AboutUsInfoTableViewCell, indxPath:NSIndexPath)
    {
        cell.configCell(self.otherUserModel.user_info?.experience, info: self.otherUserModel.user_info?.highlight, imageArray: self.images as [AnyObject], withUrl: self.otherUserModel.web_url)
    }
    
    func getPlachImage() {
//        let manage = SDWebImageManager()
        let image = UIImage.init(color: UIColor.clearColor(), size: CGSizeMake(100, 100))
//        var index = 0
        for _ in self.imageUrls {
            plachImages.addObject(image)
//            let urlStr = NSURL.init(string: url.stringByAppendingString("?imageView2/1/w/177/h/177"))
//            manage.downloadWithURL(urlStr, options: .RetryFailed, progress: { (star, end) in
//                
//                }, completed: { (image, error, catchs, finist) in
//                    self.plachImages.replaceObjectAtIndex(index, withObject: image)
//                    index = index + 1
//            })
           
        }
        
    }
    
    func headerListImages() -> NSArray {
        let imageArray = NSMutableArray()
        if self.otherUserModel.cover_photo != nil {
            if self.otherUserModel.cover_photo!.photo != "" {
                let imageStrArray = self.otherUserModel.cover_photo!.photo.componentsSeparatedByString("?")
                imageArray.addObject(imageStrArray[0].stringByAppendingString(HomeDetailCovertImageSize))
            }
        }
        let models = Head_Photo_List.mj_objectArrayWithKeyValuesArray(self.otherUserModel.head_photo_list!)
        for model in models {
            let photoModel = model as! Head_Photo_List
            let imageStr = photoModel.photo.stringByAppendingString(HomeDetailCovertImageSize)
            imageArray.addObject(imageStr)
        }
        return imageArray
    }
    
    func presentImageBrowse(index:NSInteger, sourceView:UIView) {

        let photoBrowser = SDPhotoBrowser()
        photoBrowser.delegate = self
        photoBrowser.currentImageIndex = index
        photoBrowser.imageCount = self.imageUrls.count
        photoBrowser.sourceImagesContainerView = sourceView
        photoBrowser.imageBlock = { index in
                
        }
        photoBrowser.show()

    }
}

extension MeetDetailViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 2 {
            let otherInfo =  Stroyboard("Main", viewControllerId: "OtherViewController") as! OtherViewController
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
            return 3
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.otherUserModel.user_info!.highlight == ""{
            return 2
        }else{
            return 3

        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.otherUserModel.user_info?.highlight == ""{
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return (UIScreen.mainScreen().bounds.size.width - 20)*236/355
                case 1:
                    return 195
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
        if self.otherUserModel.user_info?.highlight == "" {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return (UIScreen.mainScreen().bounds.size.width - 20)*236/355
                case 1:
                    return tableView.fd_heightForCellWithIdentifier(meetInfoTableViewCell, configuration: { (cell) in
                        self.configCell(cell as! MeetInfoTableViewCell, indxPath: indexPath)
                    })
                default:
                    return 50
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
                default:
                    return 50
                }
            case 1:
                switch indexPath.row {
                case 0:
                    return 49
                default:
                    return tableView.fd_heightForCellWithIdentifier(aboutUsInfoTableViewCell, configuration: { (cell) in
                        self.configAboutCell(cell as! AboutUsInfoTableViewCell, indxPath: indexPath)
                    })
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
        if self.otherUserModel.user_info?.highlight == "" {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(photoTableViewCell, forIndexPath: indexPath) as! PhotoTableViewCell
                    cell.configCell(self.headerListImages() as [AnyObject], gender: self.otherUserModel.gender , age: self.otherUserModel.age)
                    cell.clickBlock = { index,scourceView in
                        self.presentImageBrowse(index, sourceView: scourceView)
                    }
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCellWithIdentifier(meetInfoTableViewCell, forIndexPath: indexPath) as! MeetInfoTableViewCell
                    self.configCell(cell, indxPath: indexPath)
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
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.configCell("meetdetail_newmeet", titleString: "\(personTypeString)的邀约")
                    cell.userInteractionEnabled = false
                    return cell
                default:
                    let cell = tableView.dequeueReusableCellWithIdentifier(newMeetInfoTableViewCell, forIndexPath: indexPath) as! NewMeetInfoTableViewCell
                    self.configNewMeetCell(cell, indxPath: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.userInteractionEnabled = false
                    cell.isHaveShadowColor(true)
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
                    cell.configCell(self.headerListImages() as [AnyObject], gender: self.otherUserModel.gender , age: self.otherUserModel.age)
                    cell.clickBlock = { index,scourceView in
                        self.presentImageBrowse(index, sourceView: scourceView)
                    }
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCellWithIdentifier(meetInfoTableViewCell, forIndexPath: indexPath) as! MeetInfoTableViewCell
                    self.configCell(cell, indxPath: indexPath)
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
                    cell.userInteractionEnabled = false
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                default:
                    let cell = tableView.dequeueReusableCellWithIdentifier(aboutUsInfoTableViewCell, forIndexPath: indexPath) as! AboutUsInfoTableViewCell
                    self.configAboutCell(cell, indxPath: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                }
                
            case 2:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                    cell.configCell("meetdetail_newmeet", titleString: "\(personTypeString)的邀约")
                    cell.userInteractionEnabled = false
                    return cell
                default:
                    let cell = tableView.dequeueReusableCellWithIdentifier(newMeetInfoTableViewCell, forIndexPath: indexPath) as! NewMeetInfoTableViewCell
                    self.configNewMeetCell(cell, indxPath: indexPath)
                    cell.isHaveShadowColor(true)
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

extension MeetDetailViewController : UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:break
        case 1:
            let aletControl = UIAlertController.init(title: nil, message: "加入黑名单后，对方将不能再申请约见您；在 “设置-黑名单” 中可撤销此操作。", preferredStyle: UIAlertControllerStyle.Alert)
            let cancleAction = UIAlertAction.init(title: "暂不", style: UIAlertActionStyle.Cancel, handler: { (canCel) in
                (UserInviteModel.shareInstance().results[0]).is_active = true
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let doneAction = UIAlertAction.init(title: "拉黑", style: UIAlertActionStyle.Default, handler: { (canCel) in
                self.userInfoViewModel.makeBlackList(self.user_id, succes: { (dic) in
                    MainThreadAlertShow("拉入黑名单成功", view: self.view)
                    }, fail: { (dic) in
                        MainThreadAlertShow("拉入黑名单失败", view: self.view)
                })
            })
            aletControl.addAction(cancleAction)
            aletControl.addAction(doneAction)
            self.presentViewController(aletControl, animated: true) {
                
            }
        default:
            let reportVC = ReportViewController()
            reportVC.uid = user_id
            self.navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    func willPresentActionSheet(actionSheet: UIActionSheet) {
        for subView in actionSheet.subviews {
            if subView.isKindOfClass(UIButton.self) {
                let button = subView as! UIButton
                if button.tag == 1 {
                    button.setTitleColor(UIColor.redColor(), forState: .Normal)
                }
            }
        }
    }
}

extension MeetDetailViewController : SDPhotoBrowserDelegate {
    func photoBrowser(browser: SDPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        return NSURL.init(string: self.imageUrls[index] as! String)
    }
    
    func photoBrowser(browser: SDPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        return plachImages[index] as! UIImage
    }
}

