//
//  OrderCancelViewController.swift
//  Meet
//
//  Created by Zhang on 8/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderCancelViewController: BaseOrderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updataConstraints()
        bottomBtn.isHidden = true
        
        self.talKingDataPageName = "Order-OrderList-Cancel"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func configCell(cell:CancelInfoTableViewCell, index:NSIndexPath) {
//        cell.setUpData("\((orderModel.order_user_info?.real_name)!) 因\((orderModel.reject_type_desc))", resonDetail: "\((orderModel.reject_reason))")
//    }
//    
//    //MARK:父类方法重写
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 107
//        }else if indexPath.row == 1 {
//            return tableView.fd_heightForCellWithIdentifier("CancelInfoTableViewCell", configuration: { (cell) in
//                self.configCell((cell as! CancelInfoTableViewCell), index: indexPath)
//            }) + 10
//        }else if indexPath.row == 2{
//            return tableView.fd_heightForCellWithIdentifier("AppointMentTableViewCell", configuration: { (cell) in
//                self.configAppointThemeTypeCell((cell as! AppointMentTableViewCell), indexPath: indexPath)
//            })
//        }else if indexPath.row == 3 {
//            return 320
//        }else{
//            return 129
//        }
//    }
//    
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCellWithIdentifier("OrderFlowTableViewCell", forIndexPath: indexPath) as! OrderFlowTableViewCell
//            cell.setData((self.orderModel.status?.status_code)!, statusType: (self.orderModel.status?.status_type)!)
//            cell.selectionStyle = .None
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCellWithIdentifier("CancelInfoTableViewCell", forIndexPath: indexPath) as! CancelInfoTableViewCell
//            self.configCell(cell, index: indexPath)
//            cell.selectionStyle = .None
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCellWithIdentifier("AppointMentTableViewCell", forIndexPath: indexPath) as! AppointMentTableViewCell
//            self.configAppointThemeTypeCell(cell, indexPath: indexPath)
//            cell.selectionStyle = .None
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCellWithIdentifier("MeetOrderInfoTableViewCell", forIndexPath: indexPath) as! MeetOrderInfoTableViewCell
//            cell.setData(orderModel, type: .Cancel)
//            cell.selectionStyle = .None
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCellWithIdentifier("OrderCancelTableViewCell", forIndexPath: indexPath) as! OrderCancelTableViewCell
//            cell.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
//            cell.setButtonTitle("反馈客服", type: .Cancel)
//            cell.cancelBtnClickclouse = { _ in
//                
//            }
//            return cell
//        }
//    }
}
