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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderid.text = orderModel.order_id
        createTime.text = orderModel.created_at
        muchLabel.text = "RMB 50.00"
        lookforOrder.layer.cornerRadius = 24.0
        self.setNavigationItemBack()
        // Do any additional setup after loading the view.
    }
    @IBAction func lookforOrderClick(sender: UIButton) {
        
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
