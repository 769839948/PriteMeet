//
//  WaitPayViewController.swift
//  Meet
//
//  Created by Zhang on 7/20/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class WaitPayViewController: BaseOrderViewController {

    var weChatPayreq:PayReq = PayReq()
    var aliPayurl:String!
    var payView:PayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.orderModel.status?.status_type == "receive_order" {
            bottomBtn.hidden = true
            self.updataConstraints()
        }else{
            bottomBtn.setTitle("立即支付 RMB \(orderModel.fee)", forState: .Normal)
        }
        self.loadPayInfo()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PayViewController.changePayStatues(_:)), name: WeiXinPayStatues, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PayViewController.changePayStatues(_:)), name: AliPayStatues, object: nil)
        // Do any additional setup after loading the view.
    }

    func cancelClick(){
        let alertControl = UIAlertController(title: "确定要取消\((orderModel.order_user_info?.real_name)!)的约见吗", message: "接受约见及对方付款后即可开始沟通见面\n取消约见后该预约将自动关闭", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "稍后决定", style: .Cancel) { (cancel) in
            
        }
        let rejectAction = UIAlertAction(title: "取消约见", style: .Default) { (reportAction) in
            let cancelView = OrderCancelRejectViewController()
            cancelView.title = "取消原因说明"
            cancelView.resonType = .Cancel
            cancelView.orderModel = self.orderModel
            if self.orderModel.status?.status_type == "apply_code"{
                cancelView.changeOrderStatus = "12"
            }else{
                cancelView.changeOrderStatus = "13"
            }
            self.navigationController?.pushViewController(cancelView, animated: true)
        }
        
        alertControl.addAction(cancelAction)
        alertControl.addAction(rejectAction)
        self.presentViewController(alertControl, animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        viewModel.switchOrderStatus(orderModel.order_id, status: "5", succeccBlock: { (dic) in
        let payCompleteVC = Stroyboard("Order", viewControllerId: "PayCompleteViewController") as! PayCompleteViewController
        payCompleteVC.orderModel = self.orderModel
        self.navigationController?.pushViewController(payCompleteVC, animated: true)
//        }) { (dic) in
//            
//        }
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WeiXinPayStatues, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AliPayStatues, object: nil)
    }
    
    //MARK:父类方法重写
    override func bottomPress(sender: UIButton) {
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderCancelTableViewCell", forIndexPath: indexPath) as! OrderCancelTableViewCell
            cell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
            cell.selectionStyle = .None
            cell.setButtonTitle("取消约见", type: .Normal)
            cell.cancelBtnClickclouse = {
                self.cancelClick()
            }
            return cell
        }else{
            return cellIndexPath(self.tableViewArray[indexPath.row], indexPath: indexPath, tableView: tableView)
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

}
