//
//  PayViewController.swift
//  Meet
//
//  Created by Zhang on 7/14/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {

    
    var weChatPayreq:PayReq!
    var aliPayurl:String!
    
    var aliPayButton:UIButton!
    var weCharPayButton:UIButton!
    
    var viewModel:OrderViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setNavigationItemBack()
        viewModel = OrderViewModel()
        self.weChatPayreq = PayReq()
//        let dic = [
//                "package": "Sign=WXPay",
//                "prepay_id": "wx20160719124527a5c605c4ec0221993384",
//                "timestamp": "1468903528",
//                "sign": "A7A535121DFA4A7A3FB3EF49DE3AB91F",
//                "appid": "wx49c4b6f590f83469",
//                "noncestr": "MZblh2tszy1TxrW98ejJ5domDaXwKpUc",
//                "partner_id": "1345816001"
//        ]
//        self.weChatPayreq = PayReq.mj_objectWithKeyValues(dic)
//        self.weChatPayreq.nonceStr = "UmzWG7dRCQdQOglCze7fyTxy3yHz772t"
//        self.weChatPayreq.package = "Sign=WXPay"
//        self.weChatPayreq.partnerId = "1345816001"
//        self.weChatPayreq.prepayId = "wx20160719144024512658e16a0514367232"
//        self.weChatPayreq.sign = "F8C21698D86A1CBF9A890BD06B107EF9"
//        let time:UInt32 = 1468910424
//        self.weChatPayreq.timeStamp = time
        self.loadPayInfo()
        self.setUpPayBtn()
        // Do any additional setup after loading the view.
    }
    
    func loadPayInfo(){
        viewModel.payOrder({ (dic) in
            let payDic = dic as NSDictionary
            self.aliPayurl = payDic.objectForKey("alipay") as! String
            let weChatDic = payDic["wxpay"] as! NSDictionary;
            self.weChatPayreq.nonceStr = weChatDic.objectForKey("noncestr") as! String
            self.weChatPayreq.package = weChatDic.objectForKey("package") as! String
            self.weChatPayreq.partnerId = weChatDic.objectForKey("partnerid") as! String
            self.weChatPayreq.prepayId = weChatDic.objectForKey("prepayid") as! String
            self.weChatPayreq.sign = weChatDic.objectForKey("sign") as! String
            let timeString = (weChatDic.objectForKey("timestamp") as! String)
            let time:UInt32 = UInt32(timeString)!
            self.weChatPayreq.timeStamp = time
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
        WXApi.sendReq(self.weChatPayreq)
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
