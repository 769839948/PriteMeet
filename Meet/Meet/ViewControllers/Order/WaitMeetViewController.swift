//
//  WaitMeetViewController.swift
//  Meet
//
//  Created by Zhang on 7/20/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class WaitMeetViewController: BaseOrderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeBottomBtnTitle()

        
        self.talKingDataPageName = "Order-OrderList-Meet"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func cancelClick(){
//        let alertControl = UIAlertController(title: "确定要取消与\((orderModel.order_user_info?.real_name)!)的约见吗", message: "取消约见后预约将自动关闭\n如需帮助请联系客服电话 \(UserDefaultsGetSynchronize("customer_service_number")) 客服微信Meetjun1", preferredStyle: .Alert)
//        let cancelAction = UIAlertAction(title: "稍后决定", style: .Cancel) { (cancel) in
//            
//        }
//        let rejectAction = UIAlertAction(title: "取消约见", style: .Default) { (reportAction) in
//            let cancelView = OrderCancelRejectViewController()
//            cancelView.title = "取消原因说明"
//            cancelView.resonType = .Cancel
//            cancelView.orderModel = self.orderModel
//            if self.orderModel.status?.status_type == "apply_order"{
//                cancelView.changeOrderStatus = "7"
//            }else{
//                cancelView.changeOrderStatus = "8"
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
    //MARK:父类方法重写
//    override func bottomPress(sender: UIButton) {
//        let alertControl = UIAlertController(title: "确定要双方已经见面", message: "确认与 \((orderModel.order_user_info?.real_name)!) 见面后\n对方会收到见面完成的确认短信", preferredStyle: .Alert)
//        let cancelAction = UIAlertAction(title: "暂不", style: .Cancel) { (cancel) in
//            
//        }
//        
//        let accpetAction = UIAlertAction(title: "确认见面", style: .Default) { (blackList) in
//            if self.orderModel.status?.status_type == "apply_order" {
//                self.changeShtatues("11")
//            }else{
//                self.changeShtatues("11")
//            }
//        }
//        
//        alertControl.addAction(cancelAction)
//        alertControl.addAction(accpetAction)
//        self.presentViewController(alertControl, animated: true) {
//            
//        }
//    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
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

}
