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

func meetHeight(_ meetString:String, instrestArray:NSArray) -> CGFloat
{
    var instresTitleString = "  ";
    for string in instrestArray {
        instresTitleString = instresTitleString + (string as! String)
        instresTitleString = instresTitleString + "    "
    }
    
    let instrestHeight = instresTitleString.height(with: MeetDetailInterFont, constrainedToWidth: UIScreen.main.bounds.size.width - 40) + 10
    let titleHeight = meetString.height(with: LoginCodeLabelFont, constrainedToWidth: UIScreen.main.bounds.size.width - 38)
    return titleHeight + instrestHeight + 60
}

enum PersonType {
    case man
    case women
    case other
}


typealias ReloadHomeListLike = (_ isLike:Bool, _ number:NSInteger) -> Void

//typealias ReloadHomeListLike = (_ isLike:NSInteger, _ number:String) -> Void


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
    var personType = PersonType.women
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
    
    var reloadHomeListLike:ReloadHomeListLike! = nil
    
    var photoImageArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        super.viewDidLoad()
        self.getHomeDetailModel()
        self.talKingDataPageName = "Home-Detail"
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavigationBar()

        self.navigationController?.navigationBar.isTranslucent = false;
    }
    
    func setUpTableView() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: photoTableViewCell)
        self.tableView.register(CompayTableViewCell.self, forCellReuseIdentifier: compayTableViewCell)
        self.tableView.register(MeetInfoTableViewCell.self, forCellReuseIdentifier: meetInfoTableViewCell)
        self.tableView.register(AboutUsInfoTableViewCell.self, forCellReuseIdentifier: aboutUsInfoTableViewCell)
        self.tableView.register(SectionInfoTableViewCell.self, forCellReuseIdentifier: sectionInfoTableViewCell)
        self.tableView.register(NewMeetInfoTableViewCell.self, forCellReuseIdentifier: newMeetInfoTableViewCell)
        self.tableView.register(WantMeetTableViewCell.self, forCellReuseIdentifier: wantMeetTableViewCell)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        self.tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        self.view.addSubview(self.tableView)
        
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            if self.bottomView != nil {
                make.bottom.equalTo(self.bottomView.snp.top).offset(0)
            }else{
                make.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    
    func setUpBottomView(){
        self.bottomView = UIView(frame: CGRect(x: 0,y: ScreenHeight - 49, width: ScreenWidth, height: 49))
        self.bottomView.backgroundColor = UIColor.init(hexString: HomeViewWomenColor)
        self.setPersonType(self.personType)
        let singerTap = UITapGestureRecognizer(target: self, action: #selector(MeetDetailViewController.meetImmediately))
        singerTap.numberOfTouchesRequired = 1
        singerTap.numberOfTapsRequired = 1
        self.bottomView.addGestureRecognizer(singerTap)
        let label = UILabel(frame: self.bottomView.bounds)
        label.text = "立即约见"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.init(hexString: "FFFFFF")
        label.font = MeetDetailImmitdtFont
        self.bottomView.addSubview(label)
        self.view.addSubview(self.bottomView)
        
        self.bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }
    
    func meetImmediately(){
        if UserInfo.isLoggedIn() {
            if UserInfo.sharedInstance().uid == self.user_id {
                MainThreadAlertShow("您不能约见自己哦", view: self.view)
                return
            }
        }
        let apply = ApplyMeetView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: ScreenHeight))
        apply.host = self.user_id
        if self.otherUserModel.engagement!.theme != nil {
            var appointment_theme = ""
            let themes = self.otherUserModel.engagement!.theme!
            let themesArray = Theme.mj_objectArray(withKeyValuesArray: themes)
            for theme in themesArray! {
                appointment_theme.append(((theme as! Theme).theme)!)
                appointment_theme.append(",")
            }
            apply.appointment_theme = appointment_theme

        }
        KeyWindown?.addSubview(apply)
//        let applyMeetVc = ApplyMeetViewController()
//        applyMeetVc.allItems =  self.inviteArray.mutableCopy() as! NSMutableArray
//        applyMeetVc.host = self.user_id
//        applyMeetVc.realName = otherUserModel.real_name
//        applyMeetVc.jobLabel = otherUserModel.job_label
//        applyMeetVc.avater = otherUserModel.avatar
//        self.navigationController?.pushViewController(applyMeetVc, animated: true)
    }
    
    func setUpNavigationBar(){
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
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
        
        let moreBtn = UIBarButtonItem(image: UIImage.init(named: "navigationbar_more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(MeetDetailViewController.rigthItemClick(_:)))
        
        
        likeButton = UIButton(type: UIButtonType.custom)
        likeButton.addTarget(self, action: #selector(MeetDetailViewController.likeButtonPress(_:)), for: .touchUpInside)
        likeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 40)
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        likeButton.setTitleColor(UIColor.black, for: UIControlState())
        let likeItem = UIBarButtonItem(customView: likeButton)
        self.navigationItem.rightBarButtonItems = [moreBtn,likeItem]
    }
    
    func setPersonType(_ personType:PersonType){
        if personType == .man {
            personTypeString = "他"
        }else{
            personTypeString = "她"
        }
    }
    
    func likeButtonPress(_ sender:UIButton) {
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
    
    func leftItemClick(_ sender:UIBarButtonItem){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func rigthItemClick(_ sender:UIBarButtonItem){
        let alertControl = UIAlertController(title: "选择您要进行的操作", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (cancel) in
            
        }
        let reportAction = UIAlertAction(title: "投诉", style: .default) { (reportAction) in
            self.actionSheetSelect = 1
            self.reportAction()
        }
        
        let blackListAction = UIAlertAction(title: "加入黑名单", style: .destructive) { (blackList) in
            self.actionSheetSelect = 2
            self.blackListAction()
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(reportAction)
        alertControl.addAction(blackListAction)
        self.present(alertControl, animated: true) { 
            
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
            let aletControl = UIAlertController.init(title: nil, message: "加入黑名单后，对方将不能再申请约见您；在 “设置-黑名单” 中可撤销此操作。", preferredStyle: UIAlertControllerStyle.alert)
            let cancleAction = UIAlertAction.init(title: "暂不", style: UIAlertActionStyle.cancel, handler: { (canCel) in
                (UserInviteModel.shareInstance().results[0]).is_active = true
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: UITableViewRowAnimation.automatic)
            })
            let doneAction = UIAlertAction.init(title: "拉黑", style: UIAlertActionStyle.default, handler: { (canCel) in
                if self.user_id != UserInfo.sharedInstance().uid {
                    self.userInfoViewModel.makeBlackList(self.user_id, succes: { (dic) in
                        MainThreadAlertShow("拉入黑名单成功", view: self.view)
                        }, fail: { (dic) in
                            MainThreadAlertShow("拉入黑名单失败", view: self.view)
                    })
                }else{
                    MainThreadAlertShow("您不能拉黑自己哦", view: self.view)
                }
                
            })
            aletControl.addAction(cancleAction)
            aletControl.addAction(doneAction)
            self.present(aletControl, animated: true) {
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
        
        self.present(controller, animated: true) { 
            
        }
        
    }
    
    func changeLikeButton(_ isLike:Bool) {
        self.otherUserModel.cur_user_liked = isLike
        let image = self.otherUserModel.cur_user_liked ? UIImage.init(named: "detail_liked_normal"):UIImage.init(named: "detail_like_normal")
        var number = ""
        if self.otherUserModel.liked_count == 0 {
            number = ""
        }else{
           number = " \(self.otherUserModel.liked_count)"

        }
        likeButton.tag = isLike ? 1:0
        likeButton.setTitle(number, for: UIControlState())
        likeButton.setImage(image, for: UIControlState())
        var frame = likeButton.frame
        frame.size.width = number.stringWidth(number, font: UIFont.systemFont(ofSize: 14.0), height: 20) + 20
        likeButton.frame = frame
        
        let imageHight = self.otherUserModel.cur_user_liked ? UIImage.init(named: "detail_liked_pressed") : UIImage.init(named: "detail_like_pressed")
        likeButton.setImage(imageHight, for: .highlighted)
        
        if self.reloadHomeListLike != nil {
            self.reloadHomeListLike(isLike,self.otherUserModel.liked_count)
        }
    }
    
    func getHomeDetailModel(){
        viewModel.getOtherUserInfo(user_id, successBlock: { (dic) in
            self.otherUserModel = HomeDetailModel.mj_object(withKeyValues: dic)
            let coverPhoto = self.otherUserModel.cover_photo?.photo.components(separatedBy: "?")
            self.imageUrls.add(coverPhoto![0])
            if self.otherUserModel.head_photo_list != nil {
                var currentImage:NSInteger = 1
                let photoModels = Head_Photo_List.mj_objectArray(withKeyValuesArray: self.otherUserModel.head_photo_list!)
                for model in photoModels! {
                    let photoModel = model as! Head_Photo_List
                    self.imageUrls.add(photoModel.photo)
                    currentImage = currentImage + 1
                }
                self.getPlachImage()
            }

            if !self.isOrderViewPush {
                self.setUpBottomView()
                if self.otherUserModel.gender == 1 {
                    self.personType = .man
                    self.setPersonType(self.personType)
                }
            }
            self.personalArray = self.personalLabelArray as! [String]
            self.images.addObjects(from: self.imageArray.copy() as! [AnyObject])
            self.setUpTableView()
            self.changeLikeButton(self.otherUserModel.cur_user_liked)
            }, fail: { (dic) in
                self.getHomeDetailModel()
        }) { (msg) in
            
        }
    }
    
    lazy var imageArray:NSArray = {
        let tempArray = NSMutableArray()
        
        if self.otherUserModel.user_info!.detail != nil {
            let details = self.otherUserModel.user_info!.detail
            let dtailArray = Detail.mj_objectArray(withKeyValuesArray: details)
            for detailModel in dtailArray! {
                
                let photos = (detailModel as! Detail).photo
                let photosModel = Photos.mj_objectArray(withKeyValuesArray: photos)
                for model in photosModel! {
                    if (model as AnyObject).photo != "" {
                        let imageArray = (model as AnyObject).photo!.components(separatedBy: "?")
                        tempArray.add(imageArray[0] + UIImage.image(withUrl: imageArray[0], newImage: CGSize.init(width: 59, height: 59)))
                    }
                }
            }
        }
        return tempArray
    }()
    
    lazy var personalLabelArray:NSArray = {
        let tempArray = NSMutableArray()
        tempArray.addObjects(from: self.otherUserModel.personal_label.components(separatedBy: ","))
        return tempArray
    }()
    
    lazy var dataArray:NSArray = {
        var tempArray = NSMutableArray()
        let descriptions = self.otherUserModel.user_info!.highlight
        let array = descriptions.components(separatedBy: "\n")
        tempArray.addObjects(from: array)
        return tempArray
    }()
    
    lazy var inviteArray:NSArray = {
        let tempArray = NSMutableArray()
        let dic = (ProfileKeyAndValue.shareInstance().appDic as NSDictionary).object(forKey: "invitation") as! NSDictionary
        if self.otherUserModel.engagement!.theme != nil {
            let themes = self.otherUserModel.engagement!.theme!
            let themesArray = Theme.mj_objectArray(withKeyValuesArray: themes)
            for theme in themesArray! {
                tempArray.add(dic.object(forKey: (theme as! Theme).theme!)!)
            }
        }
        return tempArray
    }()
    
    lazy var personalArray:[String] = {
        var tempArray:[String] = []
        tempArray = (self.otherUserModel.personal_label.components(separatedBy: ","))
        return tempArray
    }()
    
    lazy var engagement:Engagement = {
        let engagement = Engagement.mj_object(withKeyValues: self.otherUserModel.engagement)
        return engagement!
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aboutUsHeight(_ stringArray:NSArray) -> CGFloat {
        var height:CGFloat = 10.0
        for item in stringArray {
            let string = item as! String
            if string != "" {
                height = height + (item as AnyObject).height(with: LoginCodeLabelFont, constrainedToWidth: UIScreen.main.bounds.size.width - 38) + 10
            }
        }
        
        return height
    }
    
    func meetInfoCellHeight(_ model:HomeDetailModel) -> CGFloat{
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

    func configCell(_ cell:MeetInfoTableViewCell, indxPath:IndexPath)
    {
        if self.otherUserModel.distance == "" {
            cell.configCell(self.otherUserModel.real_name, position: self.otherUserModel.job_label, meetNumber: "\(self.otherUserModel.location as String)", interestCollect: self.personalArray as [AnyObject],autotnInfo: self.otherUserModel.user_info?.auth_info)
        }else{
            cell.configCell(self.otherUserModel.real_name, position: self.otherUserModel.job_label, meetNumber: "\(self.otherUserModel.location as String)    和你相隔 \(self.otherUserModel.distance as String)", interestCollect: self.personalArray as [AnyObject], autotnInfo: self.otherUserModel.user_info?.auth_info)
        }
    }
    
    func configNewMeetCell(_ cell:NewMeetInfoTableViewCell, indxPath:IndexPath)
    {
        cell.configCell(self.otherUserModel.engagement?.introduction_other, array: self.inviteArray as [AnyObject], andStyle: .ItemWhiteColorAndBlackBoard)
    }
    
    func configAboutCell(_ cell:AboutUsInfoTableViewCell, indxPath:IndexPath)
    {
        cell.configCell(((self.otherUserModel.user_info?.experience)! as String), info: self.otherUserModel.user_info?.highlight, imageArray: self.images as [AnyObject], withUrl: self.otherUserModel.web_url)
    }
    
    func getPlachImage() {
        let manage = SDWebImageManager()
        let plachImageSize = CGSize(width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355)
        let plachImageWidth = Int(plachImageSize.width)
        let plachImageHeight = Int(plachImageSize.height)
        let image = UIImage.init(color: UIColor.clear, size: plachImageSize)
        for url in self.imageUrls {
            plachImages.add(image)
            let urlStr = URL.init(string: ((url as! String).appending("?imageView2/1/w/\(plachImageWidth)/h/\(plachImageHeight)")))
            manage.downloadImage(with: urlStr, options: .retryFailed, progress: { (start, end) in
                
                }, completed: { (image, error, cache, finist, url) in
                    if image != nil {
                        let urlString = url?.absoluteString.components(separatedBy: "?")
                        for urlIndex in  0...self.imageUrls.count - 1 {
                            if urlString?[0] == self.imageUrls[urlIndex] as? String {
                                self.plachImages.replaceObject(at: urlIndex, with: image)
                            }
                        }
                    }
            })
        }
        
    }
    
    func headerListImages() -> NSArray {
        if photoImageArray.count != 0 {
            return photoImageArray
        }else{
            let imageArray = NSMutableArray()
            if self.otherUserModel.cover_photo != nil {
                if self.otherUserModel.cover_photo!.photo != "" {
                    let imageStrArray = self.otherUserModel.cover_photo!.photo.components(separatedBy: "?")
                    
                    //                if ((AppGlobalData.sharedInstance().homeDetailDic?[imageStrArray[0]]) != nil) {
                    //                    imageArray.add(imageStrArray[0] + (AppGlobalData.sharedInstance().homeDetailDic?[imageStrArray[0]] as! String))
                    //                }else {
                    //                    let imageStr = UIImage.image(withUrl: imageStrArray[0], newImage: CGSize.init(width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355))
                    //
                    //                    AppGlobalData.sharedInstance().homeDetailDic.setValue(imageStr, forKey: imageStrArray[0])
                    //                    imageArray.add(imageStrArray[0] + imageStr!)
                    //                }
                    imageArray.add(imageStrArray[0] + UIImage.image(withUrl: imageStrArray[0], newImage: CGSize.init(width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355)))
                }
            }
            let models = Head_Photo_List.mj_objectArray(withKeyValuesArray: self.otherUserModel.head_photo_list!)
            for model in models! {
                let photoModel = model as! Head_Photo_List
                let imageStr = photoModel.photo + UIImage.image(withUrl: photoModel.photo, newImage: CGSize.init(width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355))
                imageArray.add(imageStr)
            }
            photoImageArray = imageArray.mutableCopy() as! NSMutableArray
            return imageArray
        }
    }
    
    func presentImageBrowse(_ index:NSInteger, sourceView:UIView) {

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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.otherUserModel.user_info?.highlight == "" {
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return (ScreenWidth - 20)*236/355
                case 1:
                    return tableView.fd_heightForCell(withIdentifier: meetInfoTableViewCell, configuration: { (cell) in
                        self.configCell(cell as! MeetInfoTableViewCell, indxPath: indexPath)
                    })
                default:
                    return 50
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    return tableView.fd_heightForCell(withIdentifier: newMeetInfoTableViewCell, cacheByKey: self.user_id as NSCopying!, configuration: { (cell) in
                        self.configNewMeetCell(cell as! NewMeetInfoTableViewCell, indxPath: indexPath)
                        
                    })
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    return 123
                }
            }
        }else{
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return (UIScreen.main.bounds.size.width - 20)*236/355
                case 1:
                    return tableView.fd_heightForCell(withIdentifier: meetInfoTableViewCell, configuration: { (cell) in
                        self.configCell(cell as! MeetInfoTableViewCell, indxPath: indexPath)
                    })
                default:
                    return 50
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    return tableView.fd_heightForCell(withIdentifier: aboutUsInfoTableViewCell, configuration: { (cell) in
                        self.configAboutCell(cell as! AboutUsInfoTableViewCell, indxPath: indexPath)
                    })
                }
            case 2:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    return tableView.fd_heightForCell(withIdentifier: newMeetInfoTableViewCell, cacheByKey: self.user_id as NSCopying!, configuration: { (cell) in
                        self.configNewMeetCell(cell as! NewMeetInfoTableViewCell, indxPath: indexPath)
                    })
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    return 123
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.otherUserModel.user_info?.highlight == ""{
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return (UIScreen.main.bounds.size.width - 20)*236/355
                case 1:
                    return 195
                default:
                    return 49
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    
                    return 223
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    return 123
                }
            }
        }else {
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return (UIScreen.main.bounds.size.width - 20)*236/355
                case 1:
                    return 195
                default:
                    return 49
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    return 210;
                }
            case 2:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    
                    return 223
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return 49
                default:
                    return 123
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 2 {
            let otherInfo =  Stroyboard("Main", viewControllerId: "OtherViewController") as! OtherViewController
            otherInfo.uid = user_id
            self.navigationController?.pushViewController(otherInfo, animated: true)
        }else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1 && self.otherUserModel.user_info!.highlight != ""  && self.otherUserModel.web_url != ""{
            let meetWebView = AboutDetailViewController()
            meetWebView.url = "\(RequestBaseUrl)\(self.otherUserModel.web_url)"
            self.navigationController?.pushViewController(meetWebView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
}

extension MeetDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.otherUserModel.user_info!.highlight == ""{
            return 2
        }else{
            return 3

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.otherUserModel.user_info?.highlight == "" {
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: photoTableViewCell, for: indexPath) as! PhotoTableViewCell
                    cell.configCell(self.headerListImages() as [AnyObject], gender: self.otherUserModel.gender , age: self.otherUserModel.age)
                    cell.clickBlock = { index,scourceView in
                        self.presentImageBrowse(index, sourceView: scourceView!)
                    }
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: meetInfoTableViewCell, for: indexPath) as! MeetInfoTableViewCell
                    self.configCell(cell, indxPath: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.isUserInteractionEnabled = false
                    return cell
                default:
                    let identifier = "MoreTableViewCell"
                    var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                    if cell == nil{
                        cell = AllInfoTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
                    }
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell!
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: sectionInfoTableViewCell, for: indexPath) as! SectionInfoTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.configCell("meetdetail_newmeet", titleString: "\(personTypeString)的邀约")
                    cell.isUserInteractionEnabled = false
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: newMeetInfoTableViewCell, for: indexPath) as! NewMeetInfoTableViewCell
                    self.configNewMeetCell(cell, indxPath: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.isUserInteractionEnabled = false
                    cell.isHaveShadowColor(true)
                    return cell
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: sectionInfoTableViewCell, for: indexPath) as! SectionInfoTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.configCell("meetdetail_wantmeet", titleString: "更多想见的人")
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: wantMeetTableViewCell, for: indexPath) as! WantMeetTableViewCell
                    cell.textLabel?.text = "更多想见的人"
                    return cell
                }
            }
        }else{
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: photoTableViewCell, for: indexPath) as! PhotoTableViewCell
                    cell.configCell(self.headerListImages() as [AnyObject], gender: self.otherUserModel.gender , age: self.otherUserModel.age)
                    cell.clickBlock = { index,scourceView in
                        self.presentImageBrowse(index, sourceView: scourceView!)
                    }
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: meetInfoTableViewCell, for: indexPath) as! MeetInfoTableViewCell
                    self.configCell(cell, indxPath: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.isUserInteractionEnabled = false
                    return cell
                default:
                    let identifier = "MoreTableViewCell"
                    var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                    if cell == nil{
                        cell = AllInfoTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
                    }
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell!
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: sectionInfoTableViewCell, for: indexPath) as! SectionInfoTableViewCell
                    cell.configCell("meetdetail_aboutus", titleString: "关于\(personTypeString)")
                    cell.isUserInteractionEnabled = false
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: aboutUsInfoTableViewCell, for: indexPath) as! AboutUsInfoTableViewCell
                    self.configAboutCell(cell, indxPath: indexPath)
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell
                }
                
            case 2:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: sectionInfoTableViewCell, for: indexPath) as! SectionInfoTableViewCell
                    cell.configCell("meetdetail_newmeet", titleString: "\(personTypeString)的邀约")
                    cell.isUserInteractionEnabled = false
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: newMeetInfoTableViewCell, for: indexPath) as! NewMeetInfoTableViewCell
                    self.configNewMeetCell(cell, indxPath: indexPath)
                    cell.isHaveShadowColor(true)
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.isUserInteractionEnabled = false
                    return cell
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: sectionInfoTableViewCell, for: indexPath) as! SectionInfoTableViewCell
                    cell.configCell("meetdetail_wantmeet", titleString: "更多想见的人")
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: wantMeetTableViewCell, for: indexPath) as! WantMeetTableViewCell
                    cell.textLabel?.text = "更多想见的人"
                    return cell
                }
            }
        }
        
        
    }
}

extension MeetDetailViewController : UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:break
        case 1:
            let aletControl = UIAlertController.init(title: nil, message: "加入黑名单后，对方将不能再申请约见您；在 “设置-黑名单” 中可撤销此操作。", preferredStyle: UIAlertControllerStyle.alert)
            let cancleAction = UIAlertAction.init(title: "暂不", style: UIAlertActionStyle.cancel, handler: { (canCel) in
                (UserInviteModel.shareInstance().results[0]).is_active = true
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: UITableViewRowAnimation.automatic)
            })
            let doneAction = UIAlertAction.init(title: "拉黑", style: UIAlertActionStyle.default, handler: { (canCel) in
                self.userInfoViewModel.makeBlackList(self.user_id, succes: { (dic) in
                    MainThreadAlertShow("拉入黑名单成功", view: self.view)
                    }, fail: { (dic) in
                        MainThreadAlertShow("拉入黑名单失败", view: self.view)
                })
            })
            aletControl.addAction(cancleAction)
            aletControl.addAction(doneAction)
            self.present(aletControl, animated: true) {
                
            }
        default:
            let reportVC = ReportViewController()
            reportVC.uid = user_id
            self.navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    func willPresent(_ actionSheet: UIActionSheet) {
        for subView in actionSheet.subviews {
            if subView.isKind(of: UIButton.self) {
                let button = subView as! UIButton
                if button.tag == 1 {
                    button.setTitleColor(UIColor.red, for: UIControlState())
                }
            }
        }
    }
}

extension MeetDetailViewController : SDPhotoBrowserDelegate {
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        return URL.init(string: self.imageUrls[index] as! String)
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return plachImages[index] as! UIImage
    }
}

