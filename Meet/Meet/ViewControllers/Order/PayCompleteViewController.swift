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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navigationbar_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(PayCompleteViewController.leftBarItemClick(_:)))
    }
    
    func leftBarItemClick(_ sender:UIBarButtonItem) {
        if self.payCompleteClouse != nil  {
            self.payCompleteClouse()
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setUpData() {
        orderid.text = orderModel.order_id
        var time = orderModel.created_at
        time = time.replacingOccurrences(of: "T", with: " ")
        time = time.replacingOccurrences(of: "Z", with: "")
        createTime.text = time
        muchLabel.text = "RMB \(orderModel.fee)"
        lookforOrder.layer.cornerRadius = 24.0
        lookforOrder.layer.masksToBounds = true
        lookforOrder.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeViewDetailMeetButtonBack), size: CGSize(width: 180, height: 45)), for: UIControlState())
        lookforOrder.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeViewDetailMeetButtonHightBack), size: CGSize(width: 180, height: 45)), for: .highlighted)
    }
    
    @IBAction func lookforOrderClick(_ sender: UIButton) {
        if self.payCompleteClouse != nil  {
            self.payCompleteClouse()
            _ = self.navigationController?.popViewController(animated: true)
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
