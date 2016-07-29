//
//  SplashView.swift
//  Meet
//
//  Created by Zhang on 7/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SnapKit
import pop

class SplashView: UIView {

    var logoImage:UIImageView!
    var imageView:UIImageView!
    var imageView1:UIImageView!
    var imageView2:UIImageView!
    var imageView3:UIImageView!
    var logonLabel:UILabel!
    
    var backView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()

        
        backView = UIView()
        self.addSubview(backView)
        
        backView.snp_makeConstraints { (make) in
             make.top.equalTo(self.snp_top).offset(0)
             make.left.equalTo(self.snp_left).offset(0)
             make.right.equalTo(self.snp_right).offset(0)
             make.bottom.equalTo(self.snp_bottom).offset(0)
        }
        
        imageView = UIImageView()
        backView.addSubview(imageView)
        imageView.image = UIImage.init(named: "splash_image1")
        
        
        imageView1 = UIImageView()
        backView.addSubview(imageView1)
        imageView1.image = UIImage.init(named: "splash_image2")
        
        
        imageView2 = UIImageView()
        backView.addSubview(imageView2)
        imageView2.image = UIImage.init(named: "splash_image3")
        
        
        imageView3 = UIImageView()
        imageView3.image = UIImage.init(named: "splash_image4")
        backView.addSubview(imageView3)

        imageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.backView.snp_top).offset(17)
            make.right.equalTo(self.backView.snp_right).offset(69)
            make.bottom.equalTo(self.imageView1.snp_top).offset(48)
            make.size.equalTo(CGSizeMake(202, 166))
        }
        
        
        imageView1.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.backView.snp_bottom).offset(-143)
            make.right.equalTo(self.backView.snp_right).offset(74)
            make.size.equalTo(CGSizeMake(268, 345))
        }
        
        
        imageView2.snp_makeConstraints { (make) in
            make.top.equalTo(self.backView.snp_top).offset(125)
            make.left.equalTo(self.backView.snp_left).offset(74)
            make.left.equalTo(90)
            make.size.equalTo(CGSizeMake(74, 108))
        }
        
        imageView3.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.snp_bottom).offset(-98)
            make.left.equalTo(self.snp_left).offset(-148)
            make.size.equalTo(CGSizeMake(250, 290))
        }
        
        logonLabel = UILabel.init()
        logonLabel.text = "© 2016 MEET. ALL RIGHTS RESERVED."
        logonLabel.font = SpashViewFont
        self.addSubview(logonLabel)
        logonLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(-60)
            make.height.equalTo(14)
        }
        
        logoImage = UIImageView.init()
        logoImage.layer.cornerRadius = 15.0
        logoImage.image = UIImage.init(named: "logo")
        self.addSubview(logoImage)
        logoImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.bottom.equalTo(self.logonLabel.snp_top).offset(-20)
            make.size.equalTo(CGSizeMake(60, 60))
        }
        
    }
    
    func startAnimation(){
        let popAnimation = POPDecayAnimation.init(propertyNamed: kPOPLayerPositionX)
        popAnimation.velocity = -77
        popAnimation.beginTime = CACurrentMediaTime()
        
        self.imageView.layer.pop_addAnimation(popAnimation, forKey: "popAnimation")
        
        let popAnimation1 = POPDecayAnimation.init(propertyNamed: kPOPLayerPositionX)
        popAnimation1.velocity = -67
        popAnimation1.beginTime = CACurrentMediaTime()
        self.imageView1.layer.pop_addAnimation(popAnimation1, forKey: "popAnimation")
        
        
        let popAnimationx = POPDecayAnimation.init(propertyNamed: kPOPLayerPositionX)
        popAnimationx.velocity = 77
        popAnimationx.beginTime = CACurrentMediaTime()
        self.imageView2.layer.pop_addAnimation(popAnimationx, forKey: "popAnimation")
        
        let popAnimationx1 = POPDecayAnimation.init(propertyNamed: kPOPLayerPositionX)
        popAnimationx1.velocity = 50
        popAnimationx1.beginTime = CACurrentMediaTime() 
        self.imageView3.layer.pop_addAnimation(popAnimationx1, forKey: "popAnimation")

    }
    
    func removeSplashView(){
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
