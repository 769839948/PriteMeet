//
//  OrderCancelRejectViewController.swift
//  Meet
//
//  Created by Zhang on 8/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

enum CancelType {
    case cancel
    case reject
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
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(ReportViewController.reportBtnPress(_:)))
        self.navigationController?.navigationBar.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
        self.setUpTableView()
        self.setUpNavigationItem()
        self.fd_prefersNavigationBarHidden = false
        self.talKingDataPageName = "Home-Detail-Cancel&Reject"
        self.view.addSubview(self.lineLabel(CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.5)))
        self.setUpData()
        // Do any additional setup after loading the view.
    }
    
    func setUpData() {
        viewModel.orderCancelRejectReson({ (dic) in
            let cancelDic:NSDictionary!
            var sortedKeysAndValues:NSArray!
            let reason = dic! as [AnyHashable:Any] as NSDictionary
            if self.resonType == .cancel {
                cancelDic = (reason["cancel"] as! NSDictionary)
                sortedKeysAndValues = (cancelDic.allKeys as! [String]).sorted(by: >) as NSArray!
            }else{
                cancelDic = (reason["reject"] as! NSDictionary)
                sortedKeysAndValues = (cancelDic.allKeys as! [String]).sorted(by: >) as NSArray!
            }
            self.reportKeys.addObjects(from: sortedKeysAndValues as [AnyObject])
            for value in sortedKeysAndValues {
                self.reportArray.add(cancelDic[value]!)
                self.selectIndexPaths.add(false)
            }
            self.tableView.reloadData()
            }) { (dic) in
                
        }
    }
    
    func lineLabel(_ frame:CGRect) -> UILabel{
        let lineLabel = UILabel(frame: frame)
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        return lineLabel
    }
    
    func setUpTableView(){
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.hideExcessLine(tableView)
        tableView.keyboardDismissMode = .onDrag
        self.tableView.separatorStyle = .none
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }
    
    func setUpNavigationItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navigationbar_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(ReportViewController.leftItemPress))
    }
    
    func leftItemPress(){
        let viewControllers:NSArray = (self.navigationController?.viewControllers)! as NSArray
        _ = _ = self.navigationController?.popToViewController(viewControllers.object(at: 1) as! UIViewController, animated: true)
    }
    
    func reportBtnPress(_ sender:UIBarButtonItem) {
        
        for index in 0...reportArray.count - 1 {
            if self.selectIndexPaths[index] as! Bool  {
                reject_type = self.reportKeys[index] as! String
            }
        }
        
        var rejectType = ""
        var rejectReson = ""
        
        if reject_type == "0"{
            if self.resonType == .cancel {
                rejectType = "请填写取消原因哦"
            }else{
                rejectType = "请填写拒绝原因哦"
            }
            MainThreadAlertShow(rejectType, view: self.view)
            return
        }
        if reject_reson == "" {
            if self.resonType == .cancel {
                rejectReson = "请填写取消理由哦"
            }else{
                rejectReson = "请填写拒绝理由哦"
            }
            MainThreadAlertShow(rejectReson, view: self.view)
            return
        }
       viewModel.switchOrderStatus(orderModel.order_id, status: changeOrderStatus, rejectType: reject_type, rejectReason: textView.text, succeccBlock: { (dic) in
            if self.reloadOrderStatusChang != nil{
                self.reloadOrderStatusChang()
                NotificationCenter.default.post(name: Notification.Name(rawValue: ReloadOrderCollectionView), object: self.changeOrderStatus)
                _ = self.navigationController?.popViewController(animated: true)
            }

        }) { (dic) in
            MainThreadAlertShow((dic! as [AnyHashable:Any]  as NSDictionary).object(forKey: "error") as! String, view: self.view)
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
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row <= reportArray.count - 1 {
            if  selectIndexPaths[(indexPath as NSIndexPath).row] as! Bool{
                selectIndexPaths[(indexPath as NSIndexPath).row] = false
            }else{
                for index in 0...selectIndexPaths.count - 1 {
                    if index == (indexPath as NSIndexPath).row {
                        selectIndexPaths[index] = true
                    }else{
                        selectIndexPaths[index] = false
                    }
                }
                
            }
            for row in 0...reportArray.count - 1 {
                self.tableView.reloadRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
            }
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == reportArray.count {
            return 200
        }
        return 50
    }
}

extension OrderCancelRejectViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == reportArray.count {
            let cellIdf = "OrderCanCelIdentifierText"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdf)
            if  cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdf)
            }else{
                while cell?.contentView.subviews.last != nil {
                    cell?.contentView.subviews.last?.removeFromSuperview()
                }
            }
            textView = UITextView(frame: CGRect(x: 10, y: 20, width: ScreenWidth - 40, height: 200))
            textView.font = LoginCodeLabelFont
            textView.placeholderColor = UIColor.init(hexString: PlaceholderTextViewColor)
            if self.resonType == .cancel {
                textView.placeholder = (PlaceholderText.shareInstance().appDic as NSDictionary).object(forKey: "1000004") as! String

            }else {
                textView.placeholder = (PlaceholderText.shareInstance().appDic as NSDictionary).object(forKey: "1000005") as! String

            }
            textView.returnKeyType = .done
            textView.delegate = self
            textView.text = reject_reson
            textView.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            cell?.contentView.addSubview(textView)
            return cell!
        }
        let cellIdf = "OrderCanCelIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdf)
        if  cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdf)
        }else{
            while cell?.contentView.subviews.last != nil {
                cell?.contentView.subviews.last?.removeFromSuperview()
            }
        }
        let checkImage = UIImageView()
        checkImage.image = UIImage.init(named: "report_select")
        checkImage.frame = CGRect(x: ScreenWidth - 45, y: 15, width: 19, height: 19)
        cell?.contentView.addSubview(checkImage)
        if selectIndexPaths[(indexPath as NSIndexPath).row] as! Bool {
            checkImage.isHidden = false
            cell?.textLabel?.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        }else{
            checkImage.isHidden = true
            cell?.textLabel?.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        }
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        cell?.contentView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo((cell?.contentView.snp.left)!).offset(15)
            make.right.equalTo((cell?.contentView.snp.right)!).offset(-20)
            make.bottom.equalTo((cell?.contentView.snp.bottom)!).offset(0)
            make.height.equalTo(0.5)
        }
        cell?.textLabel?.text = reportArray[(indexPath as NSIndexPath).row] as? String
        cell?.textLabel?.font = LoginCodeLabelFont
        cell?.selectionStyle = .none
        cell?.tag = Int(reportKeys[(indexPath as NSIndexPath).row] as! String)!
        return cell!
    }
    
}

extension OrderCancelRejectViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.reject_reson = textView.text
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.endEditing(true)
    }
}

