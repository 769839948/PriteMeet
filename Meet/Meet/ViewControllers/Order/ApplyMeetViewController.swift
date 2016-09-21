//
//  ApplyMeetViewController.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class ApplyMeetViewController: UIViewController {

    
    var titleView:UIView!
    var lineLabel:UILabel!
    
    var tableView:UITableView!
    var viewModel:OrderViewModel!
    var flowPath:UIView!
    var host:String = ""
    var allItems = NSMutableArray()
    var plachString = ""
    var selectItems = NSMutableArray()
    
    var avater:String!
    var jobLabel:String!
    var realName:String!
    
    var leftButton:UIButton!
    var bottomBtn:UIButton!

    var cell:OrderApplyMeetTableViewCell!
    var introductionCell:OrderApplyIntroductionCell!
    
    var navigationBarTitleView: UIView!
    
    var loginView:LoginView!
        
    var isApplyOrder:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupForDismissKeyboard()
        self.setUpNavigationTitleView()
        self.setUpBottomBtn()
        self.setUpTableView()
        self.navigationItemWhiteColorAndNotLine()
        self.fd_prefersNavigationBarHidden = true
        self.talKingDataPageName = "Order-ApplyMeet"
        for _ in 0...self.allItems.count - 1 {
            self.selectItems.add("false")
        }
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
        leftButton.frame = CGRect(x: 20, y: 30, width: 20, height: 20)
        leftButton.setImage(UIImage.init(named: "navigationbar_back")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
        leftButton.addTarget(self, action: #selector(ApplyMeetViewController.leftBarPress(_:)), for: .touchUpInside)
        navigationBarTitleView.addSubview(leftButton)
        
    }

    func leftBarPress(_ sender:UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setUpTableView(){
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        self.tableView.register(OrderFlowTableViewCell.self, forCellReuseIdentifier: "OrderFlowTableViewCell")
        self.tableView.register(OrderApplyMeetTableViewCell.self, forCellReuseIdentifier: "OrderApplyMeetTableViewCell")
        self.tableView.register(OrderApplyIntroductionCell.self, forCellReuseIdentifier: "OrderApplyIntroductionCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.register(UINib.init(nibName: "OrderApplyInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderApplyInfoTableViewCell")
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationBarTitleView.snp.bottom).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.bottomBtn.snp.top).offset(0)
        }
        self.tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
    }
    
    
    func setUpTitleView(){
        
        titleView = UIView(frame: CGRect(x: 40,y: 22,width: ScreenWidth - 80,height: 63))
        let phototView = UIImageView(frame: CGRect(x: (titleView.frame.size.width - PhotoWith)/2, y: 2, width: PhotoWith, height: PhotoHeight))
        phototView.layer.cornerRadius = PhotoWith/2
        phototView.layer.masksToBounds = true
        let imageArray = avater.components(separatedBy: "?")
        UIImage.image(withUrl: imageArray[0], newImage: CGSize.init(width: 24, height: 24),success:{ imageUrl in
            phototView.sd_setImage(with: URL.init(string: imageArray[0] + imageUrl!), placeholderImage: UIImage.init(color: UIColor.init(hexString: PlaceholderImageColor), size: CGSize(width: PhotoWith, height: PhotoHeight)), options: .retryFailed)
        })
        
        titleView.addSubview(phototView)
        
        let positionLabel = UILabel(frame: CGRect(x: 0, y: phototView.frame.maxY + 3, width: titleView.frame.size.width, height: 16))
        let positionString = "\((realName)!) \((jobLabel)!)"
        let attributedString = NSMutableAttributedString(string: positionString)
        attributedString.addAttributes([NSFontAttributeName:AppointRealNameLabelFont!], range: NSRange.init(location: 0, length: realName.length))
        attributedString.addAttributes([NSFontAttributeName:AppointPositionLabelFont!], range: NSRange.init(location: realName.length + 1, length: jobLabel.length))
        attributedString.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: HomeDetailViewNameColor)], range: NSRange.init(location: 0, length: positionString.length))
        positionLabel.attributedText = attributedString
        positionLabel.textAlignment = .center
        titleView.addSubview(positionLabel)
        navigationBarTitleView.addSubview(titleView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func senderApplyMeet(_ sender:UIButton){
        if !UserInfo.isLoggedIn() {
            self.persenterLoginView()
        }else{
            self.applyMeet()
        }
    }
    
    func applyMeet() {
        
        if !UserExtenModel.shareInstance().info_is_complete {
            UITools.showMessage(to: self.view, message: "完善资料后才可以约见哦", autoHide: true)
            return
        }
        
        if isApplyOrder {
            UITools.showMessage(to: self.view, message: "预约提交中请稍后", autoHide: true)
            return
        }
        viewModel = OrderViewModel()
        var appointment_theme = ""
        for idx in 0...self.selectItems.count - 1 {
            let ret = self.selectItems[idx]
            if ret as! String == "true" {
                appointment_theme = appointment_theme + ((((ProfileKeyAndValue.shareInstance().appDic as NSDictionary).object(forKey: "invitation") as! NSDictionary).object(forKey: "\(allItems[idx])"))! as! String)
                appointment_theme = appointment_theme + ","
                
            }
        }
        
        if appointment_theme == "" {
            MainThreadAlertShow("未选择约见形式哦", view: self.view)
            return
        }
        
        if introductionCell.textView.text == "" {
            MainThreadAlertShow("未填写约见说明哦", view: self.view)
            return
        }
        
        if introductionCell.textView.text.length > 300 {
            MainThreadAlertShow("约见说明超过最多300字限制了哦", view: self.view)
            return
        }
        
        if introductionCell.textView.text.length < 15 {
            MainThreadAlertShow("约见说明可以再丰富些哦", view: self.view)
            return
        }
        self.isApplyOrder = true
        let applyModel = ApplyMeetModel()
        applyModel.appointment_desc = introductionCell.textView.text;
        applyModel.appointment_theme = appointment_theme
        applyModel.host = self.host
        applyModel.guest = UserInfo.sharedInstance().uid
        viewModel.applyMeetOrder(applyModel, successBlock: { (dic) in
            let orderDic = dic! as [AnyHashable:Any] as NSDictionary
            self.viewModel.orderDetail(orderDic.object(forKey: "order_id") as! String, successBlock: { (dic) in
                let orderModel = OrderModel.mj_object(withKeyValues: dic?["order"])
            UserDefaults.standard.set(dic?["customer_service_number"], forKey: "customer_service_number")
                let applyDetailView = ConfirmedViewController()
                applyDetailView.uid = self.host
                applyDetailView.isAppliViewPush = true
                applyDetailView.orderModel = orderModel
                self.navigationController?.pushViewController(applyDetailView, animated: true)
                }, fialBlock: { (dic) in
                    
            })
            self.isApplyOrder = false
        }) { (dic) in
            let failDic = dic! as [AnyHashable:Any] as NSDictionary
            MainThreadAlertShow(failDic.object(forKey: "error") as! String, view: self.view)
            self.isApplyOrder = false
        }
    }
    
    func persenterLoginView() {
        
        let loginView = LoginViewController()
        
//        loginView.protocolClouse = { _ in
//            let userProtocol = Stroyboard("Seting", viewControllerId: "UserProtocolViewController") as! UserProtocolViewController
//            userProtocol.block = { _ in
//                self.loginView.mobileTextField.becomeFirstResponder()
//                UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(self.loginView)
//            }
//            self.navigationController?.pushViewController(userProtocol, animated: true)
//            UIApplication.sharedApplication().keyWindow?.sendSubviewToBack(self.loginView)
//        }
        
        loginView.newUserLoginClouse = { _ in
            let baseUserInfo =  Stroyboard("Me", viewControllerId: "BaseInfoViewController") as! BaseUserInfoViewController
            baseUserInfo.isHomeListViewLogin = true
            baseUserInfo.applyMeeBlock = { _ in
                self.applyMeet()
            }
            self.navigationController?.pushViewController(baseUserInfo, animated: true)
        }
        
        loginView.loginWithOrderListClouse = { _ in
            self.applyMeet()
        }
        let controller = UINavigationController(rootViewController: loginView)
        self.present(controller, animated: true) {
            
        }
    }
    
    func setUpBottomBtn() {
        bottomBtn = UIButton()
        bottomBtn.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeViewDetailMeetButtonBack), size: CGSize(width: ScreenWidth, height: 49)), for: UIControlState())
        bottomBtn.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeViewDetailMeetButtonHightBack), size: CGSize(width: ScreenWidth, height: 49)), for: .highlighted)
        bottomBtn.addTarget(self, action: #selector(ApplyMeetViewController.senderApplyMeet(_:)), for: .touchUpInside)
        bottomBtn.setTitle("提交申请", for: UIControlState())
        bottomBtn.titleLabel?.font = MeetDetailImmitdtFont
        self.view.addSubview(bottomBtn)
        
        bottomBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
            make.height.equalTo(49)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func setData(_ cell:OrderApplyMeetTableViewCell) {
        if allItems.count > 0 {
            cell.setData(allItems.copy() as! NSArray, selectItems: selectItems.copy() as! NSArray)
        }
    }
}

extension ApplyMeetViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                return 108
            }else{
                return tableView.fd_heightForCell(withIdentifier: "OrderApplyMeetTableViewCell", configuration: { (cell) in
                    self.setData(cell as! OrderApplyMeetTableViewCell)
                })
            }
        }else{
            if (indexPath as NSIndexPath).row == 0 {
                return 291
            }else{
                 return 274
            }
        }
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}

extension ApplyMeetViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFlowTableViewCell", for: indexPath) as! OrderFlowTableViewCell
                cell.selectionStyle = .none
                cell.setData("0", statusType: "apply_order")
                return cell
            }else{
                let cellId = "OrderApplyMeetTableViewCell"
                cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! OrderApplyMeetTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                self.setData(cell)
                cell.clourse = { selectItem in
                    if self.selectItems[selectItem] as! String == "true" {
                        self.selectItems.replaceObject(at: selectItem, with: "false")
                    }else{
                        self.selectItems.replaceObject(at: selectItem, with: "true")
                    }
                    
                }
                return cell
            }
        }else{
            if (indexPath as NSIndexPath).row == 0 {
                let cellId = "OrderApplyIntroductionCell"
                introductionCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderApplyIntroductionCell
                introductionCell.setData("\((PlaceholderText.shareInstance().appDic as NSDictionary).object(forKey: "1000002")!)")
                introductionCell.textView.delegate = self
                introductionCell.textView.isScrollEnabled = false
                introductionCell.selectionStyle = UITableViewCellSelectionStyle.none
                introductionCell.numberText.isHidden = true
                return introductionCell
            }else{
                let cellId = "OrderApplyInfoTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderApplyInfoTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.setData("\((PlaceholderText.shareInstance().appDic as NSDictionary).object(forKey: "1000003")!)")
                return cell
            }
        }
    }
}

extension ApplyMeetViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let length = 300 - textView.text.length
        introductionCell.numberText.text = "\(length)"
        if textView.text.length > 280 {
            introductionCell.numberText.isHidden = false
        }else{
            introductionCell.numberText.isHidden = true
        }
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
}
