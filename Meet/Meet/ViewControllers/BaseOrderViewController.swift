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
    case Cancel
    case Reject
    case Done
    case Doing
}

typealias ReloadCollectionClouser = (status:String) -> Void

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
    
    var orderType:OrderType!
    
    let viewModel = OrderViewModel()
    var uid:String = ""
    let tableViewArray = ["OrderFlowTableViewCell","AppointMentTableViewCell","MeetOrderInfoTableViewCell","OrderCancelTableViewCell"]
    
    var weChatPayreq:PayReq = PayReq()
    var aliPayurl:String!
    var payView:PayView!
    
    let cancelView = OrderCancelRejectViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBottomBtn()
        self.setUpNavigationTitleView()
        self.setUpTableView()
        self.fd_prefersNavigationBarHidden = true
        self.changeOrderType()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WaitPayViewController.changePayStatues(_:)), name: WeiXinPayStatues, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WaitPayViewController.changePayStatues(_:)), name: AliPayStatues, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func setUpNavigationTitleView() {
        navigationBarTitleView = UIView(frame:CGRectMake(0,0,ScreenWidth, 84))
        navigationBarTitleView.backgroundColor = UIColor.whiteColor()
        self.setNavigationItem()
        lineLabel = UILabel(frame: CGRectMake(0,83.5,ScreenWidth,0.5))
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        navigationBarTitleView.addSubview(lineLabel)
        self.setUpTitleView()
        self.view.addSubview(navigationBarTitleView)
        
    }
    
    func setNavigationItem(){
        leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(0, 20, 40, 40)
        leftButton.setImage(UIImage.init(named: "navigationbar_back")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        leftButton.addTarget(self, action: #selector(BaseOrderViewController.leftBarPress(_:)), forControlEvents: .TouchUpInside)
        navigationBarTitleView.addSubview(leftButton)
        
        rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(ScreenWidth - 40, 20, 40, 40)
        rightButton.setImage(UIImage.init(named: "navigation_info")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        rightButton.addTarget(self, action: #selector(BaseOrderViewController.rightBarPress(_:)), forControlEvents: .TouchUpInside)
        navigationBarTitleView.addSubview(rightButton)

    }
    
    func updataConstraints(){
        self.tableView.snp_updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }
    
    func setUpBottomBtn() {
        bottomBtn = UIButton()
        bottomBtn.backgroundColor = UIColor.init(hexString: AppointMentBackGroundColor)
        bottomBtn.addTarget(self, action: #selector(BaseOrderViewController.bottomPress(_:)), forControlEvents: .TouchUpInside)
        bottomBtn.titleLabel?.font = MeetDetailImmitdtFont
        self.view.addSubview(bottomBtn)
        
        bottomBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
            make.height.equalTo(49)
        }
    }
    
    func cofirmBottomClick() {
        let alertControl = UIAlertController(title: "确定要接受\((orderModel.order_user_info?.real_name)!)的约见吗？", message: "接受约见及对方付款后即可开始沟通见面\n拒绝约见后该预约将自动关闭", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "稍后决定", style: .Cancel) { (cancel) in
            
        }
        
        let accpetAction = UIAlertAction(title: "接受约见", style: .Default) { (blackList) in
            self.viewModel.orderStatusOperation(self.orderModel.order_id, withHos: UserInfo.sharedInstance().uid, successBlock: { (dic) in
                if self.myClouse != nil {
                    self.myClouse(status:(self.orderModel.status?.order_status)!)
                }
                self.reloadData()
                }, failBlock: { (dic) in
                    UITools.showMessageToView(self.view, message: "确认失败", autoHide: true)
            })
        }
        let rejectAction = UIAlertAction(title: "拒绝约见", style: .Destructive) { (reportAction) in
            let cancelView = OrderCancelRejectViewController()
            cancelView.title = "拒绝原因说明"
            cancelView.resonType = .Reject
            cancelView.orderModel = self.orderModel
            self.navigationController?.pushViewController(cancelView, animated: true)
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(accpetAction)
        alertControl.addAction(rejectAction)
        self.presentViewController(alertControl, animated: true) {
            
        }
    }
    
    func payBottomClick() {
        var theme = ""
        for index in 0...orderModel.appointment_theme.count - 1 {
            theme = theme.stringByAppendingString((orderModel.appointment_theme as NSArray).objectAtIndex(index) as! String)
            if index !=  orderModel.appointment_theme.count - 1 {
                theme = theme.stringByAppendingString("、")
            }
        }
        payView = PayView(frame: CGRectMake(0,0,ScreenWidth,ScreenHeight))
        payView.setUpData((orderModel.order_user_info?.real_name)!, themes: theme, much: orderModel.fee)
        payView.paySelectItem = { payType in
            if payType == "weiChat" {
                WXApi.sendReq(self.weChatPayreq)
            }else{
                AlipaySDK.defaultService().payOrder(self.aliPayurl, fromScheme: "MeetAlipay") { (resultDic) in
                }
            }
        }
        KeyWindown?.addSubview(payView)
    }
    
    func meetBottomClick() {
        let alertControl = UIAlertController(title: "确定要双方已经见面", message: "确认与 \((orderModel.order_user_info?.real_name)!) 见面后\n对方会收到见面完成的确认短信", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "暂不", style: .Cancel) { (cancel) in
            
        }
        
        let accpetAction = UIAlertAction(title: "确认见面", style: .Default) { (blackList) in
            if self.orderModel.status?.status_type == "apply_order" {
                self.changeShtatues("11")
            }else{
                self.changeShtatues("11")
            }
            
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(accpetAction)
        self.presentViewController(alertControl, animated: true) {
            
        }
    }
    
    func loadPayInfo(){
        viewModel.payOrder(orderModel.order_id, successBlock: { (dic) in
            let payDic = dic as NSDictionary
            self.aliPayurl = payDic.objectForKey("alipay") as! String
            let weChatDic = payDic["wxpay"] as! NSDictionary;
            self.weChatPayreq.nonceStr = weChatDic.objectForKey("noncestr") as! String
            self.weChatPayreq.package = weChatDic.objectForKey("package") as! String
            self.weChatPayreq.partnerId = weChatDic.objectForKey("partnerid") as! String
            self.weChatPayreq.prepayId = weChatDic.objectForKey("prepayid") as! String
            self.weChatPayreq.sign = weChatDic.objectForKey("sign") as! String
            let timeString = (weChatDic.objectForKey("timestamp") as! String)
            let time:UInt32 = UInt32(timeString)!
            self.weChatPayreq.timeStamp = time
            }, failBlock: { (dic) in
                
        })
    }
    
    
    func changePayStatues(notification:NSNotification) {
        let payCompleteVC = Stroyboard("Order", viewControllerId: "PayCompleteViewController") as! PayCompleteViewController
        payCompleteVC.orderModel = self.orderModel
        self.navigationController?.pushViewController(payCompleteVC, animated: true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WeiXinPayStatues, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AliPayStatues, object: nil)
    }
    
    func bottomPress(sender:UIButton) {
        if orderModel.status?.status_code == "1" {
            self.cofirmBottomClick()
        }else if orderModel.status?.status_code == "4" {
            self.payBottomClick()
        }else if orderModel.status?.status_code == "6" {
            self.meetBottomClick()
        }
    }
    
    func leftBarPress(sender:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func reloadData() {
        viewModel.orderDetail(orderModel.order_id, successBlock: { (dic) in
            self.orderModel = OrderModel.mj_objectWithKeyValues(dic)
            self.changeOrderType()
            self.tableView.reloadData()
            self.changeBottomBtnTitle()
        }) { (dic) in
            
        }
    }
    
    func changeOrderType() {
        let code = self.orderModel.status?.status_code
        if code == "1" || code == "4" || code == "6" {
            self.orderType = .Doing
        }else if code == "11" {
            self.orderType == .Done
        }else{
            self.orderType = .Cancel
        }
    }
    
    func changeBottomBtnTitle(){
        if orderModel.status?.status_code == "1" {
            if self.orderModel.status?.status_type == "receive_order" {
                bottomBtn.setTitle("接受/拒绝", forState: .Normal)
            }else{
                self.updataConstraints()
                bottomBtn.hidden = true
            }
        }else if orderModel.status?.status_code == "4" {
            if self.orderModel.status?.status_type == "receive_order" {
                bottomBtn.hidden = true
                self.updataConstraints()
            }else{
                bottomBtn.setTitle("立即支付 RMB \(orderModel.fee)", forState: .Normal)
            }
            self.loadPayInfo()
        }else if orderModel.status?.status_code == "6" {
            bottomBtn.setTitle("确认双方已约见", forState: .Normal)
        }else{
            bottomBtn.hidden = true
        }
    }
    
    func rightBarPress(sender:UIBarButtonItem) {
        let meetDetailVC = MeetDetailViewController()
        meetDetailVC.user_id = orderModel.order_user_info!.uid
        meetDetailVC.isOrderViewPush = true
        self.navigationController?.pushViewController(meetDetailVC, animated: true)
    }
    
    func setUpTitleView(){
        titleView = UIView(frame: CGRectMake(40,22,ScreenWidth - 80,63))
        let phototView = UIImageView(frame: CGRectMake((titleView.frame.size.width - PhotoWith)/2, 2, PhotoWith, PhotoHeight))
        phototView.layer.cornerRadius = PhotoWith/2
        phototView.layer.masksToBounds = true
        phototView.sd_setImageWithURL(NSURL.init(string: (orderModel.order_user_info?.avatar)!), placeholderImage: UIImage.init(color: UIColor.init(hexString: PlaceholderImageColor), size: CGSizeMake(PhotoWith, PhotoHeight)), options: .RetryFailed)
        titleView.addSubview(phototView)
        
        let positionLabel = UILabel(frame: CGRectMake(0, CGRectGetMaxY(phototView.frame) + 3, titleView.frame.size.width, 16))
        let positionString = "\(orderModel.order_user_info!.real_name ) \(orderModel.order_user_info!.job_label)"
        let attributedString = NSMutableAttributedString(string: positionString)
        attributedString.addAttributes([NSFontAttributeName:AppointRealNameLabelFont!], range: NSRange.init(location: 0, length: orderModel.order_user_info!.real_name.length))
        attributedString.addAttributes([NSFontAttributeName:AppointPositionLabelFont!], range: NSRange.init(location: orderModel.order_user_info!.real_name.length + 1, length: orderModel.order_user_info!.job_label.length))
        positionLabel.attributedText = attributedString
        positionLabel.textAlignment = .Center
        titleView.addSubview(positionLabel)
        navigationBarTitleView.addSubview(titleView)
    }
    
    func setUpTableView() {
        self.tableView = UITableView(frame: CGRectZero, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(OrderFlowTableViewCell.self, forCellReuseIdentifier: "OrderFlowTableViewCell")
        self.tableView.registerClass(CancelInfoTableViewCell.self, forCellReuseIdentifier: "CancelInfoTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "OrderProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderProfileTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "AppointMentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointMentTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "MeetOrderInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "MeetOrderInfoTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "OrderCancelTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderCancelTableViewCell")
        
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(navigationBarTitleView.snp_bottom).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.bottomBtn.snp_top).offset(0)
        }
    }
    
    func cancelClick(){
        let alertControl = UIAlertController(title: "确定要取消与\((orderModel.order_user_info?.real_name)!)的约见吗", message: "取消约见后预约将自动关闭\n如需帮助请联系客服电话\n \(UserDefaultsGetSynchronize("customer_service_number")) 客服微信Meetjun1", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "稍后决定", style: .Cancel) { (cancel) in
            
        }
        let rejectAction = UIAlertAction(title: "取消约见", style: .Destructive) { (reportAction) in
            
            self.cancelView.title = "取消原因说明"
            self.cancelView.resonType = .Cancel
            self.cancelView.orderModel = self.orderModel
            if self.orderModel.status?.status_code == "1" {
                if self.orderModel.status?.status_type == "apply_order"{
                    self.cancelView.changeOrderStatus = "2"
                }else{
                    self.cancelView.changeOrderStatus = "3"
                }
            }else if self.orderModel.status?.status_code == "4" {
                if self.orderModel.status?.status_type == "apply_order"{
                    self.cancelView.changeOrderStatus = "12"
                }else{
                    self.cancelView.changeOrderStatus = "13"
                }
            }else if self.orderModel.status?.status_code == "6" {
                if self.orderModel.status?.status_type == "apply_order"{
                    self.cancelView.changeOrderStatus = "7"
                }else{
                    self.cancelView.changeOrderStatus = "8"
                }
            }
            self.cancelView.reloadOrderStatusChang = { _ in
                self.reloadData()
            }
            self.navigationController?.pushViewController(self.cancelView, animated: true)
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(rejectAction)
        self.presentViewController(alertControl, animated: true) {
            
        }
    }
    
    
    func changeShtatues(statues:String) {
        viewModel.switchOrderStatus(orderModel.order_id, status: statues,rejectType: "0",rejectReason: "", succeccBlock: { (dic) in
            self.reloadData()
            }) { (dic) in
                UITools.showMessageToView(self.view, message: (dic as NSDictionary).objectForKey("error") as! String, autoHide: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configCell(cell:CancelInfoTableViewCell, index:NSIndexPath) {
        cell.setUpData("\((orderModel.order_user_info?.real_name)!) 因\((orderModel.reject_type_desc))", resonDetail: "\((orderModel.reject_reason))")
    }
    
    func configAppointThemeTypeCell(cell:AppointMentTableViewCell, indexPath:NSIndexPath) {
        cell.setData(orderModel)
    }
    
    func cellIndexPath(cellIdf:String, indexPath:NSIndexPath, tableView:UITableView) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdf, forIndexPath: indexPath)
        cell.selectionStyle = .None
        switch indexPath.row {
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
                returnCell.setData(orderModel,type:.WaitMeet)
            }else{
                returnCell.setData(orderModel,type:.WaitPay)
            }
            return returnCell
        default:
            let returnCell = cell as! OrderCancelTableViewCell
            returnCell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
            returnCell.selectionStyle = .None
            returnCell.setButtonTitle("取消约见", type: .Normal)
            returnCell.cancelBtnClickclouse = {
                self.cancelClick()
            }
            return returnCell
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension BaseOrderViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderType == .Cancel {
            return 5
        }
        return self.tableViewArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.orderType == .Cancel {
            if indexPath.row == 0 {
                return 107
            }else if indexPath.row == 1 {
                return tableView.fd_heightForCellWithIdentifier("CancelInfoTableViewCell", configuration: { (cell) in
                    self.configCell((cell as! CancelInfoTableViewCell), index: indexPath)
                }) + 10
            }else if indexPath.row == 2{
                return tableView.fd_heightForCellWithIdentifier("AppointMentTableViewCell", configuration: { (cell) in
                    self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
                })
            }else if indexPath.row == 3 {
                return 320
            }else{
                return 129
            }
        }else{
            if indexPath.row == 0 {
                return 107;
            }else if indexPath.row == 1{
                return tableView.fd_heightForCellWithIdentifier("AppointMentTableViewCell", configuration: { (cell) in
                    self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
                })
            }else if indexPath.row == 2 {
                if orderModel.status?.status_code == "6" {
                    return 340
                }
                return 245
            }else{
                if orderModel.status?.status_code == "11" {
                    return 129
                }
                return 209
            }
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 107;
        }else if indexPath.row == 1{
            return 220
        }else if indexPath.row == 2 {
            return 245
        }else{
            return 209
        }
    }
}

extension BaseOrderViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.orderType == .Cancel {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("OrderFlowTableViewCell", forIndexPath: indexPath) as! OrderFlowTableViewCell
                cell.setData((self.orderModel.status?.status_code)!, statusType: (self.orderModel.status?.status_type)!)
                cell.selectionStyle = .None
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("CancelInfoTableViewCell", forIndexPath: indexPath) as! CancelInfoTableViewCell
                self.configCell(cell, index: indexPath)
                cell.selectionStyle = .None
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("AppointMentTableViewCell", forIndexPath: indexPath) as! AppointMentTableViewCell
                self.configAppointThemeTypeCell(cell, indexPath: indexPath)
                cell.selectionStyle = .None
                return cell
            case 3:
                let cell = tableView.dequeueReusableCellWithIdentifier("MeetOrderInfoTableViewCell", forIndexPath: indexPath) as! MeetOrderInfoTableViewCell
                cell.setData(orderModel, type: .Cancel)
                cell.selectionStyle = .None
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("OrderCancelTableViewCell", forIndexPath: indexPath) as! OrderCancelTableViewCell
                cell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
                cell.setButtonTitle("反馈客服", type: .Cancel)
                cell.cancelBtnClickclouse = { _ in
                    
                }
                return cell
            }
        }else{
           return cellIndexPath(self.tableViewArray[indexPath.row], indexPath: indexPath, tableView: tableView)
        }
    }
}
