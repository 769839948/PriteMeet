//
//  PayCompleteViewController.swift
//  Meet
//
//  Created by Zhang on 8/11/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class PayCompleteViewController: UIViewController {

    @IBOutlet weak var orderid: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var muchLabel: UILabel!
    @IBOutlet weak var lookforOrder: UIButton!
    var orderModel:OrderModel!
    let viewModel = OrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderid.text = orderModel.order_id
        createTime.text = orderModel.created_at
        muchLabel.text = "RMB 50.00"
        lookforOrder.layer.cornerRadius = 24.0
        self.setNavigationItemBack()
        self.talKingDataPageName = "Order-OrderList-PayComplete"

        // Do any additional setup after loading the view.
    }
    @IBAction func lookforOrderClick(sender: UIButton) {
        self.viewModel.orderDetail(orderModel.order_id, successBlock: { (dic) in
            let orderModel = OrderModel.mj_objectWithKeyValues(dic)
            NSUserDefaults.standardUserDefaults().setObject(dic["customer_service_number"], forKey: "customer_service_number")
            let applyDetailView = ConfirmedViewController()
            applyDetailView.uid = (orderModel.order_user_info?.uid)!
            applyDetailView.orderModel = orderModel
            self.navigationController?.pushViewController(applyDetailView, animated: true)
            }, fialBlock: { (dic) in
                
        })
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
