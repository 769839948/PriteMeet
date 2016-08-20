//
//  PayCompleteViewController.swift
//  Meet
//
//  Created by Zhang on 8/11/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

typealias PayCompleteClouse = () -> Void

class PayCompleteViewController: UIViewController {

    @IBOutlet weak var orderid: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var muchLabel: UILabel!
    @IBOutlet weak var lookforOrder: UIButton!

    var orderModel:OrderModel!
    let viewModel = OrderViewModel()
    
    var payCompleteClouse:PayCompleteClouse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpData()
        
        self.setUpNavigaitonItem()
        self.talKingDataPageName = "Order-OrderList-PayComplete"
        
        // Do any additional setup after loading the view.
    }
    
    func setUpNavigaitonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navigationbar_back")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(PayCompleteViewController.leftBarItemClick(_:)))
    }
    
    func leftBarItemClick(sender:UIBarButtonItem) {
        if self.payCompleteClouse != nil  {
            self.payCompleteClouse()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func setUpData() {
//        orderid.text = orderModel.order_id
//        var time = orderModel.created_at
//        time = time.stringByReplacingOccurrencesOfString("T", withString: " ")
//        time = time.stringByReplacingOccurrencesOfString("Z", withString: "")
//        createTime.text = time
//        muchLabel.text = "RMB \(orderModel.fee)"
        lookforOrder.layer.cornerRadius = 24.0
        lookforOrder.layer.masksToBounds = true
        lookforOrder.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeViewDetailMeetButtonBack), size: CGSizeMake(180, 45)), forState: .Normal)
        lookforOrder.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeViewDetailMeetButtonHightBack), size: CGSizeMake(180, 45)), forState: .Highlighted)
    }
    
    @IBAction func lookforOrderClick(sender: UIButton) {
        if self.payCompleteClouse != nil  {
            self.payCompleteClouse()
            self.navigationController?.popViewControllerAnimated(true)
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
