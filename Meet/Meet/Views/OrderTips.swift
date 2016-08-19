//
//  OrderTips.swift
//  Meet
//
//  Created by Zhang on 8/19/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

let TipsBackWidth:CGFloat = 290
let TipsBackHeight:CGFloat = 380

let paragraphSpace:CGFloat = 15

class TipsLabel : UIView {
    init(frame:CGRect, text:String) {
        super.init(frame: frame)
        let label = UILabel(frame: frame)
        let height = text.heightWithConstrainedWidth(frame.size.width - 13, font: OrderAppointThemeIntroudFont!)
        label.frame = CGRectMake(frame.origin.x + 13, 0, frame.size.width - 13, height)
        label.font = OrderAppointThemeIntroudFont
        label.textColor = UIColor.init(hexString: OrderTipsLabelColor)
        label.numberOfLines = 0
        label.text = text
        self.addSubview(label)
        
        let paragraph = UILabel(frame: CGRectMake(0,7,5,5))
        paragraph.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        paragraph.layer.cornerRadius = 2.5
        paragraph.layer.masksToBounds = true
        self.addSubview(paragraph)
        
        var newFrame:CGRect = frame
        newFrame.size.height = height
        self.frame = newFrame
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class OrderTips: UIView {

    var tipsViewBack:UIView!
    var tipsView:UIScrollView!
    
    var tapGeture:UITapGestureRecognizer!
    
    init(frame:CGRect, tips:NSArray) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        tapGeture = UITapGestureRecognizer(target: self, action: #selector(OrderTips.dismissView))
        tapGeture.numberOfTapsRequired = 1
        tapGeture.numberOfTouchesRequired = 1
        tapGeture.delegate = self
        self.addGestureRecognizer(tapGeture)
        self.setUpTipsView(tips)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpTipsView(tips:NSArray) {
        tipsViewBack = UIView()
        tipsViewBack.backgroundColor = UIColor.whiteColor()
        tipsViewBack.frame = CGRectMake((ScreenWidth - TipsBackWidth) / 2, (ScreenHeight - TipsBackHeight) / 2, TipsBackWidth, TipsBackHeight)
        tipsViewBack.clipsToBounds = true
        tipsViewBack.layer.cornerRadius = 10
        self.addSubview(tipsViewBack)
        
        
        let image1 = UIImage.init(named: "splash_image2")
        let imageView1 = UIImageView(frame: CGRectMake(96, 135, (image1?.size.width)!, (image1?.size.height)!))
        imageView1.image = image1
        tipsViewBack.addSubview(imageView1)
        
        let image2 = UIImage.init(named: "splash_image4")
        let imageView2 = UIImageView(frame: CGRectMake(-173, 146, (image2?.size.width)!, (image2?.size.height)!))
        imageView2.image = image2
        tipsViewBack.addSubview(imageView2)


        let image3 = UIImage.init(named: "splash_image1")
        let imageView3 = UIImageView(frame: CGRectMake(90, -82, (image3?.size.width)!, (image3?.size.height)!))
        imageView3.image = image3
        tipsViewBack.addSubview(imageView3)
        
        let titleLabel = UILabel()
        titleLabel.font = OrderMeetTipTitleFont
        titleLabel.textColor = UIColor.init(hexString: OrderApplyMeetTitleColor)
        titleLabel.text = "约见贴士"
        tipsViewBack.addSubview(titleLabel)
        
        tipsView = UIScrollView()
        tipsView.showsVerticalScrollIndicator = false
        tipsViewBack.addSubview(tipsView)
        
        
        let rightBtn = UIButton(type: .Custom)
        rightBtn.setImage(UIImage.init(named: "login_dismiss"), forState: .Normal)
        rightBtn.addTarget(self, action: #selector(OrderTips.dismissView), forControlEvents: .TouchUpInside)
        tipsViewBack.addSubview(rightBtn)
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(tipsViewBack.snp_top).offset(44)
            make.centerX.equalTo(tipsViewBack.snp_centerX).offset(0)
            make.bottom.equalTo(tipsViewBack.snp_bottom).offset(-312)
        }
        
        tipsView.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(28)
            make.left.equalTo(tipsViewBack.snp_left).offset(22)
            make.right.equalTo(tipsViewBack.snp_right).offset(-22)
            make.bottom.equalTo(tipsViewBack.snp_bottom).offset(-50)
        }
        
        rightBtn.snp_makeConstraints { (make) in
            make.right.equalTo(tipsViewBack.snp_right).offset(-10)
            make.top.equalTo(tipsViewBack.snp_top).offset(9)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        
        self.setUpData(tips)
    }
    
    func setUpData(tips:NSArray) {
        var floatHeight:CGFloat = 0
        for index in 0...tips.count - 1 {
            let tip = TipsLabel(frame: CGRectMake(0, floatHeight, tipsViewBack.frame.size.width - 62, 0), text: tips[index] as! String)
            floatHeight = CGRectGetMaxY(tip.frame) + paragraphSpace
            tipsView.addSubview(tip)
            
            if index == tips.count - 1 {
                if floatHeight > tipsView.frame.size.height {
                    tipsView.contentSize = CGSizeMake(tipsView.frame.size.width, floatHeight)
                }else{
                    tipsView.scrollEnabled = false
                }
            }
        }
        
    }
    
    func dismissView() {
        self.removeFromSuperview()
    }
    
}

extension OrderTips : UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view?.frame.height < ScreenHeight{
            return false
        }
        return true
    }
}
