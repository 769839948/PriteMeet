//
//  AllMeetViewController.swift
//  Meet
//
//  Created by Zhang on 8/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class AllMeetViewController: BaseOrderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if orderModel.status?.status_code == "6" {
            bottomBtn.setTitle("确认双方已约见", forState: .Normal)
        }else if orderModel.status?.status_code == "1" {
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
        }else if orderModel.status?.status_code == "11" {
            bottomBtn.hidden = true
            self.updataConstraints()
        }
        // Do any additional setup after loading the view.
    }

    func cancelClick(){
        let alertControl = UIAlertController(title: "确定要取消\((orderModel.order_user_info?.real_name)!)的约见吗", message: "接受约见及对方付款后即可开始沟通见面\n取消约见后该预约将自动关闭", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "稍后决定", style: .Cancel) { (cancel) in
            
        }
        let rejectAction = UIAlertAction(title: "取消约见", style: .Default) { (reportAction) in
            
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
    
    //MARK:父类方法重写
    override func bottomPress(sender: UIButton) {
        let aletControl = UIAlertController.init(title: "确定双方已见面", message: "确认与 \(orderModel.order_user_info?.real_name) 见面后对方会收到见面完成的确认短信", preferredStyle: UIAlertControllerStyle.Alert)
        let cancleAction = UIAlertAction.init(title: "暂不", style: UIAlertActionStyle.Cancel, handler: { (canCel) in
            
        })
        let doneAction = UIAlertAction.init(title: "确认见面", style: UIAlertActionStyle.Default, handler: { (canCel) in
            if self.orderModel.status?.status_type == "apply_order" {
                self.changeShtatues("11")
            }else{
                self.changeShtatues("11")
            }
        })
        aletControl.addAction(cancleAction)
        aletControl.addAction(doneAction)
        self.presentViewController(aletControl, animated: true) {
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderCancelTableViewCell", forIndexPath: indexPath) as! OrderCancelTableViewCell
            cell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
            if orderModel.status?.status_code == "11" {
                cell.setButtonTitle("反馈客服", type: .Cancel)
            }else{
                cell.setButtonTitle("取消约见", type: .Normal)
            }
            cell.selectionStyle = .None
            cell.cancelBtnClickclouse = {
                self.cancelClick()
            }
            return cell
        }else{
            return cellIndexPath(self.tableViewArray[indexPath.row], indexPath: indexPath, tableView: tableView)
        }
    }
}
