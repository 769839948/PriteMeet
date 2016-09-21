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
import SDWebImage

let aboutUsStr = "您的个人介绍空空如也，完善后可大大提高约见成功率哦。"

class MeViewController: UIViewController,TZImagePickerControllerDelegate {

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
    
    var plachImageList:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.loadExtenInfo()
        if UserInfo.isLoggedIn() {
            self.getOrderNumber()
        }
        self.talKingDataPageName = "Me"
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        self.navigationItemWithLineAndWihteColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addLineNavigationBottom()
        self.navigationController?.navigationBar.isTranslucent = false
        self.setNavigationBar()
        if UserInfo.isLoggedIn() {
            if self.tableView.style == .plain {
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
            if UserDefaults.standard.object(forKey: "lastModifield") != nil{
                let tempTime = UserDefaults.standard.object(forKey: "lastModifield")
                if (tempTime as! String) != (updateTime! as String){
                    self.userInfoModel.getUserInfo(UserInfo.sharedInstance().uid, success: { (dic) in
                        UserInfo.synchronize(withDic: dic)
                        self.tableView.reloadData()
                        UserDefaults.standard.set(updateTime, forKey: "lastModifield")
                        }, fail: { (dic) in
                            
                        }, loadingString: { (msg) in
                            
                    })
                }
            }else{
                UserDefaults.standard.set(updateTime, forKey: "lastModifield")
            }
        }) { (error) in
                
        }
    }
    
    func setUpTableView(){
        if UserInfo.isLoggedIn() {
            tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
            tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        }else{
            tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
            tableView.backgroundColor = UIColor.white
        }
        
        let meInfoNib = UINib(nibName: "MeInfoTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.register(meInfoNib, forCellReuseIdentifier: "MeInfoTableViewCell")
        let mePhotoNib = UINib(nibName: "MePhotoTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.register(mePhotoNib, forCellReuseIdentifier: "MePhotoTableViewCell")
        let mePhotoDetailNib = UINib(nibName: "PhotoDetailTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.register(mePhotoDetailNib, forCellReuseIdentifier: "PhotoDetailTableViewCell")
        
        self.tableView.register(NewMeetInfoTableViewCell.self, forCellReuseIdentifier: newMeetInfoTableViewCell)
        self.tableView.register(AboutUsCell.self, forCellReuseIdentifier: "AboutUsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        })
    }
    
    func loadExtenInfo(){
        userInfoModel.getMoreExtInfo("", success: { (dic) in
            UserExtenModel.synchronize(withDic: dic)
            self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 1)], with: .automatic)
            self.plachImageListDownLoad()
            }, fail: { (dic) in
                
            }, loadingString: { (msg) in
              
        })
    }
    
    func loadInviteInfo(){
        userInfoModel.getInvite({ (dic) in
            UserInviteModel.synchronize(withDic: dic)
            self.tableView.reloadRows(at: [IndexPath.init(row: 3, section: 1)], with: .automatic)
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()

            })
            }, fail: { (dic) in
                
            }) { (msg) in
                
        }
    }
    
    func setNavigationBar(){
        if UserInfo.isLoggedIn() {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(MeViewController.cancelPress(_:)))
            if UserInfo.sharedInstance().completeness != nil && UserInfo.sharedInstance().completeness.next_page != 4  {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_settingsBlack")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(MeViewController.rightPress(_:)))
            }else{
                let settingItem = UIBarButtonItem(image:UIImage.init(named: "me_settingsBlack")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(MeViewController.rightPress(_:)))
                let editButton = UIBarButtonItem(image: UIImage.init(named: "me_editBlack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(MeViewController.editPress(_:)))
                self.navigationItem.setRightBarButtonItems([settingItem,editButton], animated: true)
            }
        }else{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(MeViewController.cancelPress(_:)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_settingsBlack")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(MeViewController.rightPress(_:)))
        }
    }

    func cancelPress(_ sender:UIBarButtonItem){
        self.dismiss(animated: true) { 
        }
    }
    
    func editPress(_ sender:UIBarButtonItem){
        self.pushProfileViewControllr()
    }
    
    func rightPress(_ sender:UIBarButtonItem){
        let settingVC = Stroyboard("Seting", viewControllerId: "SetingViewController") as!  SetingViewController
        settingVC.logoutBlock = {()
            self.tableView.reloadData()
        }
        self.navigationController!.pushViewController(settingVC, animated:true)
    }
    
    
    func plachImageListDownLoad(){
        let manage = SDWebImageManager()
        let plachImageSize = CGSize(width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355)
        let plachImageWidth = Int(plachImageSize.width)
        let plachImageHeight = Int(plachImageSize.height)
        let image = UIImage.init(color: UIColor.clear, size: plachImageSize)
        for model in UserExtenModel.shareInstance().head_photo_list {
            let url = Head_Photo_List.mj_object(withKeyValues: model) as Head_Photo_List
            plachImageList.add(image)
            let urlStr = URL.init(string: url.photo + "?imageView2/1/w/\(plachImageWidth)/h/\(plachImageHeight)")
            manage.downloadImage(with: urlStr, options: .retryFailed, progress: { (start, end) in
                
                }, completed: { (image, error, cache, finist, url) in
                    if image != nil {
                        let urlString = url?.absoluteString.components(separatedBy: "?")
                        for urlIndex in  0...UserExtenModel.shareInstance().head_photo_list.count - 1 {
                            let headModel = Head_Photo_List.mj_object(withKeyValues: UserExtenModel.shareInstance().head_photo_list[urlIndex])
                            if urlString?[0] == headModel?.photo {
                                self.plachImageList.replaceObject(at: urlIndex, with: image)
                            }
                        }
                    }
            })
        }
    }
    
    func downLoadUserWeChatImage(){
        NetWorkObject.downloadTask(UserInfo.sharedInstance().avatar, progress: { (Progress) in
            
            }, destination: { (url, response) -> URL! in
                var documentsDirectoryURL = URL.init(string:"")
                do{
                    documentsDirectoryURL = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
                }catch{
                    
                }
                return documentsDirectoryURL! .appendingPathComponent(response!.suggestedFilename!)
        }) {(response, url, error) in
                let image = UIImage(contentsOfFile: url!.path)
                UserInfo.saveCacheImage(image, withName: "cover_photo")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pushViewController(_ tag:NSInteger){
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
        return description!
    }
    
    func instrestArray() -> NSArray {
        let array = NSMutableArray()
        array.addObjects(from: UserInviteModel.themArray(0))
        return array.copy() as! NSArray
    }
    
    func configNewMeetCell(_ cell:NewMeetInfoTableViewCell, indxPath:IndexPath)
    {
        if self.instrestArray().count != 0 {
            cell.configCell(self.descriptionString(), array: self.instrestArray() as [AnyObject], andStyle: .ItemWhiteColorAndBlackBoard)
        }
    }
    
    func presentViewLoginViewController(){
        let loginView = LoginViewController()
        let controller = UINavigationController(rootViewController: loginView)
        
        loginView.reloadMeViewClouse = { _ in
            self.viewWillAppear(true)
        }
        
        self.present(controller, animated: true) {
            
        }
    }
    
    func verificationOrderView(){
        if orderNumberArray.count == 0 {
//            let queue = DispatchQueue(label: "com.meet.order", qos: DispatchQoS.default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: 0)
////            let queue = DispatchQueue(label: "com.meet.order-queue",
////                                              attributes: dispatch_queue_attr_make_with_qos_class(DispatchQueue.Attributes(), DispatchQoS.QoSClass.userInitiated, 0))
//            
//            queue.async {
//                self.getOrderNumber()
//            }
//            queue.async {
//                DispatchQueue.main.async(execute: {
//                    self.presentOrderView()
//                })
//            }
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
        orderPageVC.setBarStyle(.progressBounceView)
        orderPageVC.progressHeight = 0
        orderPageVC.progressWidth = 0
        orderPageVC.adjustStatusBarHeight = true
        orderPageVC.progressColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        orderPageVC.loadType = .push
        self.navigationController?.pushViewController(orderPageVC, animated: true)
    }
    
    func uploadImages(_ images:NSArray) {
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
                    self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .automatic)
                }else{
                    currentIndex = currentIndex + 1
                }
                }, fail: { (dic) in
                    centerView.removeFromSuperview()
                    MainThreadAlertShow("上传失败", view: self.view)
            })
        }
    }
    
    func presentImagePicker() {
        var maxCount = 8
        if UserExtenModel.shareInstance().head_photo_list != nil {
            maxCount = maxCount - UserExtenModel.shareInstance().head_photo_list.count
        }
        let imagePickerVC = TZImagePickerController(maxImagesCount: maxCount, delegate: self)
        imagePickerVC?.navigationBar.barTintColor = UIColor.white
        imagePickerVC?.navigationBar.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
        imagePickerVC?.allowPickingVideo = false
        imagePickerVC?.allowTakePicture = false
        imagePickerVC?.oKButtonTitleColorNormal = UIColor.init(hexString: HomeDetailViewNameColor)
        imagePickerVC?.oKButtonTitleColorDisabled = UIColor.init(hexString: lineLabelBackgroundColor)
        imagePickerVC?.allowPickingOriginalPhoto = true
        self.present(imagePickerVC!, animated: true) { 
            
        }
    }
    
     func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool)
    {
        self.uploadImages(photos as NSArray)
    }
    
     func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable: Any]]!) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        
    }
    // If user picking a video, this callback will be called.
    // If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
    // 如果用户选择了一个视频，下面的handle会被执行
    // 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
    private func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: AnyObject!) {
        
    }
    
    func presentImageBrowse(_ index:NSInteger, images:NSArray) {
        let pbVC = PhotoBrowser()
        pbVC.isNavBarHidden = true
//        pbVC.isStatusBarHidden = false
        /**  设置相册展示样式  */
        pbVC.showType = PhotoBrowser.ShowType.push
        /**  设置相册类型  */
        pbVC.photoType = PhotoBrowser.PhotoType.host
        
        //强制关闭显示一切信息
        pbVC.hideMsgForZoomAndDismissWithSingleTap = true
        
        var models: [PhotoBrowser.PhotoModel] = []
        
        pbVC.avatar = UserInfo.sharedInstance().avatar
        pbVC.realName = UserInfo.sharedInstance().real_name
        pbVC.jobName = UserInfo.sharedInstance().job_label
        let imageArray = UserExtenModel.shareInstance().head_photo_list
        var imageCount:NSInteger = 0
        for image in imageArray! {
            models.append(PhotoBrowser.PhotoModel(hostHDImgURL: image.photo, hostThumbnailImg: plachImageList[imageCount] as! UIImage, titleStr: ("\(image.photo_id)"), descStr: nil, sourceView: nil))
            imageCount = imageCount + 1
        }

        pbVC.deletePhoto = { (_ index:NSInteger, _ photoid:String, _ deleteSucess: @escaping DeleteSuccess) -> Void in
            self.userInfoModel.deleteImage(photoid, successBlock: { (dic) in
                    deleteSucess(true)
                self.loadExtenInfo()
                }, fail: { (dic) in
                    deleteSucess(false)
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
            self.allOrderNumber = 0
            for value in (dic?.values)! {
                self.allOrderNumber = self.allOrderNumber + Int(value as! NSNumber)
            }
            self.orderNumberArray.add("\((dic?["1"]!)!)")
            self.orderNumberArray.add("\((dic?["4"]!)!)")
            self.orderNumberArray.add("\((dic?["6"]!)!)")
            self.orderNumberArray.add("0")
            self.tableView.reloadRows(at: [IndexPath.init(row: 5, section: 1)], with: .automatic)
        }) { (dic) in
            
        }
    }
    
    func configAboutUsCell(_ cell:AboutUsCell, indexPath:IndexPath) {
        if UserExtenModel.shareInstance().experience != nil {
            if UserExtenModel.shareInstance().experience != "" && UserExtenModel.shareInstance().highlight != ""{
                cell.configCell(UserExtenModel.shareInstance().experience, info: UserExtenModel.shareInstance().highlight)
            }else {
                cell.configCell(UserExtenModel.shareInstance().experience, info:                 (PlaceholderText.shareInstance().appDic as NSDictionary).object(forKey: "1000009") as! String)
                
            }
        }
    }

}

extension MeViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UserInfo.isLoggedIn() {
            return 7
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 23
        }
        return 0.0001
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,animated:true)
        if (!UserInfo.isLoggedIn()) {
//            UserInfo.sharedInstance().uid = "159"
//            let modelv = LoginViewModel()
//            modelv.getUserInfo("159", success: { (dic) in
//                UserInfo.synchronize(withDic: dic)
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
        switch (indexPath as NSIndexPath).section {
        case 0:
            switch (indexPath as NSIndexPath).row {
            case 0:
                self.pushProfileViewControllr()
            default:
                
                if  UserExtenModel.shareInstance().head_photo_list != nil && UserExtenModel.shareInstance().head_photo_list.count == 0 {
                    self.presentImagePicker()
                }
                break;
            }
        default:
            switch (indexPath as NSIndexPath).row {
            case 0,1:
                self.pushHightLightVC()
            case 2,3:
                let senderInviteVC = Stroyboard("Me", viewControllerId: "SenderInviteViewController") as!  SenderInviteViewController
                self.navigationController!.pushViewController(senderInviteVC, animated:true)
            case 4:
                let cell = tableView.cellForRow(at: indexPath) as! MeInfoTableViewCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UserInfo.isLoggedIn() {
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return ScreenWidth*236/355 + 116
                default:
                    return 115
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 1:
                    return tableView.fd_heightForCell(withIdentifier: "AboutUsCell", configuration: { (cell) in
                        self.configAboutUsCell(cell as! AboutUsCell, indexPath: indexPath)
                    })
                case 3:
                    return tableView.fd_heightForCell(withIdentifier: newMeetInfoTableViewCell, configuration: { (cell) in
                        self.configNewMeetCell((cell as! NewMeetInfoTableViewCell), indxPath: indexPath)
                    })
                case 0,2,6:
                    return 61
                default:
                    return 50
                }
            }
        }else{
            switch (indexPath as NSIndexPath).row {
                case 0:
                    return ScreenWidth*272/375 + 40
                default:
                    return 50
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -140 {
            self.dismiss(animated: true, completion: { 
                
            })
        }
    }
    
}

extension MeViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if UserInfo.isLoggedIn() {
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserInfo.isLoggedIn(){
            if (indexPath as NSIndexPath).section == 0 {
                if (indexPath as NSIndexPath).row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: mePhotoTableViewCell, for: indexPath) as! MePhotoTableViewCell
                    cell.avatarImageView.backgroundColor = UIColor.init(hexString: "e7e7e7")
                    
                   
                    if UserInfo.sharedInstance().avatar != nil && UserInfo.image(forName: "coverPhoto") != nil {
                        let imageArray = UserInfo.sharedInstance().avatar.components(separatedBy: "?")
                        
                        UIImage.image(withUrl: imageArray[0], newImage: CGSize.init(width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355),success:{ imageUrl in
                            cell.avatarImageView.sd_setImage(with: URL.init(string: imageArray[0] + imageUrl!), placeholderImage: UserInfo.image(forName: "coverPhoto"), options: .retryFailed, completed: { (image
                                , error, type, url) in
                                UserInfo.saveCacheImage(image, withName: "coverPhoto")
                            })
                        })
                        
                    }else{
                        //没有本地和没有网络上加载图片
                        let coverImage = UserInfo.image(forName: "coverPhoto")
                        let sizeImage = coverImage?.resizeImage(coverImage!, newSize: CGSize(width: 1065, height: 1065))
                        let image = UIImage.getImageFrom(sizeImage, subImageSize: CGSize(width: 1065, height: 708), subImageRect: CGRect(x: 0, y: 0, width: 1065, height: 708))
                        
                        cell.avatarImageView.image = image
                    }
                    
                    cell.avatarImageView.autoresizingMask = UIViewAutoresizing.flexibleTopMargin;
                    if UserExtenModel.shareInstance().completeness != nil {
                        cell.cofigLoginCell(UserInfo.sharedInstance().real_name, infoCom: UserInfo.sharedInstance().job_label,compass: UserExtenModel.shareInstance().completeness)
                        
                    }else{

//                        cell.cofigLoginCell(UserInfo.sharedInstance().real_name, infoCom: UserInfo.sharedInstance().job_label,compass: nil)
                        
                    }
                    frame = cell.avatarImageView.frame;
                    cell.block = { (tag) in
                        self.pushViewController(tag)
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.backgroundColor = UIColor.clear
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: photoDetailTableViewCell, for: indexPath) as! PhotoDetailTableViewCell
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
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.backgroundColor = UIColor.clear
                    return cell
                }
            }else{
                if (indexPath as NSIndexPath).row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: meInfoTableViewCell, for: indexPath) as! MeInfoTableViewCell
                    cell.configCell("me_about", infoString: "关于我的那些事", infoDetail: "", shadowColor: false,cornerRadiusType: .top)
                    cell.hidderLine()
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.setInfoButtonBackGroudColor(MeProfileCollectViewItemSelect)
                    return cell
                }else if (indexPath as NSIndexPath).row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsCell", for: indexPath) as! AboutUsCell
                    if UserExtenModel.shareInstance().experience != nil {
                        self.configAboutUsCell(cell, indexPath: indexPath)
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell
                }else if (indexPath as NSIndexPath).row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: meInfoTableViewCell, for: indexPath) as! MeInfoTableViewCell
                    cell.configCell("me_newmeet", infoString: "我的邀约", infoDetail: "", shadowColor: false,cornerRadiusType: .none)
                    if UserInviteModel.shareInstance().results != nil {
                        cell.infoDetailLabel.text =  (UserInviteModel.shareInstance().results[0]).is_active ? "":"未开启       "
                    }
                    cell.setInfoButtonBackGroudColor(lineLabelBackgroundColor)
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell
                }else if (indexPath as NSIndexPath).row == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: newMeetInfoTableViewCell, for: indexPath) as! NewMeetInfoTableViewCell
                    self.configNewMeetCell(cell, indxPath: indexPath)
                    cell.isHaveShadowColor(false)
                    cell.hidderLine()
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell
                }else if ((indexPath as NSIndexPath).row == 4){
                    let cell = tableView.dequeueReusableCell(withIdentifier: meInfoTableViewCell, for: indexPath) as! MeInfoTableViewCell
                    cell.configCell((userInfoModel.imageArray() as NSArray) .object(at: (indexPath as NSIndexPath).row - 3) as! String, infoString: (userInfoModel.titleArray() as NSArray).object(at: (indexPath as NSIndexPath).row - 3) as! String, infoDetail: "", shadowColor: false,cornerRadiusType: .none)
                    var string = ""
                    let auto_info = UserExtenModel.shareInstance().auth_info
                    var tempString = "职业、实名、电话、"
                    if auto_info != "" && auto_info != nil {
                        let autoArray = auto_info?.components(separatedBy: ",")
                        let dic = (ProfileKeyAndValue.shareInstance().appDic as NSDictionary).object(forKey: "auth_type") as! NSDictionary
                        if autoArray?.count == 3 {
                            string = ""
                        }else if (autoArray?.count == 2) {
                            for index in 0...(autoArray?.count)! - 1 {
                                var autoName = "、"
                                if dic.object(forKey: autoArray?[index]) != nil {
                                    autoName = dic.object(forKey: autoArray?[index]) as! String
                                }
                                if autoName.length > 2 {
                                    let firstChar = (autoName as NSString).substring(to: 2)
                                    tempString = tempString.replacingOccurrences(of: "\(firstChar)、", with: "")
                                }
                            }
                            tempString = tempString.replacingOccurrences(of: "、", with: "")
                            string = "尚未通过\(tempString)认证       "
                        }else if (autoArray?.count == 1){
                            let autoName = dic.object(forKey: autoArray?[0]) as! String
                            let firstChar = (autoName as NSString).substring(to: 2)
                            tempString = tempString.replacingOccurrences(of: "\(firstChar)、", with: "")
                            tempString = (tempString as NSString).substring(to: 5)
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
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell
                }else if (indexPath as NSIndexPath).row == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: meInfoTableViewCell, for: indexPath) as! MeInfoTableViewCell
                    if allOrderNumber == 0 {
                        cell.configCell("me_mymeet", infoString: "我的约见", infoDetail: "", shadowColor: false,cornerRadiusType: .none)
                    }else{
                        cell.configCell("me_mymeet", infoString: "我的约见", infoDetail: "共 \(allOrderNumber) 个进行中     ", shadowColor: false,cornerRadiusType: .none)
                    }
                    cell.showLine()
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.setInfoButtonBackGroudColor(MeProfileCollectViewItemSelect)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: meInfoTableViewCell, for: indexPath) as! MeInfoTableViewCell
                    cell.configCell("me_wantmeet", infoString: "想见的人", infoDetail: "", shadowColor: true,cornerRadiusType: .bottom)
                    cell.showLine()
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.setInfoButtonBackGroudColor(MeProfileCollectViewItemSelect)
                    return cell
                }
            }
        }else{
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: mePhotoTableViewCell, for: indexPath) as! MePhotoTableViewCell
                cell.configlogoutView()
                cell.logoutBtn.addTarget(self, action: (#selector(MeViewController.presentViewLoginViewController)), for: UIControlEvents.touchUpInside)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: meInfoTableViewCell, for: indexPath) as! MeInfoTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.configCell((userInfoModel.imageArray() as NSArray).object(at: (indexPath as NSIndexPath).row - 1) as! String, infoString: (userInfoModel.titleArray() as NSArray).object(at: (indexPath as NSIndexPath).row - 1) as! String, infoDetail: "", shadowColor: false,cornerRadiusType: .none)
                return cell
            }
        }
    }
}

