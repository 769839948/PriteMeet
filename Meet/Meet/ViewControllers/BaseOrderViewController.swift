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
    
    let viewModel = OrderViewModel()
    var uid:String = ""
    let tableViewArray = ["OrderFlowTableViewCell","AppointMentTableViewCell","MeetOrderInfoTableViewCell"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBottomBtn()
        self.setUpNavigationTitleView()
        self.setUpTableView()
        self.fd_prefersNavigationBarHidden = true
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
    
    //MARK:底部按钮执行放到各个子视图去
    func bottomPress(sender:UIButton) {
        
    }
    
    func leftBarPress(sender:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
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
    
    func changeShtatues(statues:String) {
        viewModel.switchOrderStatus(orderModel.order_id, status: statues,rejectType: "0",rejectReason: "", succeccBlock: { (dic) in
                self.navigationController?.popViewControllerAnimated(true)
            }) { (dic) in
                UITools.showMessageToView(self.view, message: (dic as NSDictionary).objectForKey("error") as! String, autoHide: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "Default")
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension BaseOrderViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
        return cellIndexPath(self.tableViewArray[indexPath.row], indexPath: indexPath, tableView: tableView)
    }
}
