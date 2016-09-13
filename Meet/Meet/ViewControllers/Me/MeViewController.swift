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


let aboutUsStr = "您的个人介绍空空如也，完善后可大大提高约见成功率哦。"

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
    
    var hightImagesArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.loadExtenInfo()
        if UserInfo.isLoggedIn() {
            self.getOrderNumber()
        }
        self.talKingDataPageName = "Me"
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
        self.navigationItemWithLineAndWihteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addLineNavigationBottom()
        self.navigationController?.navigationBar.translucent = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        self.setNavigationBar()
        if UserInfo.isLoggedIn() {
            if self.tableView.style == .Plain {
                self.setUpTableView()
            }
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
    
    func setUpTableView(){
        if UserInfo.isLoggedIn() {
            tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
            tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        }else{
            tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
            tableView.backgroundColor = UIColor.whiteColor()
        }
        
        let meInfoNib = UINib(nibName: "MeInfoTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(meInfoNib, forCellReuseIdentifier: "MeInfoTableViewCell")
        let mePhotoNib = UINib(nibName: "MePhotoTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(mePhotoNib, forCellReuseIdentifier: "MePhotoTableViewCell")
        let mePhotoDetailNib = UINib(nibName: "PhotoDetailTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(mePhotoDetailNib, forCellReuseIdentifier: "PhotoDetailTableViewCell")
        
        self.tableView.registerClass(NewMeetInfoTableViewCell.self, forCellReuseIdentifier: newMeetInfoTableViewCell)
        self.tableView.registerClass(AboutUsCell.self, forCellReuseIdentifier: "AboutUsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.view.addSubview(tableView)

        tableView.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        })
    }
    
    func loadExtenInfo(){
        userInfoModel.getMoreExtInfo("", success: { (dic) in
            UserExtenModel.synchronizeWithDic(dic)
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 1, inSection: 1)], withRowAnimation: .Automatic)
            }, fail: { (dic) in
                
            }, loadingString: { (msg) in
              
        })
    }
    
    func loadInviteInfo(){
        userInfoModel.getInvite({ (dic) in
            UserInviteModel.synchronizeWithDic(dic)
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 3, inSection: 1)], withRowAnimation: .Automatic)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()

            })
            }, fail: { (dic) in
                
            }) { (msg) in
                
        }
    }
    
    func setNavigationBar(){
        if UserInfo.isLoggedIn() {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: .Plain, target: self, action: #selector(MeViewController.cancelPress(_:)))
            if UserInfo.sharedInstance().completeness != nil && UserInfo.sharedInstance().completeness.next_page != 4  {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_settingsBlack")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: .Plain, target: self, action: #selector(MeViewController.rightPress(_:)))
            }else{
                let settingItem = UIBarButtonItem(image:UIImage.init(named: "me_settingsBlack")!.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(MeViewController.rightPress(_:)))
                let editButton = UIBarButtonItem(image: UIImage.init(named: "me_editBlack")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(MeViewController.editPress(_:)))
                self.navigationItem.setRightBarButtonItems([settingItem,editButton], animated: true)
            }
        }else{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: .Plain, target: self, action: #selector(MeViewController.cancelPress(_:)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_settingsBlack")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: .Plain, target: self, action: #selector(MeViewController.rightPress(_:)))
        }
    }

    func cancelPress(sender:UIBarButtonItem){
        self.dismissViewControllerAnimated(true) { 
        }
    }
    
    func editPress(sender:UIBarButtonItem){
        self.pushProfileViewControllr()
    }
    
    func rightPress(sender:UIBarButtonItem){
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
            self.pushHightLightVC()
//            self.pushProfileViewControllr()
            break
        case 3:
            self.pushHightLightVC()
            break
        case 4:
            break
        default: break
            
        }
    }
    
    func pushProfileViewControllr() {
        let myProfileVC = Stroyboard("Me", viewControllerId: "MyProfileViewController") as!  MyProfileViewController
        myProfileVC.fromeMeView = true
        myProfileVC.hightLight = UserExtenModel.shareInstance().highlight
        myProfileVC.reloadMeViewBlock = {(uodataInfo:Bool) in
            self.tableView.reloadData()
        }
        self.navigationController!.pushViewController(myProfileVC, animated:true)
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
        if self.instrestArray().count != 0 {
            cell.configCell(self.descriptionString(), array: self.instrestArray() as [AnyObject], andStyle: .ItemWhiteColorAndBlackBoard)
        }
    }
    
    func presentViewLoginViewController(){
        let loginView = LoginViewController()
        let controller = UINavigationController(rootViewController: loginView)
        loginView.newUserLoginClouse = { _ in
            let baseUserInfo = Stroyboard("Me", viewControllerId: "BaseInfoViewController") as! BaseUserInfoViewController
            self.navigationController?.pushViewController(baseUserInfo, animated: true)
        }
        
        loginView.reloadMeViewClouse = { _ in
            self.viewWillAppear(true)
        }
        
        self.presentViewController(controller, animated: true) {
            
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
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentOrderView()
                })
            }
        }else{
            self.presentOrderView()
        }
    }
    
    func presentOrderView(){
        let orderPageVC = OrderPageViewController()
        
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
        orderPageVC.loadType = .Push
        self.navigationController?.pushViewController(orderPageVC, animated: true)
    }
    
    func uploadImages(images:NSArray) {
        var currentIndex = 1
        let centerView = UploadImages(frame: (KeyWindown?.frame)!)
        centerView.updateLabelText("\(currentIndex)", allnumber: "\(images.count)")
        KeyWindown?.addSubview(centerView)
        for image in images {
            
            userInfoModel.uploadHeaderList(image as! UIImage, successBlock: { (dic) in
                centerView.updateLabelText("\(currentIndex)", allnumber: "\(images.count)")
                if currentIndex == images.count {
                    centerView.removeFromSuperview()
                    self.loadExtenInfo()
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
                }else{
                    currentIndex = currentIndex + 1
                }
                }, failBlock: { (dic) in
                    centerView.removeFromSuperview()
                    MainThreadAlertShow("上传失败", view: self.view)
            })
//            centerView.removeFromSuperview()
        }
//        userInfoModel.uploadHeaderList(images as [AnyObject], successBlock: { (dic) in
//            self.loadExtenInfo()
//            }) { (dic) in
//                MainThreadAlertShow("上传失败", view: self.view)
//        }
    }
    
    func presentImagePicker() {
        var maxCount = 8
        if UserExtenModel.shareInstance().head_photo_list != nil {
            maxCount = maxCount - UserExtenModel.shareInstance().head_photo_list.count
        }
        let imagePickerVC = TZImagePickerController(maxImagesCount: maxCount, delegate: self)
        imagePickerVC.navigationBar.barTintColor = UIColor.whiteColor()
        imagePickerVC.navigationBar.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
        imagePickerVC.allowPickingVideo = false
        imagePickerVC.allowTakePicture = false
        imagePickerVC.oKButtonTitleColorNormal = UIColor.init(hexString: HomeDetailViewNameColor)
        imagePickerVC.oKButtonTitleColorDisabled = UIColor.init(hexString: lineLabelBackgroundColor)
        imagePickerVC.allowPickingOriginalPhoto = true
        imagePickerVC.didFinishPickingPhotosHandle = { photos,assets,isSelectOriginalPhoto in
            self.uploadImages(photos)
        }
        
        self.presentViewController(imagePickerVC, animated: true) { 
            
        }
    }
    
    func presentImageBrowse(index:NSInteger, images:NSArray) {
        let pbVC = PhotoBrowser()
        pbVC.isNavBarHidden = true
//        pbVC.isStatusBarHidden = false
        /**  设置相册展示样式  */
        pbVC.showType = PhotoBrowser.ShowType.Push
        /**  设置相册类型  */
        pbVC.photoType = PhotoBrowser.PhotoType.Host
        
        //强制关闭显示一切信息
        pbVC.hideMsgForZoomAndDismissWithSingleTap = true
        
        var models: [PhotoBrowser.PhotoModel] = []
        
        pbVC.avatar = UserInfo.sharedInstance().avatar
        pbVC.realName = UserInfo.sharedInstance().real_name
        pbVC.jobName = UserInfo.sharedInstance().job_label
        let imageArray = UserExtenModel.shareInstance().head_photo_list
        let plachImage = UIImage.init(color: UIColor.clearColor(), size: CGSizeMake(100, 100))

        var imageCount:NSInteger = 0
        for image in imageArray {
            
            models.append(PhotoBrowser.PhotoModel(hostHDImgURL: image.photo, hostThumbnailImg: plachImage, titleStr: ("\(image.photo_id)"), descStr: nil, sourceView: nil))
            imageCount = imageCount + 1
        }

        pbVC.deletePhoto = { index,photoid,deleteSuccess in
            self.userInfoModel.deleteImage(photoid, successBlock: { (dic) in
                deleteSuccess(success: true)
                self.loadExtenInfo()
                }, failBlock: { (dic) in
                deleteSuccess(success: false)
            })
        }
        
        /**  设置数据  */
        pbVC.photoModels = models
        
        pbVC.show(inVC: self,index: 0)
    }
    
    func pushLikeView() {
        let likeManView = LikeManViewController()
        self.navigationController!.pushViewController(likeManView, animated:true)
    }
    
    func pushHightLightVC(){
        let hightLight = HightLightViewController()
        hightLight.titleStr = UserExtenModel.shareInstance().experience
        hightLight.infoStr = UserExtenModel.shareInstance().highlight
        self.navigationController?.pushViewController(hightLight, animated: true)
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
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 5, inSection: 1)], withRowAnimation: .Automatic)
        }) { (dic) in
            
        }
    }
    
    func configAboutUsCell(cell:AboutUsCell, indexPath:NSIndexPath) {
        if UserExtenModel.shareInstance().experience != nil {
            if UserExtenModel.shareInstance().experience != "" && UserExtenModel.shareInstance().highlight != ""{
                cell.configCell(UserExtenModel.shareInstance().experience, info: UserExtenModel.shareInstance().highlight)
            }else {
                cell.configCell(UserExtenModel.shareInstance().experience, info:                 (PlaceholderText.shareInstance().appDic as NSDictionary).objectForKey("1000009") as! String)
                
            }
        }
    }

}

extension MeViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UserInfo.isLoggedIn() {
            return 7
        }
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 23
        }
        return 0.0001
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath,animated:true)
        if (!UserInfo.isLoggedIn()) {
//            UserInfo.sharedInstance().uid = "247"
//            let modelv = LoginViewModel()
//            modelv.getUserInfo("247", success: { (dic) in
//                UserInfo.synchronizeWithDic(dic)
//                UserInfo.synchronize()
//                self.viewWillAppear(true)
//                }, fail: { (dic) in
//                    
//                }, loadingString: { (msg) in
//                    
//            })
            self.presentViewLoginViewController()
            return ;
        }
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.pushProfileViewControllr()
            default:
                
                if  UserExtenModel.shareInstance().head_photo_list != nil && UserExtenModel.shareInstance().head_photo_list.count == 0 {
                    self.presentImagePicker()
                }
                break;
            }
        default:
            switch indexPath.row {
            case 0,1:
                self.pushHightLightVC()
            case 2,3:
                let senderInviteVC = Stroyboard("Me", viewControllerId: "SenderInviteViewController") as!  SenderInviteViewController
                self.navigationController!.pushViewController(senderInviteVC, animated:true)
            case 4:
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! MeInfoTableViewCell
                if cell.infoDetailLabel.text == "" {
                    MainThreadAlertShow("您已通过所有认证了哦", view: self.view)
                }else{
                    MainThreadAlertShow("客服Meet君会尽快联系您认证的哦，还请耐心等待。", view: self.view)
                }
            case 5:
                self.verificationOrderView()
            default:
                self.pushLikeView()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if UserInfo.isLoggedIn() {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return ScreenWidth*236/355 + 116
                default:
                    return 115
                }
            default:
                switch indexPath.row {
                case 1:
                    return tableView.fd_heightForCellWithIdentifier("AboutUsCell", configuration: { (cell) in
                        self.configAboutUsCell(cell as! AboutUsCell, indexPath: indexPath)
                    })
                case 3:
                    return tableView.fd_heightForCellWithIdentifier(newMeetInfoTableViewCell, configuration: { (cell) in
                        self.configNewMeetCell((cell as! NewMeetInfoTableViewCell), indxPath: indexPath)
                    })
                case 0,2,6:
                    return 61
                default:
                    return 50
                }
            }
        }else{
            switch indexPath.row {
                case 0:
                    return ScreenWidth*272/375 + 40
                default:
                    return 50
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -140 {
            self.dismissViewControllerAnimated(true, completion: { 
                
            })
        }
    }
    
}

extension MeViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if UserInfo.isLoggedIn() {
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserInfo.isLoggedIn() {
            if section == 0 {
                return 2
            }else{
                return 7
            }
        }else{
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if UserInfo.isLoggedIn(){
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(mePhotoTableViewCell, forIndexPath: indexPath) as! MePhotoTableViewCell
                    cell.avatarImageView.backgroundColor = UIColor.init(hexString: "e7e7e7")
                    
                    if (UserInfo.imageForName("coverPhoto") != nil) {
                        let coverImage = UserInfo.imageForName("coverPhoto")
                        let sizeImage = coverImage.resizeImage(coverImage, newSize: CGSizeMake(1065, 1065))
                        let image = UIImage.getImageFromImage(sizeImage, subImageSize: CGSizeMake(1065, 708), subImageRect: CGRectMake(0, 0, 1065, 708))
                        
                        cell.avatarImageView.image = image
                    }else{
                        let imageArray = UserInfo.sharedInstance().avatar.componentsSeparatedByString("?")
                        cell.avatarImageView.sd_setImageWithURL(NSURL.init(string: imageArray[0].stringByAppendingString(HomeDetailCovertImageSize)), placeholderImage: nil, completed: { (image
                            , error, type, url) in
                            UserInfo.saveCacheImage(image, withName: "coverPhoto")
                        })
                    }
                    cell.avatarImageView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin;
                    if UserExtenModel.shareInstance().completeness != nil {
                        cell.cofigLoginCell(UserInfo.sharedInstance().real_name, infoCom: UserInfo.sharedInstance().job_label,compass: UserExtenModel.shareInstance().completeness)
                        
                    }else{

//                        cell.cofigLoginCell(UserInfo.sharedInstance().real_name, infoCom: UserInfo.sharedInstance().job_label,compass: nil)
                        
                    }
                    frame = cell.avatarImageView.frame;
                    cell.block = { (tag) in
                        self.pushViewController(tag)
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.backgroundColor = UIColor.clearColor()
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier(photoDetailTableViewCell, forIndexPath: indexPath) as! PhotoDetailTableViewCell
                    while cell.contentView.subviews.last != nil {
                        cell.contentView.subviews.last?.removeFromSuperview()
                    }
                    cell.setUpView()
                    if (UserExtenModel.shareInstance().head_photo_list != nil) {
                        cell.configCell(UserExtenModel.shareInstance().head_photo_list)
                    }
                    cell.closure = { () in
                        self.presentImagePicker()
                    }
                    cell.cellImageArray = { (index, images) in
                        self.presentImageBrowse(index,images: images)
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.backgroundColor = UIColor.clearColor()
                    return cell
                }
            }else{
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                    cell.configCell("me_about", infoString: "关于我的那些事", infoDetail: "", shadowColor: false,cornerRadiusType: .Top)
                    cell.hidderLine()
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.setInfoButtonBackGroudColor(MeProfileCollectViewItemSelect)
                    return cell
                }else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("AboutUsCell", forIndexPath: indexPath) as! AboutUsCell
                    if UserExtenModel.shareInstance().experience != nil {
                        self.configAboutUsCell(cell, indexPath: indexPath)
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                }else if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                    cell.configCell("me_newmeet", infoString: "我的邀约", infoDetail: "", shadowColor: false,cornerRadiusType: .None)
                    if UserInviteModel.shareInstance().results != nil {
                        cell.infoDetailLabel.text =  (UserInviteModel.shareInstance().results[0]).is_active ? "":"未开启       "
                    }
                    cell.setInfoButtonBackGroudColor(lineLabelBackgroundColor)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                }else if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(newMeetInfoTableViewCell, forIndexPath: indexPath) as! NewMeetInfoTableViewCell
                    self.configNewMeetCell(cell, indxPath: indexPath)
                    cell.isHaveShadowColor(false)
                    cell.hidderLine()
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                }else if (indexPath.row == 4){
                    let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                    cell.configCell((userInfoModel.imageArray() as NSArray) .objectAtIndex(indexPath.row - 3) as! String, infoString: (userInfoModel.titleArray() as NSArray).objectAtIndex(indexPath.row - 3) as! String, infoDetail: "", shadowColor: false,cornerRadiusType: .None)
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
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                }else if indexPath.row == 5 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                    if allOrderNumber == 0 {
                        cell.configCell("me_mymeet", infoString: "我的约见", infoDetail: "", shadowColor: false,cornerRadiusType: .None)
                    }else{
                        cell.configCell("me_mymeet", infoString: "我的约见", infoDetail: "共 \(allOrderNumber) 个进行中     ", shadowColor: false,cornerRadiusType: .None)
                    }
                    cell.showLine()
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.setInfoButtonBackGroudColor(MeProfileCollectViewItemSelect)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                    cell.configCell("me_wantmeet", infoString: "想见的人", infoDetail: "", shadowColor: true,cornerRadiusType: .Bottom)
                    cell.showLine()
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.setInfoButtonBackGroudColor(MeProfileCollectViewItemSelect)
                    return cell
                }
            }
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(mePhotoTableViewCell, forIndexPath: indexPath) as! MePhotoTableViewCell
                cell.configlogoutView()
                cell.logoutBtn.addTarget(self, action: (#selector(MeViewController.presentViewLoginViewController)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.configCell((userInfoModel.imageArray() as NSArray).objectAtIndex(indexPath.row - 1) as! String, infoString: (userInfoModel.titleArray() as NSArray).objectAtIndex(indexPath.row - 1) as! String, infoDetail: "", shadowColor: false,cornerRadiusType: .None)
                return cell
            }
        }
    }
}
extension MeViewController : TZImagePickerControllerDelegate {
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool)
    {
    }
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        
    }
    func imagePickerControllerDidCancel(picker: TZImagePickerController!) {
        
    }
    // If user picking a video, this callback will be called.
    // If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
    // 如果用户选择了一个视频，下面的handle会被执行
    // 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: AnyObject!) {
        
    }
}

//extension MeViewController : MWPhotoBrowserDelegate {
//    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
//        return UInt(hightImagesArray.count)
//    }
//    
//    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
//        if index < UInt(self.hightImagesArray.count) {
//            return self.hightImagesArray.objectAtIndex(Int(index)) as! MWPhotoProtocol
//        }
//        return nil
//    }
//}

