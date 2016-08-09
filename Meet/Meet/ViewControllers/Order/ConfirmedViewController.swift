//
//  ConfirmedViewController.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class ConfirmedViewController: BaseOrderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.orderModel.status?.status_type == "receive_order" {
            bottomBtn.setTitle("待确认订单", forState: .Normal)
        }else{
            self.updataConstraints()
            bottomBtn.hidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:父类方法重写
    override func bottomPress(sender: UIButton) {
        viewModel.orderStatusOperation(orderModel.order_id, withHos: UserInfo.sharedInstance().uid, successBlock: { (dic) in
                if self.myClouse != nil {
                    self.myClouse(status:(self.orderModel.status?.order_status)!)
                }
                self.leftBarPress(self.navigationItem.leftBarButtonItem!)
            }, failBlock: { (dic) in
             UITools.showMessageToView(self.view, message: "确认失败", autoHide: true)
        })
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


