//
//  MeViewController.swift
//  Demo
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import SnapKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInviteInfo()
        
        self.setUpTableView()
        self.loadHeadImageView()
        self.loadExtenInfo()
        self.setNavigationBar()
        let applecation = UIApplication.sharedApplication()
        if self.statusBar == applecation.valueForKey("statusBar") as? UIView{
        }
        self.loadMorePic(UserExtenModel.allImageUrl())
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        if (UserInfo.sharedInstance().isFirstLogin && UserInfo.isLoggedIn()) {
            UserInfo.sharedInstance().isFirstLogin = false
            self.loadExtenInfo()
            self.loadInviteInfo()
            UserInfo.synchronize()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.createImageWithColor(UIColor.whiteColor()), forBarPosition: .Any, barMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:UIFont.systemFontOfSize(18.0)]
    }
    
    func setUpTableView(){
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        let headerView = NSBundle.mainBundle().loadNibNamed("MePhotoView", owner: nil, options: nil).first as? MePhotoView
//        
//        headerView?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 100)
//        headerView?.center = self.view.center
//        
//        let transparentView = TransparentView.dropHeaderViewWithFrame(headerView!.frame, contentView: headerView, stretchView: headerView)
//        transparentView.frame = headerView!.frame;
//        self.tableView.tableHeaderView = headerView
        self.view.addSubview(tableView)
        let meInfoNib = UINib(nibName: "MeInfoTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(meInfoNib, forCellReuseIdentifier: "MeInfoTableViewCell")
        let mePhotoNib = UINib(nibName: "MePhotoTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(mePhotoNib, forCellReuseIdentifier: "MePhotoTableViewCell")
        let mePhotoDetailNib = UINib(nibName: "PhotoDetailTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(mePhotoDetailNib, forCellReuseIdentifier: "PhotoDetailTableViewCell")
        self.tableView.registerClass(NewMeetInfoTableViewCell.self, forCellReuseIdentifier: newMeetInfoTableViewCell)

        tableView.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.view.snp_top).offset(-64)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        })
    }
    
    func loadExtenInfo(){
        userInfoModel.getMoreExtInfo("", success: { (dic) in
            UserExtenModel.synchronizeWithDic(dic)
            UserInfoViewModel.saveCacheImage(UserExtenModel.shareInstance().cover_photo, success: { (dic) in
                self.loadHeadImageView()
                },returnImage: { (image) in
                    
                }, fail: { (dic) in
                    
                }, loadingString: { (msg) in
                    
            })
            self.loadMorePic(UserExtenModel.allImageUrl())
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
    
    
    func loadMorePic(urls:NSArray){
        self.imagesArray.removeAllObjects()
        for string in urls {
            UserInfoViewModel.saveCacheImage(string as! String, success: { (dic) in
                }, returnImage: { (image) in
                    self.imagesArray.addObject(image)
                }, fail: { (dic) in
                    
                }, loadingString: { (msg) in
                    
            })
        }
        self.tableView.reloadData()
        
    }
    
    func setNavigationBar(){
        if UserInfo.isLoggedIn() {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.createImageWithColor(UIColor.clearColor()), forBarPosition: .Any, barMetrics: .Default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
            self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
            self.setLeftBarItem()
            let appearance = UINavigationBar.appearance()
            appearance.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Chalkduster", size: 21)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }else{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.createImageWithColor(UIColor.whiteColor()), forBarPosition: .Any, barMetrics: .Default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
            self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
            self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:UIFont.systemFontOfSize(18.0)]
            self.setNavigationItemAplah(1, imageName: ["me_dismissBlack"], type: 1)
            self.setNavigationItemAplah(1, imageName: ["me_settingsBlack"], type: 2)
            
        }
    }
    
    func setLeftBarItem(){
        self.setNavigationItemAplah(1, imageName: ["me_dismiss"], type: 1)
        
        if UserInfo.sharedInstance().job_label == "" {
            self.setNavigationItemAplah(1, imageName: ["me_settings"], type: 2)
        }else{
            self.setNavigationItemAplah(1, imageName: ["me_settings","me_edit"], type: 3)
        }
    }
    
    func setNavigationItemAplah(imageAplah:CGFloat, imageName:NSArray, type:NSInteger)  {
        if type == 1 {
            let image = UIImage(named: imageName[0] as! String)?.imageByApplyingAlpha(imageAplah)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeViewController.cancelPress(_:)))
        }else if type == 2{
            let image = UIImage(named: imageName[0] as! String)?.imageByApplyingAlpha(imageAplah)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeViewController.rightPress(_:)))
        }else{
            let image = UIImage(named: imageName[0] as! String)?.imageByApplyingAlpha(imageAplah)
            let image1 = UIImage(named: imageName[1] as! String)?.imageByApplyingAlpha(imageAplah)
            let settingItem = UIBarButtonItem(image: image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeViewController.rightPress(_:)))
            
            let editItem = UIBarButtonItem(image:image1?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeViewController.editPress(_:)))
            
            self.navigationItem.rightBarButtonItems = [settingItem,editItem]
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
        let meStoryBoard = UIStoryboard(name: "Seting", bundle: NSBundle.mainBundle())
        let settingVC = meStoryBoard.instantiateViewControllerWithIdentifier("SetingViewController") as!  SetingViewController
        settingVC.logoutBlock = {()
            self.setNavigationBar()
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
                let imageData = UIImageJPEGRepresentation(image!, 0.5)
                let saveImagePath = self.imageSavePath()
                
                if ((imageData?.writeToFile(self.imageSavePath(), atomically: false)) != nil) {
                    do{
                        self.reloadUerImage(saveImagePath)
                    }
                    
                } else {
                    
                }
        }
    }
    
    
    
    func imageSavePath() -> String {
        let saveFilePath = AppData.getCachesDirectoryUserInfoDocumetPathDocument("headimg")
        let saveImagePath = saveFilePath.stringByAppendingString(String.init(format: "0.JPG"))
        return saveImagePath
    }
    
    
    
    func reloadUerImage(imagePath: String){
        headImage = UIImage(contentsOfFile: imagePath)
        self.tableView.reloadData()
    }
    
    func loadHeadImageView(){
        headImage = nil;
        if (!UserInfo.isLoggedIn() || UserExtenModel.shareInstance().cover_photo == nil) {
            return ;
        }
        let stringArray = UserExtenModel.shareInstance().cover_photo.componentsSeparatedByString("?")
        let nameArray = stringArray[0].componentsSeparatedByString("/")
        if nameArray.count > 2 {
            self.headImage = UserExtenModel.imageForName(nameArray[3])
        }
        self.tableView.reloadData()
    }
    
    

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            print("dddddd")
        }
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushViewController(tag:NSInteger){
        print("=======\(tag)")
//        let tag = 3
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
        let meStoryBoard = UIStoryboard(name: "Me", bundle: NSBundle.mainBundle())
        
        let myProfileVC = meStoryBoard.instantiateViewControllerWithIdentifier("MyProfileViewController") as!  MyProfileViewController
        myProfileVC.fromeMeView = true
        myProfileVC.block = {(updateImage:Bool, updateInfo:Bool) in
            if updateImage {
                self.loadHeadImageView()
            }
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            if updateInfo {
                //                    self.checkDocumentGetSmallImagesAndUpdate()
            }
        }
        self.navigationController!.pushViewController(myProfileVC, animated:true)
    }
    
    func presentAddStarViewController(){
        //////展示更多个人信息
        let meStoryBoard = UIStoryboard(name: "Me", bundle: NSBundle.mainBundle())
        
        let addStarVC = meStoryBoard.instantiateViewControllerWithIdentifier("AddStarViewController") as!  AddStarViewController
        let controller = BaseNavigaitonController(rootViewController: addStarVC)
        self.navigationController!.presentViewController(controller, animated: true, completion: {
            
        })

    }
    
    func presentMoreProfileViewController(){
        //////展示更多个人信息
        let meStoryBoard = UIStoryboard(name: "Me", bundle: NSBundle.mainBundle())
        
        let moreProfileView = meStoryBoard.instantiateViewControllerWithIdentifier("MoreProfileViewController") as!  MoreProfileViewController
        let controller = BaseNavigaitonController(rootViewController: moreProfileView)
        self.navigationController!.presentViewController(controller, animated: true, completion: {
            
        })
        
    }
    
    func inviteHeight() -> CGFloat {
        
        return meetHeight(self.descriptionString(), instrestArray: self.instrestArray())
    }
    
    func descriptionString() -> String {
        var description = ""
        if UserInviteModel.isEmptyDescription() {
            description = "欢迎来到隐舍 THESECRET。这里没有酒单， 放眼望去，你看到的是与弗里达相关的一切，迷人而神秘的夜色。走进这扇门，你将开始一段奇遇。在这里，我将根据你的喜好、心情，调制专属于你的鸡尾酒，为你带来最奇妙的美好体验。"
        }else{
            description = UserInviteModel.descriptionString(0)
        }
        return description
    }
    
    func instrestArray() -> NSArray {
        var array = NSMutableArray()
        if UserInviteModel.isEmptyDescription() {
            array = ["周边旅行","谈天说地","聊天","创业咨询","品酒","定制理财"]
        }else{
            array.addObjectsFromArray(UserInviteModel.themArray(0))
        }
        return array.copy() as! NSArray
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MeViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath,animated:true)
        if (!UserInfo.isLoggedIn()) {
            let meStoryBoard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
            let resgisterVc = meStoryBoard.instantiateViewControllerWithIdentifier("weChatResgisterNavigation")
            self.presentViewController(resgisterVc, animated: true, completion: { 
                
            });
            
            return ;
        }
        if (indexPath.row == 0) {
            self.pushProfileViewControllr()
        } else if (indexPath.row == 1) {
            self.presentMoreProfileViewController()
        } else  if (indexPath.row == 3 || indexPath.row == 2) {
            let meStoryBoard = UIStoryboard(name: "Me", bundle: NSBundle.mainBundle())
            let senderInviteVC = meStoryBoard.instantiateViewControllerWithIdentifier("SendInviteViewController") as!  SendInviteViewController
            senderInviteVC.block = { () in
                self.tableView.reloadData()
            }
            self.navigationController!.pushViewController(senderInviteVC, animated:true)
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
                return self.inviteHeight()
//                return meetHeight("欢迎来到隐舍 THESECRET。这里没有酒单， 放眼望去，你看到的是与弗里达相关的一切，迷人而神秘的夜色。走进这扇门，你将开始一段奇遇。在这里，我将根据你的喜好、心情，调制专属于你的鸡尾酒，为你带来最奇妙的美好体验。", instrestArray: ["周边旅行","谈天说地","聊天","创业咨询","品酒","定制理财"])
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
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100;
//    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if UserInfo.isLoggedIn() {
            let y = scrollView.contentOffset.y
            let index = NSIndexPath.init(forRow: 0, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(index) as? MePhotoTableViewCell
            if(y <= 0){
                if cell != nil {
//                    cell?.avatarImageView.backgroundColor = UIColor.blueColor()
//                    cell!.avatarImageView.frame = CGRectMake(0, y, ScreenWidth, frame.size.height - y);
//                    cell!.avatarImageView.frame = CGRectMake(0, y, ScreenWidth, ScreenWidth*272/375 - y);
                }
                //往上滑动，透明度为0
                self.setLeftBarItem()
                self.navigationController?.navigationBar.setBackgroundImage(UIImage.createImageWithColor(UIColor.init(red: 242.0/255.0, green: 241.0/255.0, blue: 238.0/255.0, alpha: 0)), forBarPosition: .Any, barMetrics: .Default)
            }else{
                self.setNavigationItemAplah(y/124, imageName: ["me_dismissBlack"], type: 1)
                if UserInfo.sharedInstance().personal_label == "" {
                    self.setNavigationItemAplah(y/124, imageName: ["me_settingsBlack"], type: 2)
                }else{
                    self.setNavigationItemAplah(y/124, imageName: ["me_settingsBlack","me_editBlack"], type: 3)
                }
                
                if cell != nil {
//                    cell?.avatarImageView.backgroundColor = UIColor.blueColor()
//                    cell!.avatarImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*272/375);
                }
                
                self.navigationController?.navigationBar.setBackgroundImage(UIImage.createImageWithColor(UIColor.init(red: 242.0/255.0, green: 241.0/255.0, blue: 238.0/255.0, alpha: y/124)), forBarPosition: .Any, barMetrics: .Default)
                
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
            return 7
        }else{
            return 6
        }
    }
    
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = NSBundle.mainBundle().loadNibNamed("MePhotoView", owner: nil, options: nil).first as? MePhotoView
//        //
//        headerView?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 100)
//        headerView?.center = self.view.center
//        return headerView
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if UserInfo.isLoggedIn() {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(mePhotoTableViewCell, forIndexPath: indexPath) as! MePhotoTableViewCell
                cell.avatarImageView.backgroundColor = UIColor.redColor()
                cell.avatarImageView.image = headImage
                cell.cofigLoginCell(UserInfo.sharedInstance().real_name, infoCom: UserInfo.sharedInstance().job_label,compass: UserInfo.sharedInstance().completeness)
                frame = cell.avatarImageView.frame;

                cell.block = { (tag) in
                    self.pushViewController(tag)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(photoDetailTableViewCell, forIndexPath: indexPath) as! PhotoDetailTableViewCell
                if self.imagesArray.count == 0 {
                    let imageArray = NSMutableArray()
                    for _ in 0...4 {
                        imageArray.addObject(UIImage(named: "me_testImage@3x")!)
                    }
                }else{
                    cell.configCell(self.imagesArray)
                }
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                return cell
            }else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                if UserInviteModel.isEmptyDescription() {
                    cell.configCell("me_newmeet", infoString: "我的邀约", infoDetail: "未开启     ")
                }else{
                    cell.configCell("me_newmeet", infoString: "我的邀约", infoDetail: "")
                }
                cell.setinfoButtonBackGroudColor(lineLabelBackgroundColor)
                cell.hidderLine()
                return cell
            }else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier(newMeetInfoTableViewCell, forIndexPath: indexPath) as! NewMeetInfoTableViewCell
                cell.configCell(self.descriptionString(), array: self.instrestArray() as [AnyObject])
//                cell.configCell("欢迎来到隐舍 THESECRET。这里没有酒单， 放眼望去，你看到的是与弗里达相关的一切，迷人而神秘的夜色。走进这扇门，你将开始一段奇遇。在这里，我将根据你的喜好、心情，调制专属于你的鸡尾酒，为你带来最奇妙的美好体验。", array: ["周边旅行","谈天说地","聊天","创业咨询","品酒","定制理财"])
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.isHaveShadowColor(false)
                return cell
            }else if (indexPath.row == 6) {
                let identifier = "LastCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
                if cell == nil{
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
                }
                return cell!
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                cell.configCell((userInfoModel.imageArray() as NSArray) .objectAtIndex(indexPath.row - 3) as! String, infoString: (userInfoModel.titleArray() as NSArray).objectAtIndex(indexPath.row - 3) as! String, infoDetail: "")
                if indexPath.row == 4 {
                    var string = "尚未通过身份、职业、电话认证       "
                    let auto_info = UserExtenModel.shareInstance().auth_info
                    if auto_info != "" && auto_info != nil {
                        let autoArray = auto_info.componentsSeparatedByString(",")
                        let dic = (ProfileKeyAndValue.shareInstance().appDic as NSDictionary).objectForKey("auth_info") as! NSDictionary
                        for autoInfo in autoArray {
                            let autoName = dic.objectForKey(autoInfo) as! String
                            let stringArray = string.componentsSeparatedByString(autoName) as NSArray
                            let firstChar = (stringArray[1] as! NSString).substringToIndex(1) 
                            if firstChar == "、" {
                                string = string.stringByReplacingOccurrencesOfString("\(autoName)、" , withString: "")
                            }else{
                                string = string.stringByReplacingOccurrencesOfString("\(autoName)" , withString: "")
                            }
                            
                        }
                        cell.infoDetailLabel.text = string
                        cell.setinfoButtonBackGroudColor(lineLabelBackgroundColor)
                    }
                
                }
                return cell
            }
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(mePhotoTableViewCell, forIndexPath: indexPath) as! MePhotoTableViewCell
                cell.configlogoutView()
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(photoDetailTableViewCell, forIndexPath: indexPath) as! PhotoDetailTableViewCell
                cell.configLogoutView()
                cell.accessoryType = UITableViewCellAccessoryType.None
                return cell
            }else if (indexPath.row == 5) {
                let identifier = "LastCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
                if cell == nil{
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
                }
                return cell!
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(meInfoTableViewCell, forIndexPath: indexPath) as! MeInfoTableViewCell
                if indexPath.row == 2 {
                    cell.hidderLine()
                }
                cell.configCell((userInfoModel.imageArray() as NSArray) .objectAtIndex(indexPath.row - 2) as! String, infoString: (userInfoModel.titleArray() as NSArray).objectAtIndex(indexPath.row - 2) as! String, infoDetail: "")
                return cell
            }
        }
   }
}



