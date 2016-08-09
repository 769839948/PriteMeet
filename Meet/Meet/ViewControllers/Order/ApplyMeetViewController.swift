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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomNavigationFrame()
        self.setupForDismissKeyboard()
        self.setUpBottomBtn()
        self.setUpTableView()
        self.setNavigationItem()
        self.navigationItemWhiteColorAndNotLine()
        self.talKingDataPageName = "Order-ApplyMeet"
        // Do any additional setup after loading the view.
    }

    func setNavigationItem(){
        leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(20, 10, 20, 20)
        leftButton.setImage(UIImage.init(named: "navigationbar_back")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        leftButton.addTarget(self, action: #selector(ApplyMeetViewController.leftBarPress(_:)), forControlEvents: .TouchUpInside)
        self.navigationController?.navigationBar.addSubview(leftButton)
        
        
        let leftBarButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
        leftBarButton.setBackButtonBackgroundVerticalPositionAdjustment(30, forBarMetrics: .Default)
        
    }

    func leftBarPress(sender:UIBarButtonItem) {
        self.titleView.removeFromSuperview()
        self.lineLabel.removeFromSuperview()
        let frame = self.navigationController?.navigationBar.frame
        self.navigationController?.navigationBar.frame = CGRectMake(0, 20, (frame?.size.width)!, (frame?.size.height)! - 21)
        leftButton.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setUpTableView(){
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        self.tableView.registerClass(OrderFlowTableViewCell.self, forCellReuseIdentifier: "OrderFlowTableViewCell")
        self.tableView.registerClass(OrderApplyMeetTableViewCell.self, forCellReuseIdentifier: "OrderApplyMeetTableViewCell")
        self.tableView.registerClass(OrderApplyIntroductionCell.self, forCellReuseIdentifier: "OrderApplyIntroductionCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "OrderApplyInfoTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "OrderApplyInfoTableViewCell")
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(21)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.bottomBtn.snp_top).offset(0)
        }
        self.tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
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
        phototView.sd_setImageWithURL(NSURL.init(string: avater), placeholderImage: UIImage.init(color: UIColor.init(hexString: PlaceholderImageColor), size: CGSizeMake(PhotoWith, PhotoHeight)), options: .RetryFailed)
        titleView.addSubview(phototView)
        
        let positionLabel = UILabel(frame: CGRectMake(0, CGRectGetMaxY(phototView.frame) + 3, titleView.frame.size.width, 16))
        positionLabel.text = "\(realName) \(jobLabel)"
        positionLabel.textAlignment = .Center
        positionLabel.font = AppointPositionLabelFont
        titleView.addSubview(positionLabel)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage.init(color: UIColor.redColor(), size: CGSizeMake(ScreenWidth, 63))
        self.navigationController?.navigationBar.addSubview(titleView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendreInvite(sender:UIButton){
        viewModel = OrderViewModel()
        var appointment_theme = ""
        
        for idx in 0...cell.interestView.selectItems.count - 1 {
            let ret = cell.interestView.selectItems[idx]
            if ret as! String == "true" {
                appointment_theme = appointment_theme.stringByAppendingString(((ProfileKeyAndValue.shareInstance().appDic as NSDictionary).objectForKey("invitation")?.objectForKey("\(allItems[idx])"))! as! String)
                appointment_theme = appointment_theme.stringByAppendingString(",")

            }
        }
        let applyModel = ApplyMeetModel()
        applyModel.appointment_desc = introductionCell.textView.text;
        applyModel.appointment_theme = appointment_theme
        applyModel.host = self.host
        applyModel.guest = UserInfo.sharedInstance().uid
        viewModel.applyMeetOrder(applyModel, successBlock: { (dic) in
            UITools.showMessageToView(self.view, message: "申请成功", autoHide: true)
//            let applyComfim = Stroyboard("Order",viewControllerId: "ApplyConfimViewController") as!  ConfirmedViewController
//            self.navigationController?.pushViewController(applyComfim, animated: true)
            }) { (dic) in
                
        }
    }
    
    func setUpBottomBtn() {
        bottomBtn = UIButton()
        bottomBtn.backgroundColor = UIColor.init(hexString: AppointMentBackGroundColor)
        bottomBtn.addTarget(self, action: #selector(ApplyMeetViewController.sendreInvite(_:)), forControlEvents: .TouchUpInside)
        bottomBtn.setTitle("提交申请", forState: .Normal)
        bottomBtn.titleLabel?.font = MeetDetailImmitdtFont
        self.view.addSubview(bottomBtn)
        
        bottomBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
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
    func setData(cell:OrderApplyMeetTableViewCell){
        if allItems.count > 0 {
            cell.setData(allItems.copy() as! NSArray, selectItems: selectItems.copy() as! NSArray)
        }
    }

}

extension ApplyMeetViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 108
            }else{
                return tableView.fd_heightForCellWithIdentifier("OrderApplyMeetTableViewCell", configuration: { (cell) in
                    self.setData(cell as! OrderApplyMeetTableViewCell)
                })
            }
        }else{
            if indexPath.row == 0 {
                return 291
            }else{
                 return 274
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        self.view.endEditing(true)
//    }
}

extension ApplyMeetViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("OrderFlowTableViewCell", forIndexPath: indexPath) as! OrderFlowTableViewCell
                cell.selectionStyle = .None
                cell.setData("0", statusType: "apply_order")
                return cell
            }else{
                let cellId = "OrderApplyMeetTableViewCell"
                cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderApplyMeetTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                self.setData(cell)
                return cell
            }
        }else{
            if indexPath.row == 0 {
                let cellId = "OrderApplyIntroductionCell"
                introductionCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! OrderApplyIntroductionCell
                introductionCell.setData("您可以说说为什么想约见对方以及希望见面聊聊的话题。真诚且走心的约见说明，会让对方更感兴趣，被接受的几率也会大大增加哦，最多可输入 300 字")
                introductionCell.selectionStyle = UITableViewCellSelectionStyle.None
                return introductionCell
            }else{
                let cellId = "OrderApplyInfoTableViewCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! OrderApplyInfoTableViewCell
//                cell.setData("")
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        }
    }
}
