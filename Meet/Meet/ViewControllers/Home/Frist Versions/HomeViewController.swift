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

enum FillterName {
    case NomalList
    case LocationList
    case ReconmondList
}

class HomeViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var tableView:UITableView!
    
    var loginView:LoginView!
    
    var bottomView:UIView!
    var numberMeet:UILabel!
    var page:NSInteger = 0
    var viewModel:HomeViewModel = HomeViewModel()
    var homeModelArray:NSMutableArray = NSMutableArray()
    var offscreenCells:NSMutableDictionary = NSMutableDictionary()
    var locationManager:AMapLocationManager!
    var logtitude:Double = 0.0
    var latitude:Double = 0.0
    var fillterName:FillterName = .ReconmondList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.getProfileKeyAndValues()
        self.setUpLocationManager()
        self.setUpRefreshView()
        self.addLineNavigationBottom()
        self.talKingDataPageName = "Home"
        self.setUpHomeData()
        
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
        self.page = self.page + 1
        var fillter = ""
        if (fillterName == .LocationList) {
            fillter = "location"
        }else{
            fillter = "recommend"
        }
        viewModel.getHomeFilterList("\(self.page)", latitude: latitude, longitude: logtitude, filter: fillter, successBlock: { (dic) in
            let tempArray = HomeModel.mj_objectArrayWithKeyValuesArray(dic)
            self.homeModelArray.addObjectsFromArray(tempArray as [AnyObject])
            self.tableView.reloadData()
//            self.tableView.scrollEnabled = true
            self.tableView.mj_footer.endRefreshing()
            }, failBlock: { (dic) in
                self.page = self.page - 1
                self.setUpHomeData()
                self.tableView.mj_footer.endRefreshing()
            }) { (msg) in
                
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        (self.navigationController as! ScrollingNavigationController).followScrollView(self.tableView, delay: 50.0)
        self.navigationItemCleanColorWithNotLine()
        self.navigationController?.navigationBar.barStyle = .Default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeTableViewBackGroundColor), size: CGSizeMake(ScreenWidth, 64)), forBarMetrics: .Default)
        (self.navigationController as! ScrollingNavigationController).delegate = self
        self.setUpBottomView()
        self.setUpNavigationBar()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        (self.navigationController as! ScrollingNavigationController).showNavbar(animated: false)
    }
    
    func setUpBottomView() {
        bottomView = UIView(frame: CGRectMake(ScreenWidth  - 84,ScreenHeight - 74,56,54))
        bottomView.addSubview(self.meetButton(CGRectMake(0, 0, 54, 54)))
        bottomView.addSubview(self.meetNumber(CGRectMake(bottomView.frame.size.width - 18, 0, 18, 18)))
        KeyWindown?.addSubview(bottomView)
        
    }
    
    func setUpNavigationBar() {
        self.navigationItem.titleView = self.titleView()
        let navigationSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        navigationSpace.width = 5
        
        self.navigationItem.leftBarButtonItems = [navigationSpace,UIBarButtonItem(image: UIImage.init(named: "navigationbar_fittle")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(HomeViewController.leftItemClick(_:)))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage.init(named: "navigationbar_user")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(HomeViewController.rightItemClick(_:))),navigationSpace]
    }
    
    func rightItemClick(sender:UIBarButtonItem) {
//       KeyWindown?.addSubview(PayView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)))
        self.bottomView.removeFromSuperview()
        self.presentViewController(BaseNavigaitonController(rootViewController: MeViewController()) , animated: true) {
    
        }
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
        numberMeet.text = "6"
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
            self.bottomView.removeFromSuperview()
            self.presentOrderView()
        }
    }
    
    func presentOrderView(){
        let orderPageVC = OrderPageViewController()
        let navigationController = UINavigationController(rootViewController: orderPageVC)
        orderPageVC.setBarStyle(.CoverView)
        orderPageVC.progressColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        self.presentViewController(navigationController, animated: true, completion: {
            
        })
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
            self.fillterName = .ReconmondList
            self.tableView.setContentOffset(CGPointMake(0, 0), animated: true)
            self.setUpHomeData()
        }
        let locationAction = UIAlertAction(title: "离我最近", style: .Default) { (locationAction) in
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
                self.presentOrderView()
            }
            self.navigationController?.pushViewController(baseUserInfo, animated: true)
        }
        
        loginView.loginWithOrderListClouse = { _ in
            self.presentOrderView()
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
        self.bottomView.removeFromSuperview()
        (self.navigationController as! ScrollingNavigationController).showNavbar(animated: false)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let meetDetailVC = MeetDetailViewController()
        let model = homeModelArray[indexPath.section] as! HomeModel
        meetDetailVC.user_id = "\(model.uid)"
        self.navigationController?.pushViewController(meetDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translationInView(scrollView.superview)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeTableViewBackGroundColor), size: CGSizeMake(ScreenWidth, 64)), forBarMetrics: .Default)
        if translation.y < -54 {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeDetailViewNameColor), size: CGSizeMake(ScreenWidth, 64)), forBarMetrics: .Default)
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        }else if translation.y > 0{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeTableViewBackGroundColor), size: CGSizeMake(ScreenWidth, 64)), forBarMetrics: .Default)
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)

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
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        }else{
            
        }
    }
}
