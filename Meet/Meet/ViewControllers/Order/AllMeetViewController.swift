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
                bottomBtn.setTitle("待确认订单", forState: .Normal)
            }else{
                self.updataConstraints()
                bottomBtn.hidden = true
            }
        }else if orderModel.status?.status_code == "4" {
            if self.orderModel.status?.status_type == "receive_order" {
                bottomBtn.hidden = true
                self.updataConstraints()
            }else{
                bottomBtn.setTitle("立即支付 RMB 50.00", forState: .Normal)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:父类方法重写
    override func bottomPress(sender: UIButton) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderCancelTableViewCell", forIndexPath: indexPath) as! OrderCancelTableViewCell
            cell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
            cell.selectionStyle = .None
            return cell
        }else{
            return cellIndexPath(self.tableViewArray[indexPath.row], indexPath: indexPath, tableView: tableView)
        }
    }
}
