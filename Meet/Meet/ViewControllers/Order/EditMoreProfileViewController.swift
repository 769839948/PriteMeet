//
//  EditMoreProfileViewController.swift
//  Meet
//
//  Created by Zhang on 7/21/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class EditMoreProfileViewController: UIViewController {
    
    let viewModel = UserInfoViewModel()
    
    var aliPayButton:UIButton!
    var weCharPayButton:UIButton!
    var changeBtn:UIButton!
    
    var imageArray:NSMutableArray!
    var changeImageArray:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpPayBtn()
        imageArray = NSMutableArray()
        imageArray.addObject(UIImage.init(color: UIColor.blackColor(), size: CGSizeMake(100, 100)))
        imageArray.addObject(UIImage.init(color: UIColor.blueColor(), size: CGSizeMake(100, 100)))
        
        
        changeImageArray = NSMutableArray()
        changeImageArray.addObject(UIImage.init(color: UIColor.brownColor(), size: CGSizeMake(100, 100)))
        changeImageArray.addObject(UIImage.init(color: UIColor.greenColor(), size: CGSizeMake(100, 100)))
        // Do any additional setup after loading the view.
    }

    func setUpPayBtn() {
        aliPayButton = UIButton(type: UIButtonType.Custom)
        aliPayButton.frame = CGRectMake(0, 100, 100, 50)
//        aliPayButton.addTarget(self, action: #selector(PayViewController.payBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        aliPayButton.setTitle("Alipay", forState: UIControlState.Normal)
        aliPayButton.backgroundColor = UIColor.redColor()
        self.view.addSubview(aliPayButton)
        
        weCharPayButton = UIButton(type: UIButtonType.Custom)
        weCharPayButton.frame = CGRectMake(200, 100, 100, 50)
        weCharPayButton.setTitle("weChatPay", forState: UIControlState.Normal)
//        weCharPayButton.addTarget(self, action: #selector(PayViewController.weChatPay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        weCharPayButton.backgroundColor = UIColor.redColor()
        self.view.addSubview(weCharPayButton)
        
        changeBtn = UIButton(type: UIButtonType.Custom)
        changeBtn.frame = CGRectMake(200, 200, 100, 50)
        changeBtn.setTitle("weChatPay", forState: UIControlState.Normal)
        changeBtn.addTarget(self, action: #selector(EditMoreProfileViewController.changeMoreProfile(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        changeBtn.backgroundColor = UIColor.redColor()
        self.view.addSubview(changeBtn)
    }
    
    func payBtn(sender:UIButton){
        let image = UIImage.init(color: UIColor.redColor(), size: CGSizeMake(ScreenWidth, 255))
        viewModel.uploadCoverPhoto(image, success: { (dic) in
            
            }, fail: { (dic) in
                
            }) { (msg) in
        }
    }
    
    func weChatPay(sender:UIButton){
        viewModel.uploadMoreProfile(imageArray, title: "这是一个测试条件", content: "来一个更多的内容", success: { (dic) in
            
            }) { (dic) in
                
        }
    }
    
    func changeMoreProfile(sender:UIButton) {
        viewModel.changeMoreProfile(changeImageArray, moreProfileId: "76", title: "测试修改", content: "测试修改内容", success: { (dic) in
            
            }) { (dic) in
                
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
