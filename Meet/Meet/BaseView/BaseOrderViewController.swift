//
//  BaseOrderViewController.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

let PhotoWith:CGFloat = 34
let PhotoHeight:CGFloat = 34

enum OrderType {
    case cancel
    case reject
    case done
    case doing
}

typealias ReloadCollectionClouser = (_ status:String) -> Void

class BaseOrderViewController: UIViewController {

    var titleView:UIView!
    var lineLabel:UILabel!
    
    var leftButton:UIButton!
    var rightButton:UIButton!
    var bottomBtn:UIButton!
    
    var tableView:UITableView!
    var orderModel:OrderModel!
    
    var myClouse:ReloadCollectionClouser!
    
    var navigationBarTitleView: UIView!
    
    var orderType:OrderType = .done
    
    let viewModel = OrderViewModel()
    var uid:String = ""
    let tableViewArray = ["OrderFlowTableViewCell","AppointMentTableViewCell","MeetOrderInfoTableViewCell","OrderCancelTableViewCell"]
    
    var weChatPayreq:PayReq = PayReq()
    var aliPayurl:String!
    var payView:PayView!
    
    let cancelView = OrderCancelRejectViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeOrderType()
        self.setUpBottomBtn()
        self.setUpNavigationTitleView()
        self.setUpTableView()
        self.fd_prefersNavigationBarHidden = true
        self.changeBottomBtnTitle()
        NotificationCenter.default.addObserver(self, selector: #selector(WaitPayViewController.changePayStatues(_:)), name: NSNotification.Name(rawValue: WeiXinPayStatues), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WaitPayViewController.changePayStatues(_:)), name: NSNotification.Name(rawValue: AliPayStatues), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func setUpNavigationTitleView() {
        navigationBarTitleView = UIView(frame:CGRect(x: 0,y: 0,width: ScreenWidth, height: 84))
        navigationBarTitleView.backgroundColor = UIColor.white
        self.setNavigationItem()
        lineLabel = UILabel(frame: CGRect(x: 0,y: 83.5,width: ScreenWidth,height: 0.5))
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        navigationBarTitleView.addSubview(lineLabel)
        self.setUpTitleView()
        self.view.addSubview(navigationBarTitleView)
        
    }
    
    func setNavigationItem(){
        leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(x: 5, y: 20, width: 40, height: 40)
        leftButton.setImage(UIImage.init(named: "navigationbar_back")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
        leftButton.addTarget(self, action: #selector(BaseOrderViewController.leftBarPress(_:)), for: .touchUpInside)
        navigationBarTitleView.addSubview(leftButton)
        
        rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(x: ScreenWidth - 45, y: 20, width: 40, height: 40)
        rightButton.setImage(UIImage.init(named: "navigation_info")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
        rightButton.addTarget(self, action: #selector(BaseOrderViewController.rightBarPress(_:)), for: .touchUpInside)
        navigationBarTitleView.addSubview(rightButton)

    }
    
    func setUpdataTableViewConstraints(){
        self.tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }
    
    func setUpBottomBtn() {
        bottomBtn = UIButton()
        bottomBtn.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeViewDetailMeetButtonBack), size: CGSize(width: ScreenWidth, height: 49)), for: UIControlState())
        bottomBtn.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeViewDetailMeetButtonHightBack), size: CGSize(width: ScreenWidth, height: 49)), for: .highlighted)
        bottomBtn.addTarget(self, action: #selector(BaseOrderViewController.bottomPress(_:)), for: .touchUpInside)
        bottomBtn.titleLabel?.font = MeetDetailImmitdtFont
        self.view.addSubview(bottomBtn)
        
        bottomBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
            make.height.equalTo(49)
        }
    }
    
    func cofirmBottomClick() {
        let alertControl = UIAlertController(title: "确定要接受\((orderModel.order_user_info?.real_name)!)的约见吗？", message: "接受约见及对方付款后即可开始沟通见面\n拒绝约见后该预约将自动关闭", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "稍后决定", style: .cancel) { (cancel) in
            
        }
        
        let accpetAction = UIAlertAction(title: "接受约见", style: .default) { (blackList) in
            self.viewModel.orderStatusOperation(self.orderModel.order_id, withHos: UserInfo.sharedInstance().uid, successBlock: { (dic) in
                if self.myClouse != nil {
                    self.myClouse((self.orderModel.status?.order_status)!)
                }
                self.reloadData()
                NotificationCenter.default.post(name: Notification.Name(rawValue: ReloadOrderCollectionView), object: self.orderModel.status?.status_code)
                }, fail: { (dic) in
                    MainThreadAlertShow("确认失败", view: self.view)
            })
        }
        let rejectAction = UIAlertAction(title: "拒绝约见", style: .destructive) { (reportAction) in
            let cancelView = OrderCancelRejectViewController()
            cancelView.title = "拒绝原因说明"
            cancelView.changeOrderStatus = "3"
            cancelView.resonType = .reject
            cancelView.reloadOrderStatusChang = { _ in
                self.reloadData()
            }
            cancelView.orderModel = self.orderModel
            self.navigationController?.pushViewController(cancelView, animated: true)
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(accpetAction)
        alertControl.addAction(rejectAction)
        self.present(alertControl, animated: true) {
            
        }
    }
    
    func payBottomClick() {
        var theme = ""
        for index in 0...orderModel.appointment_theme.count - 1 {
            theme = theme + ((orderModel.appointment_theme as NSArray).object(at: index) as! String)
            if index !=  orderModel.appointment_theme.count - 1 {
                theme = theme + "、"
            }
        }
        payView = PayView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: ScreenHeight))
        payView.setUpData((orderModel.order_user_info?.real_name)!, themes: theme as String as NSString, much: orderModel.fee)
        payView.paySelectItem = { payType in
            if payType == "weiChat" {
                WXApi.send(self.weChatPayreq)
            }else{
                AlipaySDK.defaultService().payOrder(self.aliPayurl, fromScheme: "MeetAlipay") { (resultDic) in
                }
            }
        }
        KeyWindown?.addSubview(payView)
    }
    
    func meetBottomClick() {
        let alertControl = UIAlertController(title: "确定双方已见面吗", message: "确认与 \((orderModel.order_user_info?.real_name)!) 见面后\n对方会收到见面完成的确认短信", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "暂不", style: .cancel) { (cancel) in
            
        }
        
        let accpetAction = UIAlertAction(title: "确认见面", style: .default) { (blackList) in
            if self.orderModel.status?.status_type == "apply_order" {
                self.changeShtatues("11")
            }else{
                self.changeShtatues("11")
            }
            
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(accpetAction)
        self.present(alertControl, animated: true) {
            
        }
    }
    
    func loadPayInfo(){
        viewModel.payOrder(orderModel.order_id, successBlock: { (dic) in
            let payDic = dic! as [AnyHashable:Any] as NSDictionary
            self.aliPayurl = payDic.object(forKey: "alipay") as! String
            let weChatDic = payDic["wxpay"] as! NSDictionary;
            self.weChatPayreq.nonceStr = weChatDic.object(forKey: "noncestr") as! String
            self.weChatPayreq.package = weChatDic.object(forKey: "package") as! String
            self.weChatPayreq.partnerId = weChatDic.object(forKey: "partnerid") as! String
            self.weChatPayreq.prepayId = weChatDic.object(forKey: "prepayid") as! String
            self.weChatPayreq.sign = weChatDic.object(forKey: "sign") as! String
            let timeString = (weChatDic.object(forKey: "timestamp") as! String)
            let time:UInt32 = UInt32(timeString)!
            self.weChatPayreq.timeStamp = time
            }, fail: { (dic) in
                
        })
    }
    
    
    func changePayStatues(_ notification:Notification) {
        let payCompleteVC = Stroyboard("Order", viewControllerId: "PayCompleteViewController") as! PayCompleteViewController
        payCompleteVC.payCompleteClouse = { _ in
            self.reloadData()
        }
        payCompleteVC.orderModel = self.orderModel
        NotificationCenter.default.post(name: Notification.Name(rawValue: ReloadOrderCollectionView), object: (self.orderModel.status?.order_status)!)
        self.navigationController?.pushViewController(payCompleteVC, animated: true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WeiXinPayStatues), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AliPayStatues), object: nil)
    }
    
    func bottomPress(_ sender:UIButton) {
        if orderModel.status?.status_code == "1" {
            self.cofirmBottomClick()
        }else if orderModel.status?.status_code == "4" {
            self.payBottomClick()
        }else if orderModel.status?.status_code == "6" {
            self.meetBottomClick()
        }
    }
    
    func leftBarPress(_ sender:UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func reloadData() {
        viewModel.orderDetail(orderModel.order_id, successBlock: { (dic) in
            self.orderModel = OrderModel.mj_object(withKeyValues: dic?["order"])
            self.changeOrderType()
            self.tableView.reloadData()
            self.changeBottomBtnTitle()
        }) { (dic) in
            
        }
    }
    
    func changeOrderType() {
        let code = self.orderModel.status?.status_code
        if code == "1" || code == "4" || code == "6" {
            self.orderType = .doing
        }else if code == "11" {
            self.orderType == .done
        }else{
            self.orderType = .cancel
        }
    }
    
    func changeBottomBtnTitle(){
        if orderModel.status?.status_code == "1" {
            if self.orderModel.status?.status_type == "receive_order" {
                bottomBtn.setTitle("接受/拒绝", for: UIControlState())
            }else{
                self.setUpdataTableViewConstraints()
                bottomBtn.isHidden = true
            }
        }else if orderModel.status?.status_code == "4" {
            if self.orderModel.status?.status_type == "receive_order" {
                self.setUpdataTableViewConstraints()
                bottomBtn.isHidden = true
            }else{
                bottomBtn.setTitle("立即支付 ￥\(orderModel.fee)", for: UIControlState())
            }
            self.loadPayInfo()
        }else if orderModel.status?.status_code == "6" {
            bottomBtn.setTitle("确认双方已约见", for: UIControlState())
        }else{
            self.setUpdataTableViewConstraints()
            bottomBtn.isHidden = true
        }
        self.updateViewConstraints()
    }
    
    func rightBarPress(_ sender:UIBarButtonItem) {
        self.pushMeetDetaiVC()
    }
    
    func pushMeetDetaiVC() {
        let meetDetailVC = MeetDetailViewController()
        meetDetailVC.user_id = orderModel.order_user_info!.uid
        meetDetailVC.isOrderViewPush = true
        self.navigationController?.pushViewController(meetDetailVC, animated: true)
    }
    
    func setUpTitleView(){
        titleView = UIView(frame: CGRect(x: 40,y: 22,width: ScreenWidth - 80,height: 63))
        titleView.isUserInteractionEnabled = true
        let phototView = UIImageView(frame: CGRect(x: (titleView.frame.size.width - PhotoWith)/2, y: 2, width: PhotoWith, height: PhotoHeight))
        phototView.layer.cornerRadius = PhotoWith/2
        phototView.layer.masksToBounds = true
        let imageArray = orderModel.order_user_info?.avatar.components(separatedBy: "?")
        phototView.sd_setImage(with: URL.init(string: imageArray![0] + NavigaitonAvatarImageSize), placeholderImage: UIImage.init(color: UIColor.init(hexString: PlaceholderImageColor), size: CGSize(width: PhotoWith, height: PhotoHeight)), options: .retryFailed)
        titleView.addSubview(phototView)
        
        let positionLabel = UILabel(frame: CGRect(x: 0, y: phototView.frame.maxY + 2, width: titleView.frame.size.width, height: 16))
        let positionString = "\(orderModel.order_user_info!.real_name ) \(orderModel.order_user_info!.job_label)"
        let attributedString = NSMutableAttributedString(string: positionString)
        attributedString.addAttributes([NSFontAttributeName:AppointRealNameLabelFont!], range: NSRange.init(location: 0, length: orderModel.order_user_info!.real_name.length))
        attributedString.addAttributes([NSFontAttributeName:AppointPositionLabelFont!], range: NSRange.init(location: orderModel.order_user_info!.real_name.length + 1, length: orderModel.order_user_info!.job_label.length))
        attributedString.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: HomeDetailViewNameColor)], range: NSRange.init(location: 0, length: positionString.length))
        positionLabel.attributedText = attributedString
        positionLabel.textAlignment = .center
        titleView.addSubview(positionLabel)
        navigationBarTitleView.addSubview(titleView)
        
        let tapGetues =  UITapGestureRecognizer(target: self, action: #selector(BaseOrderViewController.pushUserDetail(_:)))
        tapGetues.numberOfTapsRequired = 1
        tapGetues.numberOfTouchesRequired = 1
        titleView.addGestureRecognizer(tapGetues)

    }
    
    func pushUserDetail(_ tap:UITapGestureRecognizer) {
        self.pushMeetDetaiVC()
    }
    
    func setUpTableView() {
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(OrderFlowTableViewCell.self, forCellReuseIdentifier: "OrderFlowTableViewCell")
        self.tableView.register(CancelInfoTableViewCell.self, forCellReuseIdentifier: "CancelInfoTableViewCell")
        self.tableView.register(UINib.init(nibName: "OrderProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderProfileTableViewCell")
        self.tableView.register(UINib.init(nibName: "AppointMentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointMentTableViewCell")
        self.tableView.register(UINib.init(nibName: "MeetOrderInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "MeetOrderInfoTableViewCell")
        self.tableView.register(UINib.init(nibName: "OrderCancelTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderCancelTableViewCell")
        
        self.view.addSubview(self.tableView)
        if self.bottomBtn.isHidden {
            self.tableView.snp.makeConstraints { (make) in
                make.top.equalTo(navigationBarTitleView.snp.bottom).offset(0)
                make.left.equalTo(self.view.snp.left).offset(0)
                make.right.equalTo(self.view.snp.right).offset(0)
                make.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }else{
            self.tableView.snp.makeConstraints { (make) in
                make.top.equalTo(navigationBarTitleView.snp.bottom).offset(0)
                make.left.equalTo(self.view.snp.left).offset(0)
                make.right.equalTo(self.view.snp.right).offset(0)
                make.bottom.equalTo(self.bottomBtn.snp.top).offset(0)
            }
        }
        
    }
    
    func cancelClick(){
        let alertControl = UIAlertController(title: "确定要取消与\((orderModel.order_user_info?.real_name)!)的约见吗", message: "取消约见后预约将自动关闭\n如需帮助请联系客服电话\n \(UserDefaultsGetSynchronize("customer_service_number")) 客服微信Meetjun1", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "稍后决定", style: .cancel) { (cancel) in
            
        }
        let rejectAction = UIAlertAction(title: "取消约见", style: .destructive) { (reportAction) in
            
            self.cancelView.title = "取消原因说明"
            self.cancelView.resonType = .cancel
            self.cancelView.orderModel = self.orderModel
            if self.orderModel.status?.status_code == "1" {
                if self.orderModel.status?.status_type == "apply_order"{
                    self.cancelView.changeOrderStatus = "2"
                }
            }else if self.orderModel.status?.status_code == "4" {
                if self.orderModel.status?.status_type == "apply_order"{
                    self.cancelView.changeOrderStatus = "13"
                }else{
                    self.cancelView.changeOrderStatus = "12"
                }
            }else if self.orderModel.status?.status_code == "6" {
                if self.orderModel.status?.status_type == "apply_order"{
                    self.cancelView.changeOrderStatus = "7"
                }else{
                    self.cancelView.changeOrderStatus = "9"
                }
            }
            self.cancelView.reloadOrderStatusChang = { _ in
                self.reloadData()
            }
            self.navigationController?.pushViewController(self.cancelView, animated: true)
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(rejectAction)
        self.present(alertControl, animated: true) {
            
        }
    }
    
    
    func changeShtatues(_ statues:String) {
        viewModel.switchOrderStatus(orderModel.order_id, status: statues,rejectType: "0",rejectReason: "", succeccBlock: { (dic) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: ReloadOrderCollectionView), object: statues)
            self.reloadData()
            }) { (dic) in
                MainThreadAlertShow(dic?["error"] as! String, view: self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configCell(_ cell:CancelInfoTableViewCell, index:IndexPath) {
        //guest
        var resonType:String = ""
        let statusCode = orderModel.status?.status_code
        if orderModel.status?.status_type == "apply_order" {
            if statusCode == "2" || statusCode == "7" || statusCode == "8" || statusCode == "13" {
                resonType = "您因 \((orderModel.reject_type_desc)) 取消了约见"
            }else if statusCode == "3" {
                resonType = "\(orderModel.order_user_info!.real_name) 因 \((orderModel.reject_type_desc)) 拒绝了您的约见"
            }else if statusCode == "9" || statusCode == "10" || statusCode == "12"  {
                resonType = "\(orderModel.order_user_info!.real_name) 因 \((orderModel.reject_type_desc)) 取消了与您的约见"
            }
        }else{
            if statusCode == "2" || statusCode == "7" || statusCode == "8" || statusCode == "13" {
                resonType = "\(orderModel.order_user_info!.real_name) 因 \((orderModel.reject_type_desc))取消了约见"
            }else if statusCode == "3" {
                resonType = "您因 \((orderModel.reject_type_desc)) 拒绝了约见"
            }else if statusCode == "9" || statusCode == "10" || statusCode == "12"  {
                resonType = "您因 \((orderModel.reject_type_desc)) 取消了约见"

            }
        }
        
        cell.setUpData(resonType as String, resonDetail: "\((orderModel.reject_reason))")
    }
    
    func configAppointThemeTypeCell(_ cell:AppointMentTableViewCell, indexPath:IndexPath) {
        cell.setData(orderModel)
    }
    
    func cellIndexPath(_ cellIdf:String, indexPath:IndexPath, tableView:UITableView) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdf, for: indexPath)
        cell.selectionStyle = .none
        switch (indexPath as NSIndexPath).row {
        case 0:
            let returnCell = cell as! OrderFlowTableViewCell
            returnCell.setData((self.orderModel.status?.status_code)!, statusType: (self.orderModel.status?.status_type)!)
            return returnCell
        case 1:
            let returnCell = cell as! AppointMentTableViewCell
            self.configAppointThemeTypeCell(returnCell, indexPath: indexPath)
            return returnCell
        case 2:
            let returnCell = cell as! MeetOrderInfoTableViewCell
            if self.orderModel.status?.status_code == "6" {
                returnCell.setData(orderModel,type:.payDas)
            }else{
                returnCell.setData(orderModel,type:.normal)
            }
            return returnCell
        default:
            let returnCell = cell as! OrderCancelTableViewCell
            returnCell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
            returnCell.selectionStyle = .none
            if self.orderType == .done || self.orderModel.status?.status_code == "11" {
                returnCell.setButtonTitle("反馈客服", type: .cancel)
            }else if self.orderModel.status?.status_code == "1" && self.orderModel.status?.status_type == "receive_order" {
                returnCell.setButtonTitle("反馈客服", type: .cancel)
            }else{
                returnCell.setButtonTitle("取消约见", type: .normal)
            }
            returnCell.cancelBtnClickclouse = {
                self.cancelClick()
            }
            return returnCell
            
        }
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension BaseOrderViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderType == .cancel {
            return 5
        }
        return self.tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.orderType == .cancel {
            if (indexPath as NSIndexPath).row == 0 {
                return 107
            }else if (indexPath as NSIndexPath).row == 1 {
                if tableView.fd_heightForCell(withIdentifier: "CancelInfoTableViewCell", configuration: { (cell) in
                    self.configCell((cell as! CancelInfoTableViewCell), index: indexPath)
                }) > 250 {
                    return tableView.fd_heightForCell(withIdentifier: "CancelInfoTableViewCell", configuration: { (cell) in
                        self.configCell((cell as! CancelInfoTableViewCell), index: indexPath)
                    }) + 10
                }
                return 250
                
            }else if (indexPath as NSIndexPath).row == 2{
                if tableView.fd_heightForCell(withIdentifier: "AppointMentTableViewCell", configuration: { (cell) in
                    self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
                }) > 260 {
                    return tableView.fd_heightForCell(withIdentifier: "AppointMentTableViewCell", configuration: { (cell) in
                        self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
                    })
                }
                return 260
                
            }else if (indexPath as NSIndexPath).row == 3 {
                return 320
            }else{
                return 129
            }
        }else{
            if (indexPath as NSIndexPath).row == 0 {
                return 107;
            }else if (indexPath as NSIndexPath).row == 1{
                print(tableView.fd_heightForCell(withIdentifier: "AppointMentTableViewCell", configuration: { (cell) in
                    self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
                }));
                if tableView.fd_heightForCell(withIdentifier: "AppointMentTableViewCell", configuration: { (cell) in
                    self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
                }) > 240 {
                    return tableView.fd_heightForCell(withIdentifier: "AppointMentTableViewCell", configuration: { (cell) in
                        self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
                    })
                }
                return 250
            }else if (indexPath as NSIndexPath).row == 2 {
                if orderModel.status?.status_code == "6" {
                    return 340
                }
                return 320
            }else{
                if orderModel.status?.status_code == "11" {
                    return 129
                }else if self.orderModel.status?.status_code == "1" && self.orderModel.status?.status_type == "receive_order" {
                    return 129
                }
                return 209
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 0 {
            return 107;
        }else if (indexPath as NSIndexPath).row == 1{
            return 220
        }else if (indexPath as NSIndexPath).row == 2 {
            return 245
        }else{
            return 209
        }
    }
}

extension BaseOrderViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.orderType == .cancel {
            switch (indexPath as NSIndexPath).row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFlowTableViewCell", for: indexPath) as! OrderFlowTableViewCell
                cell.setData((self.orderModel.status?.status_code)!, statusType: (self.orderModel.status?.status_type)!)
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CancelInfoTableViewCell", for: indexPath) as! CancelInfoTableViewCell
                self.configCell(cell, index: indexPath)
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppointMentTableViewCell", for: indexPath) as! AppointMentTableViewCell
                self.configAppointThemeTypeCell(cell, indexPath: indexPath)
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MeetOrderInfoTableViewCell", for: indexPath) as! MeetOrderInfoTableViewCell
                cell.setData(orderModel, type: .normal)
                cell.selectionStyle = .none
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCancelTableViewCell", for: indexPath) as! OrderCancelTableViewCell
                cell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
                cell.setButtonTitle("反馈客服", type: .cancel)
                cell.selectionStyle = .none
                cell.cancelBtnClickclouse = { _ in
                    
                }
                return cell
            }
        }else{
           return cellIndexPath(self.tableViewArray[(indexPath as NSIndexPath).row], indexPath: indexPath, tableView: tableView)
        }
    }
}
