//
//  HomeViewController.swift
//  Meet
//
//  Created by Zhang on 8/8/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import MJRefresh
import MJExtension
import TZImagePickerController

typealias successBlock = (success:Bool) ->Void

enum FillterName {
    case NomalList
    case LocationList
    case ReconmondList
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    
    var loginView:LoginView!
    
    var bottomView:UIView!
    var numberMeet:UILabel!
    var page:NSInteger = 0
    var viewModel:HomeViewModel = HomeViewModel()
    var userInfoViewMode:UserInfoViewModel = UserInfoViewModel()
    
    var homeModelArray:NSMutableArray = NSMutableArray()
    var offscreenCells:NSMutableDictionary = NSMutableDictionary()
    var locationManager:AMapLocationManager!
    var logtitude:Double = 0.0
    var latitude:Double = 0.0
    var fillterName:FillterName = .ReconmondList
    
    var orderNumberArray = NSMutableArray()
    var allOrderNumber:NSInteger = 0
    
    var isFirstShow:Bool = false
    
    var lastContentOffset:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.getProfileKeyAndValues()
        self.setUpLocationManager()
        self.setUpRefreshView()
        self.addLineNavigationBottom()
        self.talKingDataPageName = "Home"
        self.setUpHomeData()
        self.getOrderNumber()
        if isFirstShow {
            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(HomeViewController.addBottomView), userInfo: nil, repeats: false)
            self.isFirstShow = false
        }else{
            if self.loginView == nil {
                self.addBottomView()
            }
        }

        // Do any additional setup after loading the view.
    }

    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.view.addSubview(self.tableView)
        self.tableView.backgroundColor = UIColor.init(hexString: HomeTableViewBackGroundColor)
        self.tableView.registerClass(ManListCell.self, forCellReuseIdentifier: "MainTableViewCell")
    }
    
    func getProfileKeyAndValues() {
        viewModel.getDicMap({ (dic) in
            ProfileKeyAndValue.shareInstance().appDic = dic
            }) { (dic) in
                
        }
        viewModel.getAllPlachText({ (dic) in
            PlaceholderText.shareInstance().appDic = dic
            }) { (dic) in
        
        }
    }
    
    func setUpLocationManager(){
        locationManager = AMapLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 3
        locationManager.reGeocodeTimeout = 2
        locationManager.delegate = self
        locationManager.requestLocationWithReGeocode(false) { (location, geocode, error) in
            if error != nil && error.code == 1{
                return
            }
            if location != nil{
                self.latitude = location.coordinate.latitude
                self.logtitude = location.coordinate.longitude
                if UserInfo.isLoggedIn() {
                    self.viewModel .senderLocation(self.latitude, longitude: self.logtitude)
                }
            }
        }
    }
    
    
    func setUpHomeData() {
        if bottomView != nil {
            bottomView.hidden = true
        }
        
        self.page = self.page + 1
        var fillter = ""
        if (fillterName == .LocationList) {
            fillter = "location"
        }else{
            fillter = "recommend"
        }
        viewModel.getHomeFilterList("\(self.page)", latitude: latitude, longitude: logtitude, filter: fillter, successBlock: { (dic) in
            let tempArray = HomeModel.mj_objectArrayWithKeyValuesArray(dic)
            if self.page == 1 {
                self.homeModelArray.removeAllObjects()
            }
            self.homeModelArray.addObjectsFromArray(tempArray as [AnyObject])

            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
            if self.bottomView != nil {
                self.bottomView.hidden = false
            }

            }, failBlock: { (dic) in
                self.page = self.page - 1
                self.setUpHomeData()
                self.tableView.mj_footer.endRefreshing()
                if self.bottomView != nil {
                    self.bottomView.hidden = false
                }

            }) { (msg) in
                
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        (self.navigationController as! ScrollingNavigationController).followScrollView(self.tableView, delay: 50.0)
        self.navigationItemCleanColorWithNotLine()
        self.navigationController?.navigationBar.barStyle = .Default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeTableViewBackGroundColor), size: CGSizeMake(ScreenWidth, 64)), forBarMetrics: .Default)
        let navigationController = self.navigationController as! ScrollingNavigationController
        navigationController.scrollingNavbarDelegate = self
        self.navigationController!.navigationBar.translucent = false

        self.setUpNavigationBar()
    }
    
    func addBottomView() {
        self.setUpBottomView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        (self.navigationController as! ScrollingNavigationController).showNavbar(animated: false)
    }
    
    func setUpBottomView() {
        bottomView = UIView(frame:CGRectMake(ScreenWidth  - 84,ScreenHeight - 88 - self.view.frame.origin.y,56,54))
        bottomView.layer.shadowOffset = CGSizeMake(0, 4)
        bottomView.layer.shadowOpacity = 0.2
        bottomView.addSubview(self.meetButton(CGRectMake(0, 0, 54, 54)))
        bottomView.addSubview(self.meetNumber(CGRectMake(bottomView.frame.size.width - 18, 0, 18, 18)))
        if self.allOrderNumber == 0 {
            self.numberMeet.hidden = true
        }else{
            self.numberMeet.hidden = false
        }
        self.view.addSubview(bottomView)
        
    }
    
    func setUpNavigationBar() {
        self.navigationItem.titleView = self.titleView()
        let navigationSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        navigationSpace.width = 5
        
        self.navigationItem.leftBarButtonItems = [navigationSpace,UIBarButtonItem(image: UIImage.init(named: "navigationbar_fittle")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(HomeViewController.leftItemClick(_:)))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage.init(named: "navigationbar_user")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(HomeViewController.rightItemClick(_:))),navigationSpace]
    }
    
    func rightItemClick(sender:UIBarButtonItem) {
        self.presentViewController(UINavigationController(rootViewController: MeViewController()) , animated: true) {
        }
//        let imagePickerVC = TZImagePickerController(maxImagesCount: 2, delegate: self)
//        imagePickerVC.navigationBar.barTintColor = UIColor.whiteColor()
//        imagePickerVC.navigationBar.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
//        imagePickerVC.allowPickingVideo = false
//        imagePickerVC.allowTakePicture = false
//        imagePickerVC.barItemTextFont = NavigationBarRightItemFont
//        imagePickerVC.oKButtonTitleColorNormal = UIColor.init(hexString: HomeDetailViewNameColor)
//        imagePickerVC.oKButtonTitleColorDisabled = UIColor.init(hexString: lineLabelBackgroundColor)
//        imagePickerVC.allowPickingOriginalPhoto = true
////        let imagePickerVC = TZImagePickerController(navigationBarClass: self.navigationController?.navigationBar.self(), toolbarClass: nil)
//        imagePickerVC.barItemTextColor = UIColor.init(hexString: HomeDetailViewNameColor)
//        imagePickerVC.didFinishPickingPhotosHandle = { photos,assets,isfinst in
//            
//        }
//        // You can get the photos by block, the same as by delegate.
//        // 你可以通过block或者代理，来得到用户选择的照片.
//        
//        self.presentViewController(imagePickerVC , animated: true) {
//        }
    }
    
    func meetButton(frame:CGRect) -> UIButton {
        let meetButton = UIButton(type: .Custom)
        meetButton.frame = frame
        meetButton.layer.cornerRadius = frame.size.width/2
        meetButton.setImage(UIImage.init(named: "meet_order"), forState: .Normal)
        meetButton.backgroundColor = UIColor.init(hexString: HomeDetailViewNameColor)
        meetButton.addTarget(self, action: #selector(HomeViewController.myOrderMeetClick(_:)), forControlEvents: .TouchUpInside)
        
        return meetButton
    }
    
    func meetNumber(frame:CGRect) -> UILabel {
        numberMeet = UILabel(frame: frame)
        numberMeet.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        numberMeet.text = "\(allOrderNumber)"
        numberMeet.font = UIFont.systemFontOfSize(9)
        numberMeet.textAlignment = .Center
        numberMeet.textColor = UIColor.whiteColor()
        numberMeet.layer.cornerRadius = 9
        numberMeet.layer.masksToBounds = true
        return numberMeet
    }
    
    func myOrderMeetClick(sender:UIButton) {
        if !UserInfo.isLoggedIn() {
            
            self.presentLoginView()
        }else{
            self.verificationOrderView()
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
        let navigationController = UINavigationController(rootViewController: orderPageVC)
        self.presentViewController(navigationController, animated: true, completion: {
            
        })
        
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
            if self.numberMeet != nil && self.allOrderNumber != 0 {
                self.numberMeet.text = "\(self.allOrderNumber)"
            }
            self.orderNumberArray.addObject("\(countDic["1"]!)")
            self.orderNumberArray.addObject("\(countDic["4"]!)")
            self.orderNumberArray.addObject("\(countDic["6"]!)")
            self.orderNumberArray.addObject("0")
        }) { (dic) in
            
        }
    }
    
    func titleView() ->UIView {
        let image = UIImage.init(named: "navigationbar_title")
        let titleView = UIView(frame: CGRectMake(0,-2,(image?.size.width)!,(image?.size.height)!))
        let imageView = UIImageView(frame: titleView.frame)
        imageView.image = image
        titleView.addSubview(imageView)
        return titleView
    }
    
    func leftItemClick(sender:UIBarButtonItem) {
        let leftAlerController = UIAlertController(title: "筛选", message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (cancelAction) in
        }
        let commdListAction = UIAlertAction(title: "智能推荐", style: .Default) { (commdListAction) in
            self.page = 0
            self.fillterName = .ReconmondList
            self.tableView.setContentOffset(CGPointMake(0, 0), animated: true)
            self.setUpHomeData()
        }
        let locationAction = UIAlertAction(title: "离我最近", style: .Default) { (locationAction) in
            self.page = 0
            self.fillterName = .LocationList
            self.tableView.setContentOffset(CGPointMake(0, 0), animated: true)
            self.setUpHomeData()
        }
        leftAlerController.addAction(cancelAction)
        leftAlerController.addAction(commdListAction)
        leftAlerController.addAction(locationAction)
        self.presentViewController(leftAlerController, animated: true) { 
            
        }
    }
    
    func setUpRefreshView() {
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.setUpHomeData))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureCell(cell:ManListCell, indexPath:NSIndexPath) {
        let model = self.homeModelArray[indexPath.section] as! HomeModel
        cell.configCell(model, interstArray: model.personal_label.componentsSeparatedByString(","))
    }
    
    func presentLoginView(){
        loginView = LoginView(frame: CGRectMake(0,0,ScreenWidth,ScreenHeight))
        loginView.tag = 200;
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
            let baseUserInfo =  Stroyboard("Me", viewControllerId: "BaseInfoViewController") as! BaseUserInfoViewController
            baseUserInfo.isHomeListViewLogin = true
            baseUserInfo.homeListBlock = { _ in
//                self.verificationOrderView()
            }
            self.navigationController?.pushViewController(baseUserInfo, animated: true)
        }
        
        loginView.loginWithOrderListClouse = { _ in
//            self.verificationOrderView()
        }
        
        loginView.orderListShorOrderButton = { _ in
//            self.setUpBottomView()
        }
    }
    
    func createLikeUser(user_id:String,block:successBlock) {
        userInfoViewMode.likeUser(user_id, successBlock: { (dic) in
            block(success: true)
            }) { (dic) in
            UITools.showMessageToView(self.view, message: dic["error"] as! String, autoHide: true)

        }
    }
    
    func deleteLikeUser(user_id:String, block:successBlock) {
        userInfoViewMode.deleteLikeUser(user_id, successBlock: { (dic) in
            block(success: true)
        }) { (dic) in
            UITools.showMessageToView(self.view, message: dic["error"] as! String, autoHide: true)
            
        }
    }

}


extension HomeViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model = homeModelArray[indexPath.section] as! HomeModel
        return tableView.fd_heightForCellWithIdentifier("MainTableViewCell", cacheByKey: "\(model.uid)", configuration: { (cell) in
            self .configureCell(cell as! ManListCell, indexPath: indexPath)
        })
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        (self.navigationController as! ScrollingNavigationController).showNavbar(animated: false)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let meetDetailVC = MeetDetailViewController()
        let model = homeModelArray[indexPath.section] as! HomeModel
        meetDetailVC.user_id = "\(model.uid)"
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ManListCell
        meetDetailVC.reloadHomeListLike = { isLike in
            if isLike {
                cell.likeBtn.tag = 1
                cell.reloadLikeBtnImage(true)
            }else{
                cell.likeBtn.tag = 0
                cell.reloadLikeBtnImage(false)
            }
            
        }
        self.navigationController?.pushViewController(meetDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (lastContentOffset < scrollView.contentOffset.y) {
           self.hiderBottomView()
        }else{
            self.showBottomView()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y;
        self.showBottomView()
    }
    
    func hiderBottomView() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            let frame = self.bottomView.frame
            self.bottomView.frame = CGRectMake(frame.origin.x, ScreenHeight + self.view.frame.origin.y, frame.size.width, frame.size.height)
        }) { (finish) in
            
        }
    }
    func showBottomView() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            let frame = self.bottomView.frame
            self.bottomView.frame = CGRectMake(frame.origin.x, ScreenHeight - 88 - self.view.frame.origin.y, frame.size.width, frame.size.height)
        }) { (finish) in
            
        }
    }
}

extension HomeViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return homeModelArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndef = "MainTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndef, forIndexPath: indexPath) as! ManListCell
        self.configureCell(cell, indexPath: indexPath)
        cell.selectionStyle = .None
        cell.block = { isLike, user_id in
            if UserInfo.isLoggedIn() {
                if isLike {
                    self.deleteLikeUser(user_id, block: { (success) in
                        cell.likeBtn.tag = 0
                        cell.reloadLikeBtnImage(false)
                    })
                }else{
                    self.createLikeUser(user_id, block: { (success) in
                        cell.likeBtn.tag = 1
                        cell.reloadLikeBtnImage(true)
                    })
                }
            }else{
                self.presentLoginView()
            }
        }
        return cell
    }
    
    
}

extension HomeViewController : AMapLocationManagerDelegate {
    
    func amapLocationManager(manager: AMapLocationManager!, didStartMonitoringForRegion region: AMapLocationRegion!) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didEnterRegion region: AMapLocationRegion!) {
        
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .NotDetermined {
            viewModel.senderIpAddress({ (dic) in
                let manager = dic as NSDictionary
                self.latitude = (manager["lat"]?.doubleValue)!
                self.logtitude = (manager["lon"]?.doubleValue)!
                }, fail: { (dic) in
                    
            })
        }else if status == .Denied {
            viewModel.senderIpAddress({ (dic) in
                let manager = dic as NSDictionary
                self.latitude = (manager["lat"]?.doubleValue)!
                self.logtitude = (manager["lon"]?.doubleValue)!
                }, fail: { (dic) in
                    
            })
        }else if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            self.setUpHomeData()
        }
    }
}

extension HomeViewController: ScrollingNavigationControllerDelegate {
    func scrollingNavigationController(controller: ScrollingNavigationController, didChangeState state: NavigationBarState) {
        if state == .Expanded {
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeTableViewBackGroundColor), size: CGSizeMake(ScreenWidth, 64)), forBarMetrics: .Default)
        }else if state == .Collapsed {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeDetailViewNameColor), size: CGSizeMake(ScreenWidth, 64)), forBarMetrics: .Default)
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        }else{
        }
    }
}

extension HomeViewController : TZImagePickerControllerDelegate {
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
