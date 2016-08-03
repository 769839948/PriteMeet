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
    
    let viewModel = OrderViewModel()
    let tableViewArray = ["OrderFlowTableViewCell","AppointMentTableViewCell","MeetOrderInfoTableViewCell"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomNavigationFrame()
        self.setUpBottomBtn()
        self.setUpTableView()
        self.setNavigationItem()
        // Do any additional setup after loading the view.
    }
    
    func setNavigationItem(){
        leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(20, 10, 20, 20)
        leftButton.setImage(UIImage.init(named: "navigationbar_back")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        leftButton.addTarget(self, action: #selector(BaseOrderViewController.leftBarPress(_:)), forControlEvents: .TouchUpInside)
        self.navigationController?.navigationBar.addSubview(leftButton)
        
        rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(ScreenWidth - 40, 10, 20, 20)
        rightButton.setImage(UIImage.init(named: "navigation_info")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        rightButton.addTarget(self, action: #selector(BaseOrderViewController.rightBarPress(_:)), forControlEvents: .TouchUpInside)
        self.navigationController?.navigationBar.addSubview(rightButton)
        
        
        let leftBarButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
        leftBarButton.setBackButtonBackgroundVerticalPositionAdjustment(30, forBarMetrics: .Default)

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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.fd_fullscreenPopGestureRecognizer.enabled = false
    }
    
    override func viewDidDisappear(animated: Bool) {
//        self.navigationController!.fd_fullscreenPopGestureRecognizer.enabled = true
    }
    
    func leftBarPress(sender:UIBarButtonItem) {
        self.titleView.removeFromSuperview()
        self.lineLabel.removeFromSuperview()
        let frame = self.navigationController?.navigationBar.frame
        self.navigationController?.navigationBar.frame = CGRectMake(0, 20, (frame?.size.width)!, (frame?.size.height)! - 21)
        leftButton.removeFromSuperview()
        rightButton.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func rightBarPress(sender:UIBarButtonItem) {
        self.modalTransitionStyle = .CoverVertical
//        self.navigationController.
    }
    
    func setCustomNavigationFrame(){
        let frame = self.navigationController?.navigationBar.frame
        self.navigationController?.navigationBar.frame = CGRectMake(0, 20, (frame?.size.width)!, (frame?.size.height)! + 21)
        lineLabel = UILabel(frame: CGRectMake(0,((frame?.size.height)! + 21.0),ScreenWidth,0.5))
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        self.navigationController?.navigationBar.addSubview(lineLabel)
        
        
        titleView = UIView(frame: CGRectMake(40,2,ScreenWidth - 80,63))
        let phototView = UIImageView(frame: CGRectMake((titleView.frame.size.width - PhotoWith)/2, 2, PhotoWith, PhotoHeight))
        phototView.layer.cornerRadius = PhotoWith/2
        phototView.layer.masksToBounds = true
        phototView.sd_setImageWithURL(NSURL.init(string: (orderModel.order_user_info?.avatar)!), placeholderImage: UIImage.init(color: UIColor.init(hexString: PlaceholderImageColor), size: CGSizeMake(PhotoWith, PhotoHeight)), options: .RetryFailed)
        titleView.addSubview(phototView)
        
        let positionLabel = UILabel(frame: CGRectMake(0, CGRectGetMaxY(phototView.frame) + 3, titleView.frame.size.width, 16))
        positionLabel.text = "\(orderModel.order_user_info!.real_name ) \(orderModel.order_user_info!.job_label)"
        positionLabel.textAlignment = .Center
        positionLabel.font = AppointPositionLabelFont
        titleView.addSubview(positionLabel)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage.init(color: UIColor.redColor(), size: CGSizeMake(ScreenWidth, 63))
        self.navigationController?.navigationBar.addSubview(titleView)
    }
    
    func setUpTableView() {
        self.tableView = UITableView(frame: CGRectZero, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(OrderFlowTableViewCell.self, forCellReuseIdentifier: "OrderFlowTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "OrderProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderProfileTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "AppointMentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointMentTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "MeetOrderInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "MeetOrderInfoTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "OrderCancelTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderCancelTableViewCell")

        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.bottomBtn.snp_top).offset(0)
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
            returnCell.setData(orderModel)
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
            return 128;
        }else if indexPath.row == 1{
            return tableView.fd_heightForCellWithIdentifier("AppointMentTableViewCell", configuration: { (cell) in
                self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
            })
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
