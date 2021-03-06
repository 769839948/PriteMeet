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
import DZNEmptyDataSet

typealias successBlock = (_ success:Bool) ->Void

enum FillterName {
    case nomalList
    case locationList
    case reconmondList
}

class HomeViewController: UIViewController,TZImagePickerControllerDelegate {

    var tableView:UITableView!
    
    var loginView:LoginView!
    
    var bottomView:UIView!
    var numberMeet:UILabel!
    var page:NSInteger = 0
    var viewModel:HomeViewModel = HomeViewModel()
    var userInfoViewMode:UserInfoViewModel = UserInfoViewModel()
    
    var homeModelArray:NSMutableArray = NSMutableArray()
    var offscreenCells:NSMutableDictionary = NSMutableDictionary()
    var locationManager:AMapLocationManager!
    var longitude:Double = 0.0
    var latitude:Double = 0.0
    var fillterName:FillterName = .reconmondList
    
    var orderNumberArray = NSMutableArray()
    var allOrderNumber:NSInteger = 0
    
    var isFirstShow:Bool = false
    
    var lastContentOffset:CGFloat = 0
    
    var filterStr:String = ""
    
    var filterSort:String = "recommend"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaultsGetSynchronize("gender") != "" {
           self.filterStr = "&gender=\(UserDefaultsGetSynchronize("gender"))"
        }
        if UserDefaultsGetSynchronize("industry") != "" && UserDefaultsGetSynchronize("industry") != "0" {
            self.filterStr = self.filterStr.appending("&industry=\(UserDefaultsGetSynchronize("industry"))")
        }
        let sortStr = UserDefaultsGetSynchronize("sort")  != "" ? UserDefaultsGetSynchronize("sort"):"recommend"
        self.filterStr = self.filterStr.appending("&filter=\(sortStr)")
        
        self.getProfileKeyAndValues()
        self.setUpLocationManager()
        self.addLineNavigationBottom()

        self.talKingDataPageName = "Home"
        self.getOrderNumber()
        if isFirstShow {
            Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(HomeViewController.addBottomView), userInfo: nil, repeats: false)
            self.isFirstShow = false
        }else{
            if self.loginView == nil {
                self.addBottomView()
            }
        }
        self.view.backgroundColor = UIColor.init(hexString: HomeTableViewBackGroundColor)

        // Do any additional setup after loading the view.
    }

    func setUpTableView() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.backgroundColor = UIColor.init(hexString: HomeTableViewBackGroundColor)
        self.tableView.register(ManListCell.self, forCellReuseIdentifier: "MainTableViewCell")
        self.view.addSubview(self.tableView)
        self.view.sendSubview(toBack: self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        (self.navigationController as! ScrollingNavigationController).followScrollView(self.tableView, delay: 50.0)
        self.view.bringSubview(toFront: self.bottomView)

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
//        locationManager.startUpdatingLocation()
        locationManager.requestLocation(withReGeocode: false) { (location, geocode, error) in
            if error != nil{
                self.setUpHomeData()
                return
            }
            if location != nil{
                self.latitude = (location?.coordinate.latitude)!
                self.longitude = (location?.coordinate.longitude)!
                self.setUpHomeData()
                if UserInfo.isLoggedIn() {
                    self.viewModel.senderLocation(self.latitude, longitude: self.longitude)
                }
            }else{
                self.setUpHomeData()
            }
        }
    }
    
    
    func setUpHomeData() {
        if bottomView != nil {
            bottomView.isHidden = true
        }
        
        if self.homeModelArray.count == 0 {
            self.page = 0;
        }
        
        self.page = self.page + 1
        
        if self.filterStr == "" {
            self.filterStr = "&filter=recommend"
        }
        
        viewModel.getDataFilterList("\(self.page)", filterUrl: self.filterStr, latitude: self.latitude, longitude: self.longitude, successBlock: { (dic) in
            if self.bottomView != nil {
                self.bottomView.isHidden = false
            }
            if self.page == 1 {
                self.homeModelArray.removeAllObjects()
            }
            let tempArray = HomeModel.mj_objectArray(withKeyValuesArray: dic?["data"])
            if tempArray?.count == 0 {
                self.page = self.page - 1
            }
            
            for obj in tempArray! {
                self.homeModelArray.add(obj)
            }
            if (self.tableView == nil) {
                self.setUpTableView()
                self.setUpRefreshView()
            }
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
        }) { (dic) in
            self.page = self.page - 1
            self.setUpHomeData()
            if (self.tableView == nil) {
                self.setUpTableView()
                self.setUpRefreshView()

            }
            self.tableView.mj_footer.endRefreshing()
            if self.bottomView != nil {
                self.bottomView.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.tableView != nil {
            (self.navigationController as! ScrollingNavigationController).followScrollView(self.tableView, delay: 50.0)

        }
        self.navigationItemCleanColorWithNotLine()
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeTableViewBackGroundColor), size: CGSize(width: ScreenWidth, height: 64)), for: .default)
        let navigationController = self.navigationController as! ScrollingNavigationController
        navigationController.scrollingNavbarDelegate = self
        self.navigationController!.navigationBar.isTranslucent = false

        self.setUpNavigationBar()
    }
    
    func addBottomView() {
        self.setUpBottomView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (self.navigationController as! ScrollingNavigationController).showNavbar(animated: false)
    }
    
    func setUpBottomView() {
        bottomView = UIView(frame:CGRect(x: ScreenWidth  - 84,y: ScreenHeight - 88 - self.view.frame.origin.y,width: 56,height: 54))
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bottomView.layer.shadowOpacity = 0.2
        bottomView.tag = 10000
        bottomView.addSubview(self.meetButton(CGRect(x: 0, y: 0, width: 54, height: 54)))
        bottomView.addSubview(self.meetNumber(CGRect(x: bottomView.frame.size.width - 18, y: 0, width: 18, height: 18)))
        if self.allOrderNumber == 0 {
            self.numberMeet.isHidden = true
        }else{
            self.numberMeet.isHidden = false
        }
        if self.view.viewWithTag(10000) == nil {
            self.view.addSubview(bottomView)
        }
    }
    
    func setUpNavigationBar() {
        self.navigationItem.titleView = self.titleView()
        let navigationSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigationSpace.width = 5
        
        self.navigationItem.leftBarButtonItems = [navigationSpace,UIBarButtonItem(image: UIImage.init(named: "navigationbar_fittle")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(HomeViewController.leftItemClick(_:)))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage.init(named: "navigationbar_user")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(HomeViewController.rightItemClick(_:))),navigationSpace]
    }
    
    func rightItemClick(_ sender:UIBarButtonItem) {
//        self.present(UINavigationController(rootViewController: MeViewController()) , animated: true) {
//        }
//        let live = 
        self.present(UINavigationController(rootViewController: InPurchaseViewController()) , animated: true) {
        }
        
//        let apply = ApplyMeetView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: ScreenHeight))
//        KeyWindown?.addSubview(apply)
    }
    
    func meetButton(_ frame:CGRect) -> UIButton {
        let meetButton = UIButton(type: .custom)
        meetButton.frame = frame
        meetButton.layer.cornerRadius = frame.size.width/2
        meetButton.setImage(UIImage.init(named: "meet_order"), for: UIControlState())
        meetButton.backgroundColor = UIColor.init(hexString: HomeDetailViewNameColor)
        meetButton.addTarget(self, action: #selector(HomeViewController.myOrderMeetClick(_:)), for: .touchUpInside)
        
        return meetButton
    }
    
    func meetNumber(_ frame:CGRect) -> UILabel {
        numberMeet = UILabel(frame: frame)
        numberMeet.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        numberMeet.text = "\(allOrderNumber)"
        numberMeet.font = UIFont.systemFont(ofSize: 9)
        numberMeet.textAlignment = .center
        numberMeet.textColor = UIColor.white
        numberMeet.layer.cornerRadius = 9
        numberMeet.layer.masksToBounds = true
        return numberMeet
    }
    
    func myOrderMeetClick(_ sender:UIButton) {
        if !UserInfo.isLoggedIn() {
            
            self.presentLoginView()
        }else{
            self.verificationOrderView()
        }
    }
    
    func verificationOrderView(){
        if orderNumberArray.count == 0 {
            let queue = DispatchQueue(label: "com.meet.order-queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
            queue.async {
                self.getOrderNumber()
            }
            queue.async {
                self.presentOrderView()
            }
        }else{
            self.presentOrderView()
        }
    }
    
    func presentOrderView(){
        let orderPageVC = OrderPageViewController()
        orderPageVC.loadType = .present
        
        orderPageVC.reloadOrderNumber = { _ in
            self.getOrderNumber()
        }
        if orderNumberArray.count != 0 {
            orderPageVC.numberArray = orderNumberArray
        }
        orderPageVC.setBarStyle(.progressBounceView)
        orderPageVC.progressHeight = 0
        orderPageVC.progressWidth = 0
        orderPageVC.adjustStatusBarHeight = true
        orderPageVC.progressColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        let navigationController = UINavigationController(rootViewController: orderPageVC)
        self.present(navigationController, animated: true, completion: {
            
        })
        
    }
    
    func getOrderNumber(){
        let orderViewModel = OrderViewModel()
        self.orderNumberArray.removeAllObjects()
        orderViewModel.orderNumberOrder(UserInfo.sharedInstance().uid, successBlock: { (dic) in
            self.allOrderNumber = 0
            for value in (dic?.values)! {
                self.allOrderNumber = self.allOrderNumber + Int(value as! NSNumber)
            }
            self.orderNumberArray.add("\((dic?["1"]!)!)")
            self.orderNumberArray.add("\((dic?["4"]!)!)")
            self.orderNumberArray.add("\((dic?["6"]!)!)")
            self.orderNumberArray.add("0")
        }) { (dic) in
            
        }
    }
    
    func titleView() ->UIView {
        let image = UIImage.init(named: "navigationbar_title")
        let titleView = UIView(frame: CGRect(x: 0,y: -2,width: (image?.size.width)!,height: (image?.size.height)!))
        let imageView = UIImageView(frame: titleView.frame)
        imageView.image = image
        titleView.addSubview(imageView)
        return titleView
    }
    
    func leftItemClick(_ sender:UIBarButtonItem) {
        let filterView = FilterViewController()
        filterView.genderStr = UserDefaultsGetSynchronize("gender") != "" ? UserDefaultsGetSynchronize("gender"):"0"
        filterView.filterStr = UserDefaultsGetSynchronize("sort")  != "" ? UserDefaultsGetSynchronize("sort"):"recommend"
        filterView.instureStr = UserDefaultsGetSynchronize("industry")  != "" ? UserDefaultsGetSynchronize("industry"):"0"
        filterView.fileStringClouse = { str,gender,sort,instury in
            self.filterStr = str
            UserDefaultsSetSynchronize(gender, key: "gender")
            UserDefaultsSetSynchronize(sort, key: "sort")
            UserDefaultsSetSynchronize(instury, key: "industry")
            self.page = 0;
            self.tableView.scrollToRow(at: NSIndexPath.init(row: 0, section: 0) as IndexPath, at: .top, animated: false)
            self.setUpHomeData()
        }
        let controller = UINavigationController(rootViewController: filterView)
        self.present(controller, animated: true) { 
            
        }
    }
    
    func setUpRefreshView() {
        self.tableView.mj_footer = MeetRefreshBackFooter.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.setUpHomeData))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureCell(_ cell:ManListCell, indexPath:IndexPath) {
        let model = self.homeModelArray[(indexPath as NSIndexPath).section] as! HomeModel
        cell.configCell(model, interstArray: model.personal_label.components(separatedBy: ","))
    }
    
    func presentLoginView(){
        let loginView = LoginViewController()
        let controller = UINavigationController(rootViewController: loginView)
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
        self.navigationController?.present(controller, animated: true, completion: {
            
        })
    }
    
    func createLikeUser(_ user_id:String,block:@escaping successBlock) {
        userInfoViewMode.likeUser(user_id, successBlock: { (dic) in
            block(true)
            }) { (dic) in
            MainThreadAlertShow(dic?["error"] as! String, view: self.view)

        }
    }
    
    func deleteLikeUser(_ user_id:String, block:@escaping successBlock) {
        userInfoViewMode.deleteLikeUser(user_id, successBlock: { (dic) in
            block(true)
        }) { (dic) in
            MainThreadAlertShow(dic?["error"] as! String, view: self.view)
            
        }
    }
    
    func hiderBottomView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            let frame = self.bottomView.frame
            self.bottomView.frame = CGRect(x: frame.origin.x, y: ScreenHeight + self.view.frame.origin.y, width: 56, height: 54)
        }) { (finish) in
            
        }
    }
    func showBottomView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            let frame = self.bottomView.frame
            self.bottomView.frame = CGRect(x: frame.origin.x, y: ScreenHeight - 88 - self.view.frame.origin.y, width: 56, height: 54)
        }) { (finish) in
            
        }
    }
    
    
    func showLoacationAlert(){
        let alertAction = UIAlertController(title: "定位服务未开启", message: "请在手机设置中开启定位服务可以看到用户据您多远", preferredStyle: .alert)
        let canCelAction = UIAlertAction.init(title: "知道了", style: .default) { (cancelAction) in
            self.setUpHomeData()
        }
        
        let openAction = UIAlertAction.init(title: "开启定位", style: .default) { (openAction) in
            let url = URL.init(string: "prefs:root=LOCATION_SERVICES")
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.openURL(url!)
            }
        }
        alertAction.addAction(canCelAction)
        alertAction.addAction(openAction)
        self.present(alertAction, animated: true) {
            
        }
    }

}


extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "MainTableViewCell", configuration: { (cell) in
            self.configureCell(cell as! ManListCell, indexPath: indexPath)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (self.navigationController as! ScrollingNavigationController).showNavbar(animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
        let meetDetailVC = MeetDetailViewController()
        let model = homeModelArray[(indexPath as NSIndexPath).section] as! HomeModel
        meetDetailVC.user_id = "\(model.uid)"
        let cell = tableView.cellForRow(at: indexPath) as! ManListCell
        meetDetailVC.reloadHomeListLike = { isLike, number in
            if isLike {
                
                cell.likeBtn.tag = 1
                model.liked_count = number
                cell.reloadNumber(ofMeet: isLike, number: number)
                cell.reloadLikeBtnImage(true)
                self.tableView.reloadSections(NSIndexSet.init(index: indexPath.section) as IndexSet, with: .automatic)
            }else{
                cell.likeBtn.tag = 0
                model.liked_count = number
                cell.reloadNumber(ofMeet: isLike, number: number)
                cell.reloadLikeBtnImage(false)
                self.tableView.reloadSections(NSIndexSet.init(index: indexPath.section) as IndexSet, with: .automatic)
            }
            
        }
        self.navigationController?.pushViewController(meetDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.bottomView != nil {
            if (lastContentOffset < scrollView.contentOffset.y) {
                self.hiderBottomView()
            }else{
                self.showBottomView()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y;
        if self.bottomView != nil {
            self.showBottomView()
        }
    }
}



extension HomeViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndef = "MainTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndef, for: indexPath) as! ManListCell
        self.configureCell(cell, indexPath: indexPath)
        cell.selectionStyle = .none
        let model = homeModelArray[(indexPath as NSIndexPath).section] as! HomeModel
        cell.block = { isLike, user_id in
            if UserInfo.isLoggedIn() {
                if isLike {
                    self.deleteLikeUser(user_id!, block: { (success) in
                        cell.likeBtn.tag = 0
                        model.liked = false
                        cell.reloadLikeBtnImage(false)
                        model.liked_count = model.liked_count - 1
                        cell.reloadNumber(ofMeet: isLike,number: model.liked_count)
                    })
                }else{
                    self.createLikeUser(user_id!, block: { (success) in
                        cell.likeBtn.tag = 1
                        model.liked = true
                        model.liked_count = model.liked_count + 1
                        cell.reloadLikeBtnImage(true)
                        cell.reloadNumber(ofMeet: isLike,number: model.liked_count)
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
    
    func amapLocationManager(_ manager: AMapLocationManager!, didStartMonitoringFor region: AMapLocationRegion!) {
        
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didEnter region: AMapLocationRegion!) {
        
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didChange status: CLAuthorizationStatus) {
        if status == .notDetermined {
//            self.page = 0
            self.showLoacationAlert()
        }else if status == .denied {
//            self.page = 0
            self.showLoacationAlert()
        }else if status == .authorizedWhenInUse || status == .authorizedAlways
        {
//            self.page = 0
            locationManager.requestLocation(withReGeocode: false) { (location, geocode, error) in
                if error != nil{
//                    self.showLoacationAlert()
                    return
                }
                if location != nil{
                    self.latitude = (location?.coordinate.latitude)!
                    self.longitude = (location?.coordinate.longitude)!
                    self.setUpHomeData()
                    if UserInfo.isLoggedIn() {
                        self.viewModel .senderLocation(self.latitude, longitude: self.longitude)
                    }
                }else{
                    self.setUpHomeData()
                }
            }
        }
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        if location != nil {
            self.latitude = (location?.coordinate.latitude)!
            self.longitude = (location?.coordinate.longitude)!
//            self.setUpHomeData()
        }
    }
}

extension HomeViewController: ScrollingNavigationControllerDelegate {
    func scrollingNavigationController(_ controller: ScrollingNavigationController, didChangeState state: NavigationBarState) {
        if state == .expanded {
            UIApplication.shared.setStatusBarStyle(.default, animated: true)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeTableViewBackGroundColor), size: CGSize(width: ScreenWidth, height: 64)), for: .default)
        }else if state == .collapsed {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeDetailViewNameColor), size: CGSize(width: ScreenWidth, height: 64)), for: .default)
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        }else{
        }
    }
}

extension HomeViewController : DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func  emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

extension HomeViewController : DZNEmptyDataSetSource {
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "暂无符合的朋友\n更改筛选条件再试试吧"
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        paragraph.lineSpacing = 5.0
        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0),NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:UIColor.init(hexString: EmptyDataTitleColor)]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "none_filter_user")
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -20
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 28
    }
}

