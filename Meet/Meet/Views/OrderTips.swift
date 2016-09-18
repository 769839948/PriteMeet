//
//  OrderTips.swift
//  Meet
//
//  Created by Zhang on 8/19/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


let TipsBackWidth:CGFloat = 290
let TipsBackHeight:CGFloat = 380

let paragraphSpace:CGFloat = 15

class TipsLabel : UIView {
    init(frame:CGRect, text:String) {
        super.init(frame: frame)
        let label = UILabel(frame: frame)
        let height = text.heightWithConstrainedWidth(frame.size.width - 13, font: OrderAppointThemeIntroudFont!)
        label.frame = CGRect(x: frame.origin.x + 13, y: 0, width: frame.size.width - 13, height: height)
        label.font = OrderAppointThemeIntroudFont
        label.textColor = UIColor.init(hexString: OrderTipsLabelColor)
        label.numberOfLines = 0
        label.text = text
        self.addSubview(label)
        
        let paragraph = UILabel(frame: CGRect(x: 0,y: 7,width: 5,height: 5))
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
    
    init(frame:CGRect, tips:[String]) {
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

    func setUpTipsView(_ tips:[String]) {
        tipsViewBack = UIView()
        tipsViewBack.backgroundColor = UIColor.white
        tipsViewBack.frame = CGRect(x: (ScreenWidth - TipsBackWidth) / 2, y: (ScreenHeight - TipsBackHeight) / 2, width: TipsBackWidth, height: TipsBackHeight)
        tipsViewBack.clipsToBounds = true
        tipsViewBack.layer.cornerRadius = 10
        self.addSubview(tipsViewBack)
        
        
        let image1 = UIImage.init(named: "splash_image2")
        let imageView1 = UIImageView(frame: CGRect(x: 96, y: 135, width: (image1?.size.width)!, height: (image1?.size.height)!))
        imageView1.image = image1
        tipsViewBack.addSubview(imageView1)
        
        let image2 = UIImage.init(named: "splash_image4")
        let imageView2 = UIImageView(frame: CGRect(x: -173, y: 146, width: (image2?.size.width)!, height: (image2?.size.height)!))
        imageView2.image = image2
        tipsViewBack.addSubview(imageView2)


        let image3 = UIImage.init(named: "splash_image1")
        let imageView3 = UIImageView(frame: CGRect(x: 90, y: -82, width: (image3?.size.width)!, height: (image3?.size.height)!))
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
        
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setImage(UIImage.init(named: "login_dismiss"), for: UIControlState())
        rightBtn.addTarget(self, action: #selector(OrderTips.dismissView), for: .touchUpInside)
        tipsViewBack.addSubview(rightBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tipsViewBack.snp.top).offset(44)
            make.centerX.equalTo(tipsViewBack.snp.centerX).offset(0)
            make.bottom.equalTo(tipsViewBack.snp.bottom).offset(-312)
        }
        
        tipsView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.left.equalTo(tipsViewBack.snp.left).offset(22)
            make.right.equalTo(tipsViewBack.snp.right).offset(-22)
            make.bottom.equalTo(tipsViewBack.snp.bottom).offset(-50)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(tipsViewBack.snp.right).offset(-10)
            make.top.equalTo(tipsViewBack.snp.top).offset(9)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.setUpData(tips)
        
    }
    
    func setUpData(_ tips:[String]) {
        var floatHeight:CGFloat = 0
        for index in 0...tips.count - 1 {
            let tip = TipsLabel(frame: CGRect(x: 0, y: floatHeight, width: tipsViewBack.frame.size.width - 62, height: 0), text: tips[index])
            floatHeight = tip.frame.maxY + paragraphSpace
            tipsView.addSubview(tip)
            
            if index == tips.count - 1 {
                if floatHeight > tipsView.frame.size.height {
                    tipsView.contentSize = CGSize(width: tipsView.frame.size.width, height: floatHeight)
                }else{
                    tipsView.isScrollEnabled = false
                }
            }
        }
        
    }
    
    func dismissView() {
        self.removeFromSuperview()
    }
    
}

extension OrderTips : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.frame.height < ScreenHeight{
            return false
        }
        return true
    }
}
