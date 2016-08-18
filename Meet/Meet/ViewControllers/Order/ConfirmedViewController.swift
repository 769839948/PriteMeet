//
//  ConfirmedViewController.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class ConfirmedViewController: BaseOrderViewController {

    var isAppliViewPush:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeBottomBtnTitle()

        self.talKingDataPageName = "Order-OrderList-Confirm"

        // Do any additional setup after loading the view.
    }
    
    override func leftBarPress(sender:UIBarButtonItem) {
        if isAppliViewPush {
            let viewControllers:NSArray = (self.navigationController?.viewControllers)!
            self.navigationController?.popToViewController(viewControllers.objectAtIndex(1) as! UIViewController, animated: true)
        }else{
            self.navigationController?.popViewControllerAnimated(true)

        }
    }

    
//    override func cancelClick(){
//        let alertControl = UIAlertController(title: "确定要取消与\((orderModel.order_user_info?.real_name)!)的约见吗", message: "取消约见后预约将自动关闭\n如需帮助请联系客服电话 \(UserDefaultsGetSynchronize("customer_service_number")) 客服微信Meetjun1", preferredStyle: .Alert)
//        let cancelAction = UIAlertAction(title: "稍后决定", style: .Cancel) { (cancel) in
//            
//        }
//        let rejectAction = UIAlertAction(title: "取消约见", style: .Destructive) { (reportAction) in
//            let cancelView = OrderCancelRejectViewController()
//            cancelView.title = "取消原因说明"
//            cancelView.resonType = .Cancel
//            cancelView.orderModel = self.orderModel
//            if self.orderModel.status?.status_code == "1" {
//                if self.orderModel.status?.status_type == "apply_order"{
//                    cancelView.changeOrderStatus = "2"
//                }else{
//                    cancelView.changeOrderStatus = "3"
//                }
//                self.navigationController?.pushViewController(cancelView, animated: true)
//            }else if self.orderModel.status?.status_code == "4" {
//                if self.orderModel.status?.status_type == "apply_order"{
//                    cancelView.changeOrderStatus = "12"
//                }else{
//                    cancelView.changeOrderStatus = "13"
//                }
//            }else if self.orderModel.status?.status_code == "6" {
//                if self.orderModel.status?.status_type == "apply_order"{
//                    cancelView.changeOrderStatus = "7"
//                }else{
//                    cancelView.changeOrderStatus = "8"
//                }
//            }
//            self.navigationController?.pushViewController(cancelView, animated: true)
//        }
//        
//        alertControl.addAction(cancelAction)
//        alertControl.addAction(rejectAction)
//        self.presentViewController(alertControl, animated: true) {
//            
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:父类方法重写
    override func bottomPress(sender: UIButton) {
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
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if indexPath.row == 3 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("OrderCancelTableViewCell", forIndexPath: indexPath) as! OrderCancelTableViewCell
//            cell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
//            cell.selectionStyle = .None
//            cell.setButtonTitle("取消约见", type: .Normal)
//            cell.cancelBtnClickclouse = {
//                self.cancelClick()
//            }
//            return cell
//        }else{
//            return cellIndexPath(self.tableViewArray[indexPath.row], indexPath: indexPath, tableView: tableView)
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


