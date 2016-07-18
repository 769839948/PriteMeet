//
//  PayViewController.swift
//  Meet
//
//  Created by Zhang on 7/14/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {

    
//    var weChatPayreq:PayReq!
    var aliPayurl:String!
    
    var aliPayButton:UIButton!
    var weCharPayButton:UIButton!
    
    var viewModel:OrderViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setNavigationItemBack()
        viewModel = OrderViewModel()
//        self.weChatPayreq = PayReq()
//        self.weChatPayreq.nonceStr = "11f5d7003eecac92f6b9ee83ce834d0f"
//        self.weChatPayreq.package = "Sign=WXPay"
//        self.weChatPayreq.partnerId = "1305176001"
//        self.weChatPayreq.prepayId = "wx20160714172337c1a249f4d30371936743"
//        self.weChatPayreq.sign = "498A5849D1784F01749D3237EE3BB96E"
//        let time:UInt32 = 1468488217
//        self.weChatPayreq.timeStamp = time
        self.loadPayInfo()
        self.setUpPayBtn()
        // Do any additional setup after loading the view.
    }
    
    func loadPayInfo(){
        viewModel.payOrder({ (dic) in
            let payDic = dic as NSDictionary
            self.aliPayurl = payDic.objectForKey("aliPayurl") as! String
//            self.weChatPayreq = PayReq.mj_objectWithKeyValues(payDic["weChatPay"])
            }, failBlock: { (dic) in
                
        })
    }
    
    func setUpPayBtn() {
        aliPayButton = UIButton(type: UIButtonType.Custom)
        aliPayButton.frame = CGRectMake(0, 100, 100, 50)
        aliPayButton.addTarget(self, action: #selector(PayViewController.payBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        aliPayButton.setTitle("Alipay", forState: UIControlState.Normal)
        aliPayButton.backgroundColor = UIColor.redColor()
        self.view.addSubview(aliPayButton)
        
        weCharPayButton = UIButton(type: UIButtonType.Custom)
        weCharPayButton.frame = CGRectMake(200, 100, 100, 50)
        weCharPayButton.setTitle("weChatPay", forState: UIControlState.Normal)
        weCharPayButton.addTarget(self, action: #selector(PayViewController.weChatPay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        weCharPayButton.backgroundColor = UIColor.redColor()
        self.view.addSubview(weCharPayButton)
    }
    
    func payBtn(sender:UIButton){
        AlipaySDK.defaultService().payOrder(self.aliPayurl, fromScheme: "MeetAlipay") { (resultDic) in
            print("\(resultDic)");
            
        }
    }
    
    func weChatPay(sender:UIButton){
//        WXApi.sendReq(self.weChatPayreq)
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
