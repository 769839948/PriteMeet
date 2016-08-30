//
//  MeViewController.swift
//  Demo
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class MeViewController: UIViewController {

    var tableView:UITableView!
    var imagesArray = NSMutableArray()
    var headImage:UIImage!
    var statusBar:UIView!
    var frame:CGRect!
    
    var userInfoModel = UserInfoViewModel()
    var meInfoTableViewCell = "MeInfoTableViewCell"
    var mePhotoTableViewCell = "MePhotoTableViewCell"
    var photoDetailTableViewCell = "PhotoDetailTableViewCell"
    let newMeetInfoTableViewCell = "NewMeetInfoTableViewCell"
    
    var meetCellHeight:CGFloat = 159
    
    var loginView:LoginView!
    
    let orderNumberArray:NSMutableArray = NSMutableArray()
    var allOrderNumber:NSInteger = 0
    
    var navigaitionTitleView: UIView!
    var dismissButton:UIButton!
    
    var editButton:UIButton!
    var settingButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.loadExtenInfo()
        if UserInfo.isLoggedIn() {
            self.getOrderNumber()
        }
        self.addLineNavigationBottom()
        self.talKingDataPageName = "Me"
        self.setUpNavigationTitleView()
        self.navigationItemWithLineAndWihteColor()
    }

    func setUpNavigationTitleView() {
        navigaitionTitleView = UIView()
        navigaitionTitleView.userInteractionEnabled = true
        self.view.addSubview(navigaitionTitleView)
        
        editButton = UIButton(type: .Custom)
        editButton.setImage(UIImage.init(named: "me_editBlack"), forState: .Normal)
        editButton.addTarget(self, action: #selector(MeViewController.editPress(_:)), forControlEvents: .TouchUpInside)
        navigaitionTitleView.addSubview(editButton)
        
        settingButton = UIButton(type: .Custom)
        settingButton.setImage(UIImage.init(named: "me_settingsBlack"), forState: .Normal)
        settingButton.addTarget(self, action: #selector(MeViewController.rightPress(_:)), forControlEvents: .TouchUpInside)
        navigaitionTitleView.addSubview(settingButton)
        
        dismissButton = UIButton(type: .Custom)
        dismissButton.setImage(UIImage.init(named: "me_dismissBlack"), forState: .Normal)
        dismissButton.addTarget(self, action: #selector(MeViewController.cancelPress(_:)), forControlEvents: .TouchUpInside)
        navigaitionTitleView.addSubview(dismissButton)
        
        navigaitionTitleView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.height.equalTo(64)
        }
        
        dismissButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.navigaitionTitleView.snp_top).offset(22)
            make.left.equalTo(self.navigaitionTitleView.snp_left).offset(10)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        
        settingButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.navigaitionTitleView.snp_top).offset(22)
            make.right.equalTo(self.navigaitionTitleView.snp_right).offset(-10)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        
        editButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.navigaitionTitleView.snp_top).offset(22)
            make.right.equalTo(self.settingButton.snp_left).offset(-10)
            make.size.equalTo(CGSizeMake(40, 40))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setNavigationBar()
        if UserInfo.isLoggedIn() {
            self.lastModifield()
            self.loadExtenInfo()
            self.loadInviteInfo()
        
        }
        if (UserInfo.sharedInstance().isFirstLogin && UserInfo.isLoggedIn()) {
            UserInfo.sharedInstance().isFirstLogin = false
            self.loadInviteInfo()
        }
    }
    
    func lastModifield(){
        userInfoModel.lastModifield({ (updateTime) in
            if NSUserDefaults.standardUserDefaults().objectForKey("lastModifield") != nil{
                let tempTime = NSUserDefaults.standardUserDefaults().objectForKey("lastModifield")
                if (tempTime as! String) != (updateTime as String){
                    self.userInfoModel.getUserInfo(UserInfo.sharedInstance().uid, success: { (dic) in
                        UserInfo.synchronizeWithDic(dic)
                        self.tableView.reloadData()
                        NSUserDefaults.standardUserDefaults().setObject(updateTime, forKey: "lastModifield")
                        }, fail: { (dic) in
                            
                        }, loadingString: { (msg) in
                            
                    })
                }
            }else{
                NSUserDefaults.standardUserDefaults().setObject(updateTime, forKey: "lastModifield")
            }
        }) { (error) in
                
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
    }
    
    func setUpTableView(){
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        
        let meInfoNib = UINib(nibName: "MeInfoTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(meInfoNib, forCellReuseIdentifier: "MeInfoTableViewCell")
        let mePhotoNib = UINib(nibName: "MePhotoTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(mePhotoNib, forCellReuseIdentifier: "MePhotoTableViewCell")
        let mePhotoDetailNib = UINib(nibName: "PhotoDetailTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(mePhotoDetailNib, forCellReuseIdentifier: "PhotoDetailTableViewCell")
        self.tableView.registerClass(NewMeetInfoTableViewCell.self, forCellReuseIdentifier: newMeetInfoTableViewCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.view.addSubview(tableView)

        tableView.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.view.snp_top).offset(-20)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        })
    }
    
    func loadExtenInfo(){
        userInfoModel.getMoreExtInfo("", success: { (dic) in
            UserExtenModel.synchronizeWithDic(dic)
            }, fail: { (dic) in
                
            }, loadingString: { (msg) in
              
        })
    }
    
    func loadInviteInfo(){
        userInfoModel.getInvite({ (dic) in
            UserInviteModel.synchronizeWithDic(dic)
            self.tableView.reloadData()
            }, fail: { (dic) in
                
            }) { (msg) in
                
        }
    }
    
    func setNavigationBar(){
        if UserInfo.isLoggedIn() {
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)    
            self.setLeftBarItem()
        }else{
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
            self.setNavigationItemAplah(1, imageName: ["me_dismissBlack"], type: 1)
            self.setNavigationItemAplah(1, imageName: ["me_settingsBlack"], type: 2)
            
        }
    }
    
    func setLeftBarItem(){
        if self.tableView.contentOffset.y > 160 {
            self.setNavigationItemAplah(1, imageName: ["me_dismissBlack"], type: 1)
            
            if UserInfo.sharedInstance().completeness.next_page != 4 {
                self.setNavigationItemAplah(1, imageName: ["me_settingsBlack"], type: 2)
            }else{
                self.setNavigationItemAplah(1, imageName: ["me_settingsBlack","me_editBlack"], type: 3)
            }
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        }else{
            self.setNavigationItemAplah(1, imageName: ["me_dismiss"], type: 1)
            
            if UserInfo.sharedInstance().completeness.next_page != 4 {
                self.setNavigationItemAplah(1, imageName: ["me_settings"], type: 2)
            }else{
                self.setNavigationItemAplah(1, imageName: ["me_settings","me_edit"], type: 3)
            }
        }
        
        
    }
    /**
     设置navigaitonBarItem颜色
     
     - parameter imageAplah: 颜色的透明度
     - parameter imageName:  图片名字
     - parameter type:       navigationbarType[1,2,3]
     */
    func setNavigationItemAplah(imageAplah:CGFloat, imageName:NSArray, type:NSInteger)  {
        if type == 1 {
            let image = UIImage(named: imageName[0] as! String)?.imageByApplyingAlpha(imageAplah)
            dismissButton.setImage(image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: .Normal)
        }else if type == 2{
            editButton.hidden = true
            let image = UIImage(named: imageName[0] as! String)?.imageByApplyingAlpha(imageAplah)
            settingButton.setImage(image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: .Normal)
        }else{
            let image = UIImage(named: imageName[0] as! String)?.imageByApplyingAlpha(imageAplah)
            settingButton.setImage(image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: .Normal)
            let image1 = UIImage(named: imageName[1] as! String)?.imageByApplyingAlpha(imageAplah)
            editButton.setImage(image1?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: .Normal)
            editButton.hidden = false
        }
    }
    
    
    func cancelPress(sender:UIButton){
        self.dismissViewControllerAnimated(true) { 
        }
    }
    
    func editPress(sender:UIButton){
        self.pushProfileViewControllr()
    }
    
    func rightPress(sender:UIButton){
        let settingVC = Stroyboard("Seting", viewControllerId: "SetingViewController") as!  SetingViewController
        settingVC.logoutBlock = {()
            self.tableView.reloadData()
        }
        self.navigationController!.pushViewController(settingVC, animated:true)
    }
    
    
    func downLoadUserWeChatImage(){
        NetWorkObject.downloadTask(UserInfo.sharedInstance().avatar, progress: { (Progress) in
            
            }, destination: { (url, response) -> NSURL! in
                var documentsDirectoryURL = NSURL()
                do{
                    documentsDirectoryURL = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
                }catch{
                    
                }
                return documentsDirectoryURL .URLByAppendingPathComponent(response.suggestedFilename!)
        }) {(response, url, error) in
                let image = UIImage(contentsOfFile: url.path!)
                UserInfo.saveCacheImage(image, withName: "cover_photo")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pushViewController(tag:NSInteger){
        switch tag {
        case 1:
            self.pushProfileViewControllr()
            break
        case 2:
            self.pushProfileViewControllr()
            break
        case 3:
            self.presentAddStarViewController()
            break
        case 4:
            self.presentMoreProfileViewController()
            break
        default: break
            
        }
    }
    
    func pushProfileViewControllr() {
        let myProfileVC = Stroyboard("Me", viewControllerId: "MyProfileViewController") as!  MyProfileViewController
        myProfileVC.fromeMeView = true
        myProfileVC.hightLight = UserExtenModel.shareInstance().highlight
        myProfileVC.reloadMeViewBlock = {(uodataInfo:Bool) in
            self.setLeftBarItem()
            self.tableView.reloadData()
        }
        self.navigationController!.pushViewController(myProfileVC, animated:true)
    }
    /**
     添加个人亮点
     */
    func presentAddStarViewController(){
        let addStarVC =  Stroyboard("Me", viewControllerId: "AddStarViewController") as!  AddStarViewController
        let controller = BaseNavigaitonController(rootViewController: addStarVC)
        self.navigationController!.presentViewController(controller, animated: true, completion: {
            
        })

    }
    /**
     展示更多个人信息
     */
    func presentMoreProfileViewController(){
        let moreProfileView = Stroyboard("Me", viewControllerId: "MoreProfileViewController") as!  MoreProfileViewController
        let controller = BaseNavigaitonController(rootViewController: moreProfileView)
        self.navigationController!.presentViewController(controller, animated: true, completion: {
            
        })
        
    }
    /**
     邀约collectionView高度
     
     - returns: 高度
     */
    func inviteHeight() -> CGFloat {
        return meetHeight(self.descriptionString(), instrestArray: self.instrestArray())
    }
    
    func descriptionString() -> String {
        let description = UserInviteModel.descriptionString(0)
        return description
    }
    
    func instrestArray() -> NSArray {
        let array = NSMutableArray()
        array.addObjectsFromArray(UserInviteModel.themArray(0))
        return array.copy() as! NSArray
    }
    
    func configNewMeetCell(cell:NewMeetInfoTableViewCell, indxPath:NSIndexPath)
    {
        cell.fd_enforceFrameLayout = false;
        cell.configCell(self.descriptionString(), array: self.instrestArray() as [AnyObject], andStyle: .ItemWhiteColorAndBlackBoard)
    }
    
    func presentViewLoginViewController(){
        loginView = LoginView(frame: CGRectMake(0,0,ScreenWidth,ScreenHeight))
        let windown = UIApplication.sharedApplication().keyWindow
        windown!.addSubview(loginView)
        loginView.applyCodeClouse = { _ in
            let applyCode = Stroyboard("Login", viewControllerId: "ApplyCodeViewController") as! ApplyCodeViewController
            applyCode.isApplyCode = true
            applyCode.showToolsBlock = { _ in
                UITools.showMessageToView(self.view, message: "申请成功，请耐心等待审核结果^_^", autoHide: true)
                self.loginView.removeFromSuperview()
                UserInfo.logout()
            }
            applyCode.loginViewBlock = { _ in
                self.loginView.showViewWithTage(1)
                UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(self.loginView)
            }
            UIApplication.sharedApplication().keyWindow?.sendSubviewToBack(self.loginView)
            self.navigationController?.pushViewController(applyCode, animated: true)
        }
        
        loginView.protocolClouse = { _ in
            let userProtocol = Stroyboard("Seting", viewControllerId: "UserProtocolViewController") as! UserProtocolViewController
            userProtocol.block = { _ in
                self.loginView.mobileTextField.becomeFirstResponder()
                UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(self.loginView)
            }
            self.navigationController?.pushViewController(userProtocol, animated: true)
            UIApplication.sharedApplication().keyWindow?.sendSubviewToBack(self.loginView)
        }
        
        loginView.newUserLoginClouse = { _ in
            let baseUserInfo = Stroyboard("Me", viewControllerId: "BaseInfoViewController") as! BaseUserInfoViewController
            self.navigationController?.pushViewController(baseUserInfo, animated: true)
        }
        
        loginView.reloadMeViewClouse = { _ in
            self.viewWillAppear(true)
        }
    }
    
    func verificationOrderView(){
        if orderNumberArray.count == 0 {
            let queue = dispatch_queue_create("com.meet.order-queue",
                                              dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0))
            
            dispatch_async(queue) {
                self.getOrderNumber()
            }
            dispatch_async(queue) {
                self.presentOrderView()
            }
        }else{
            self.presentOrderView()
        }
    }
    
    func presentOrderView(){
        let orderPageVC = OrderPageViewController()
        orderPageVC.setUpNavigationItem()
        
        orderPageVC.reloadOrderNumber = { _ in
            self.getOrderNumber()
        }
        if orderNumberArray.count != 0 {
            orderPageVC.numberArray = orderNumberArray
        }
        orderPageVC.setBarStyle(.ProgressBounceView)
        orderPageVC.progressHeight = 0
        orderPageVC.progressWidth = 0
        orderPageVC.adjustStatusBarHeight = true
        orderPageVC.progressColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        orderPageVC.changeNavigationBar()
        self.navigationController?.pushViewController(orderPageVC, animated: true)
    }
    
    func pushLikeView() {
        let likeManView = LikeManViewController()
        self.navigationController!.pushViewController(likeManView, animated:true)
    }
    
    func getOrderNumber(){
        let orderViewModel = OrderViewModel()
        self.orderNumberArray.removeAllObjects()
        orderViewModel.orderNumberOrder(UserInfo.sharedInstance().uid, successBlock: { (dic) in
            let countDic = dic as NSDictionary
            self.allOrderNumber = 0
            for value in countDic.allValues {
                self.allOrderNumber = self.allOrderNumber + Int(value as! NSNumber)
            }
            self.orderNumberArray.addObject("\(countDic["1"]!)")
            self.orderNumberArray.addObject("\(countDic["4"]!)")
            self.orderNumberArray.addObject("\(countDic["6"]!)")
            self.orderNumberArray.addObject("0")
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 5, inSection: 0)], withRowAnimation: .Automatic)
        }) { (dic) in
            
        }
    }
    
}

extension MeViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath,animated:true)
        if (!UserInfo.isLoggedIn()) {
            self.presentViewLoginViewController()
            return ;
        }
        if (indexPath.row == 0) {
            self.pushProfileViewControllr()
        } else if (indexPath.row == 1) {
            UITools.shareInstance().showMessageToView(self.view, message: "^_^ 敬请期待，暂时请联系客服帮忙添加哦", autoHide: true)
        } else  if (indexPath.row == 3 || indexPath.row == 2) {
            let senderInviteVC = Stroyboard("Me", viewControllerId: "SenderInviteViewController") as!  SenderInviteViewController
            self.navigationController!.pushViewController(senderInviteVC, animated:true)
        }else if(indexPath.row == 4){
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! MeInfoTableViewCell
            if cell.infoDetailLabel.text == "" {
                UITools.shareInstance().showMessageToView(self.view, message: "您已通过所有认证了哦", autoHide: true)
            }else{
                UITools.shareInstance().showMessageToView(self.view, message: "客服Meet君会尽快联系您认证的哦，还请耐心等待。", autoHide: true)
            }
        }else if indexPath.row == 5 {
            self.verificationOrderView()
        }else if indexPath.row == 6 {
            self.pushLikeView()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if UserInfo.isLoggedIn() {
            switch indexPath.row {
            case 0:
                return ScreenWidth*272/375
            case 1:
                return 100
            case 2:
                return 50
            case 3:
                return tableView.fd_heightForCellWithIdentifier(newMeetInfoTableViewCell, configuration: { (cell) in
                    self.configNewMeetCell((cell as! NewMeetInfoTableViewCell), indxPath: indexPath)
                })
            default:
                return 50
            }
        }else{
            switch indexPath.row {
                case 0:
                    return ScreenWidth*272/375
                case 1:
                    return 100
                default:
                    return 50
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if UserInfo.isLoggedIn() {
            let y = scrollView.contentOffset.y
            let index = NSIndexPath.init(forRow: 0, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(index) as? MePhotoTableViewCell
            if(y <= 0){
                if y <= -20 && cell != nil{
                    let frame = CGRectMake(375 * (y + 20)/(272 * 2), y + 20, ScreenWidth - 375 * (y + 20)/272, ScreenWidth*272/375 - y - 20)
                    cell!.avatarImageView.frame = frame
                    cell?.placImageView.frame = frame
                }
                if y <= -190 {
                    self.dismissViewControllerAnimated(true, completion: { 
                    })
                }
                navigaitionTitleView.backgroundColor = UIColor.init(red: 242.0/255.0, green: 241.0/255.0, blue: 238.0/255.0, alpha: 0)
                self.setLeftBarItem()
            }else{
                self.setNavigationItemAplah(y/124, imageName: ["me_dismissBlack"], type: 1)
                if UserInfo.sharedInstance().completeness.next_page != 4  {
                    self.setNavigationItemAplah(y/164, imageName: ["me_settingsBlack"], type: 2)
                }else{
                    self.setNavigationItemAplah(y/164, imageName: ["me_settingsBlack","me_editBlack"], type: 3)
                }
                if cell != nil {
                }
                navigaitionTitleView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: y/164)
                if y > 50{
                    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
                }else{
                    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
                }
                
            }
        }
    }
}

extension MeViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserInfo.isLoggedIn() {
            return 8
        }else{
            return 7
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if UserInfo.isLoggedIn(){
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(mePhotoTableViewCell, forIndexPath: indexPath) as! MePhotoTableViewCell
                cell.avatarImageView.backgroundColor = UIColor.init(hexString: "e7e7e7")
                if UserExtenModel.shareInstance().cover_photo != nil {
                    let cover_photo:Cover_photo = Cover_photo.mj_objectWithKeyValues(UserExtenModel.shareInstance().cover_photo)
                    if cover_photo.photo != nil {
                        //http://7xsatk.com1.z0.glb.clouddn.com/o_1aqc2rujd1vbc11ten5s12tj115fc.jpg?imageView2/1/w/1125/h/816
                        cell.avatarImageView .sd_setImageWithURL(NSURL.init(string:cover_photo.photo ), placeholderImage: nil, completed: { (image, error, type, url) in
                            UserExtenModel.saveCacheImage(image, withName: "cover_photo.jpg")
                        })
                    }else{
//                        if UserInfo.imageForName("headImage.jpg") != nil {
//                            cell.avatarImageView.image = UserInfo.imageForName("headImage.jpg");
//                        }else{
                            cell.avatarImageView.sd_setImageWithURL(NSURL.init(string: UserInfo.sharedInstance().avatar), placeholderImage: nil, completed: { (image
                                , error, type, url) in
                                UserInfo.saveCacheImage(image, withName: "headImage.jpg")
                            })
//                        }
                    }
                }
              
                cell.avatarImageView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin;
                if UserExtenModel.shareInstance().completeness != nil {
                    cell.cofigLoginCell(UserInfo.sharedInstance().real_name, infoCom: UserInfo.sharedInstance().job_label,compass: UserExtenModel.shareInstance().completeness)

                }else{
//                    cell.cofigLoginCell(UserInfo.sharedInstance().real_name, infoCom: UserInfo.sharedInstance().job_label,compass: UserExtenModel.shareInstance().completeness)

                }
                frame = cell.avatarImageView.frame;
                cell.block = { (tag) in
                    self.pushViewController(tag)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(photoDetailTableViewCell, forIndexPath: indexPath) as! PhotoDetailTableViewCell
                    cell.configCell(UserExtenModel.allImageUrl())
                cell.closure = { () in
                    UITools.shareInstance().showMessageToView(self.view, message: "^_^ 敬请期待，暂时请联系客服帮忙添加哦", autoHide: true)
                }
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                if !UserInviteModel.isEmptyDescription()&&(!UserInviteModel.shareInstance().results[0].is_active || UserInviteModel.isFake()){
                    cell.configCell("me_newmeet", infoString: "我的邀约", infoDetail: "未开启     ")
                }else{
                    cell.configCell("me_newmeet", infoString: "我的邀约", infoDetail: "")
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.setInfoButtonBackGroudColor(lineLabelBackgroundColor)
                cell.hidderLine()
                return cell
            }else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier(newMeetInfoTableViewCell, forIndexPath: indexPath) as! NewMeetInfoTableViewCell
                self.configNewMeetCell(cell, indxPath: indexPath)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.isHaveShadowColor(false)
                return cell
            }else if (indexPath.row == 4){
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                cell.configCell((userInfoModel.imageArray() as NSArray) .objectAtIndex(indexPath.row - 3) as! String, infoString: (userInfoModel.titleArray() as NSArray).objectAtIndex(indexPath.row - 3) as! String, infoDetail: "")
                if indexPath.row == 4 {
                    var string = ""
                    let auto_info = UserExtenModel.shareInstance().auth_info
                    var tempString = "职业、实名、电话、"
                    if auto_info != "" && auto_info != nil {
                        let autoArray = auto_info.componentsSeparatedByString(",")
                        let dic = (ProfileKeyAndValue.shareInstance().appDic as NSDictionary).objectForKey("auth_type") as! NSDictionary
                        if autoArray.count == 3 {
                            string = ""
                        }else if (autoArray.count == 2) {
                            for index in 0...autoArray.count - 1 {
                                var autoName = "、"
                                if dic.objectForKey(autoArray[index]) != nil {
                                    autoName = dic.objectForKey(autoArray[index]) as! String
                                }
                                if autoName.length > 2 {
                                    let firstChar = (autoName as NSString).substringToIndex(2)
                                    tempString = tempString.stringByReplacingOccurrencesOfString("\(firstChar)、", withString: "")
                                }
                            }
                            tempString = tempString.stringByReplacingOccurrencesOfString("、", withString: "")
                            string = "尚未通过\(tempString)认证       "
                        }else if (autoArray.count == 1){
                            let autoName = dic.objectForKey(autoArray[0]) as! String
                            let firstChar = (autoName as NSString).substringToIndex(2)
                            tempString = tempString.stringByReplacingOccurrencesOfString("\(firstChar)、", withString: "")
                            tempString = (tempString as NSString).substringToIndex(5)
                            string = "尚未通过\(tempString)认证       "
                        }else{
                             tempString = "职业、实名、电话"
                            string = "尚未通过\(tempString)认证       "
                        }
                    }else{
                         string = "尚未通过职业、实名、电话认证       "
                    }
                    cell.infoDetailLabel.text = string
                    cell.setInfoButtonBackGroudColor(lineLabelBackgroundColor)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                if allOrderNumber == 0 {
                    cell.configCell("me_mymeet", infoString: "我的约见", infoDetail: "")
                }else{
                    cell.configCell("me_mymeet", infoString: "我的约见", infoDetail: "共 \(allOrderNumber) 个进行中     ")
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.setInfoButtonBackGroudColor(MeProfileCollectViewItemSelect)
                return cell
            }else if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                cell.configCell("me_wantmeet", infoString: "想见的人", infoDetail: "")
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.setInfoButtonBackGroudColor(MeProfileCollectViewItemSelect)
                return cell
            }else{
                let identifier = "LastCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
                if cell == nil{
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
                }
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
            }
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(mePhotoTableViewCell, forIndexPath: indexPath) as! MePhotoTableViewCell
                cell.configlogoutView()
                cell.logoutBtn.addTarget(self, action: (#selector(MeViewController.presentViewLoginViewController)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(photoDetailTableViewCell, forIndexPath: indexPath) as! PhotoDetailTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.configLogoutView()
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.accessoryType = UITableViewCellAccessoryType.None
                return cell
            }else if (indexPath.row == 6) {
                let identifier = "LastCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
                if cell == nil{
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
                }
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                if indexPath.row == 2 {
                    cell.hidderLine()
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                let imageArray = userInfoModel.imageArray()
                let titleArray = userInfoModel.titleArray()
                cell.configCell((userInfoModel.imageArray() as NSArray).objectAtIndex(indexPath.row - 2) as! String, infoString: (userInfoModel.titleArray() as NSArray).objectAtIndex(indexPath.row - 2) as! String, infoDetail: "")
                return cell
            }
        }
   }
}



