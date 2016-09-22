//
//  ImageSplachView.swift
//  Meet
//
//  Created by Zhang on 22/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//


import UIKit

let imageWidthAndHeight:CGFloat = ScreenWidth - 50
let SplashViewHeight:CGFloat = ScreenWidth - 50

class ImageSplachView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        let myRect = CGRect.init(x: (ScreenWidth - imageWidthAndHeight)/2, y: (SplashViewHeight - imageWidthAndHeight)/2, width: imageWidthAndHeight, height: imageWidthAndHeight)
        let radius = myRect.size.width / 2
        let path = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth), cornerRadius: 0)
        let circlePath = UIBezierPath.init(roundedRect: CGRect(x: (ScreenWidth - imageWidthAndHeight)/2, y: (ScreenWidth - imageWidthAndHeight)/2, width: imageWidthAndHeight, height: imageWidthAndHeight), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.white.cgColor
        fillLayer.opacity = 0.8
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(fillLayer)
    }
    
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let x = abs(point.x - ScreenWidth / 2)
        let y = abs(point.y - ScreenWidth / 2)
        if (x * x + y * y) < (SplashViewHeight / 2) * (SplashViewHeight / 2) {
            return false
        }else{
            return true
        }
    }

}
