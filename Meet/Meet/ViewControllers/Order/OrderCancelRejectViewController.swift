//
//  OrderCancelRejectViewController.swift
//  Meet
//
//  Created by Zhang on 8/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

enum CancelType {
    case Cancel
    case Reject
}

typealias ReloadOrderStatusChang = () -> Void

class OrderCancelRejectViewController: UIViewController {

    var tableView:UITableView!
    var reportArray = NSMutableArray()
    var selectIndexPaths = NSMutableArray()
    var reportKeys = NSMutableArray()

    var orderModel:OrderModel!
    let viewModel = OrderViewModel()
    var uid = ""
    var resonType:CancelType!
    var myClouse:PopNavigationController!
    
    var textView:UITextView!
    
    var changeOrderStatus:String = ""
    var reject_type:String = "0"
    var reject_reson:String = ""
    
    var reloadOrderStatusChang:ReloadOrderStatusChang!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "提交", style: .Plain, target: self, action: #selector(ReportViewController.reportBtnPress(_:)))
        self.navigationController?.navigationBar.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
        self.setUpTableView()
        self.setUpNavigationItem()
        self.fd_prefersNavigationBarHidden = false
        self.talKingDataPageName = "Home-Detail-Cancel&Reject"
        self.view.addSubview(self.lineLabel(CGRectMake(0, 0, ScreenWidth, 0.5)))
        self.setUpData()
        // Do any additional setup after loading the view.
    }

    func setUpData() {
        viewModel.orderCancelRejectReson({ (dic) in
            let cancelDic:NSDictionary!
            var sortedKeysAndValues:NSArray!
            let reason = dic as NSDictionary
            if self.resonType == .Cancel {
                cancelDic = (reason.objectForKey("cancel") as! NSDictionary)
                sortedKeysAndValues = (cancelDic.allKeys as! [String]).sort({ s1, s2 in
                    return Int(s1)! < Int(s2)!
                })
            }else{
                cancelDic = (reason.objectForKey("reject") as! NSDictionary)
                sortedKeysAndValues = (cancelDic.allKeys as! [String]).sort({ s1, s2 in
                    return Int(s1)! < Int(s2)!
                })
            }
            self.reportKeys.addObjectsFromArray(sortedKeysAndValues as [AnyObject])
            for value in sortedKeysAndValues {
                self.reportArray.addObject(cancelDic.objectForKey(value)!)
                self.selectIndexPaths.addObject(false)
            }
            self.tableView.reloadData()
            }) { (dic) in
                
        }
    }
    
    func lineLabel(frame:CGRect) -> UILabel{
        let lineLabel = UILabel(frame: frame)
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        return lineLabel
    }
    
    func setUpTableView(){
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.hideExcessLine(tableView)
        self.tableView.separatorStyle = .None
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }
    
    func setUpNavigationItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navigationbar_back")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(ReportViewController.leftItemPress))
    }
    
    func leftItemPress(){
        let viewControllers:NSArray = (self.navigationController?.viewControllers)!
        self.navigationController?.popToViewController(viewControllers.objectAtIndex(1) as! UIViewController, animated: true)
    }
    
    func reportBtnPress(sender:UIBarButtonItem) {
        
        for index in 0...reportArray.count - 1 {
            if self.selectIndexPaths[index] as! Bool  {
                reject_type = self.reportKeys[index] as! String
            }
        }
        
        if reject_type == "0" && reject_reson == "" {
            UITools.showMessageToView(self.view, message: "请填写原因", autoHide: true)
            return
        }
        
       viewModel.switchOrderStatus(orderModel.order_id, status: changeOrderStatus, rejectType: reject_type, rejectReason: textView.text, succeccBlock: { (dic) in
        if self.reloadOrderStatusChang != nil{
            self.reloadOrderStatusChang()
            self.navigationController?.popViewControllerAnimated(true)

        }
        }) { (dic) in
            UITools.showMessageToView(self.view, message: (dic as! NSDictionary).objectForKey("error") as! String, autoHide: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension OrderCancelRejectViewController : UITableViewDelegate {
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  selectIndexPaths[indexPath.row] as! Bool{
            selectIndexPaths[indexPath.row] = false
        }else{
            for index in 0...selectIndexPaths.count - 1 {
                if index == indexPath.row {
                    selectIndexPaths[index] = true
                }else{
                    selectIndexPaths[index] = false
                }
            }
            
        }
        for row in 0...reportArray.count - 1 {
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: row, inSection: 0)], withRowAnimation: .Automatic)
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}

extension OrderCancelRejectViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == reportArray.count {
            let cellIdf = "OrderCanCelIdentifierText"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdf)
            if  cell == nil {
                cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellIdf)
            }else{
                while cell?.contentView.subviews.last != nil {
                    cell?.contentView.subviews.last?.removeFromSuperview()
                }
            }
            textView = UITextView(frame: CGRectMake(15, 20, ScreenWidth - 40, 100))
            textView.font = LoginCodeLabelFont
            textView.placeholder = "添加拒绝说明，请您礼貌的拒绝的对方，展现您的绅士魅力"
            textView.delegate = self
            textView.text = reject_reson
            textView.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
            cell?.contentView.addSubview(textView)
            return cell!
        }
        let cellIdf = "OrderCanCelIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdf)
        if  cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellIdf)
        }else{
            while cell?.contentView.subviews.last != nil {
                cell?.contentView.subviews.last?.removeFromSuperview()
            }
        }
        let checkImage = UIImageView()
        checkImage.image = UIImage.init(named: "report_select")
        checkImage.frame = CGRectMake(ScreenWidth - 45, 15, 19, 19)
        cell?.contentView.addSubview(checkImage)
        if selectIndexPaths[indexPath.row] as! Bool {
            checkImage.hidden = false
            cell?.textLabel?.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        }else{
            checkImage.hidden = true
            cell?.textLabel?.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        }
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        cell?.contentView.addSubview(lineLabel)
        lineLabel.snp_makeConstraints { (make) in
            make.left.equalTo((cell?.contentView.snp_left)!).offset(15)
            make.right.equalTo((cell?.contentView.snp_right)!).offset(-20)
            make.bottom.equalTo((cell?.contentView.snp_bottom)!).offset(0)
            make.height.equalTo(0.5)
        }
        cell?.textLabel?.text = reportArray[indexPath.row] as? String
        cell?.textLabel?.font = LoginCodeLabelFont
        cell?.selectionStyle = .None
        cell?.tag = Int(reportKeys[indexPath.row] as! String)!
        return cell!
    }
}

extension OrderCancelRejectViewController : UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        self.reject_reson = textView.text
        return true
    }
}

