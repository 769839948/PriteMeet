//
//  CenterlabelView.swift
//  Meet
//
//  Created by Zhang on 6/20/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
    }
    
    
    func setUpCustomLabel(text:String, font:UIFont, textColor:UIColor, backColor:UIColor) -> CGSize{
        self.text = text
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backColor
        self.textAlignment = NSTextAlignment.Center
        let itemSize = self.sizeThatFits(self.frame.size)
        print("\(itemSize)")
        self.layer.cornerRadius = 2.0
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, itemSize.width + 20, 28)
        self.layer.masksToBounds = true
        return CGSizeMake(itemSize.width + 20, 28)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CenterlabelView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUpCustomLabelArray(titleArray:NSArray) -> CGFloat {
        var xOffset:CGFloat = 0
        var yOffset:CGFloat = 0
        var layoutItem:NSInteger = 0
        var allItemSize:CGFloat = 0
        var tempSize:CGFloat = 0
        var isScreenWidth = false
        for idx in 0...titleArray.count - 1 {
            if titleArray.count > 1 {
                let label = CustomLabel(frame: CGRectMake(0,0,0,0))
                let itemSize = label.setUpCustomLabel(titleArray[idx] as! String, font:UIFont.init(name: "PingFangSC-Light", size: 13.0)! , textColor: UIColor.whiteColor(), backColor: UIColor.blackColor())
                allItemSize = allItemSize + itemSize.width + 10
                if allItemSize > ScreenWidth - 20 {
                    allItemSize = allItemSize - itemSize.width - 10
                    tempSize = itemSize.width
                    isScreenWidth = true
                }else{
                    
                }
                
                if isScreenWidth || idx == titleArray.count - 1 {
                    xOffset = (ScreenWidth - allItemSize - 20 + 10)/2
                    for index in layoutItem...idx - 1 {
                        let label = CustomLabel(frame: CGRectMake(xOffset,yOffset,0,0))
                        let itemSize = label.setUpCustomLabel(titleArray[index] as! String, font:UIFont.init(name: "PingFangSC-Light", size: 13.0)! , textColor: UIColor.whiteColor(), backColor: UIColor.blackColor())
                        xOffset = xOffset + itemSize.width + 10
                        self.addSubview(label)
                    }
                    yOffset = yOffset + itemSize.height + 10
                    if idx == titleArray.count - 1 {
                        if !isScreenWidth {
                            yOffset = yOffset - itemSize.height - 10
                            let label = CustomLabel(frame: CGRectMake(xOffset,yOffset,0,0))
                            let itemSize = label.setUpCustomLabel(titleArray[idx] as! String, font:UIFont.init(name: "PingFangSC-Light", size: 13.0)! , textColor: UIColor.whiteColor(), backColor: UIColor.blackColor())
                            label.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height)
                            self.addSubview(label)
                        }else{
                            let label = CustomLabel(frame: CGRectMake(xOffset,yOffset,0,0))
                            let itemSize = label.setUpCustomLabel(titleArray[idx] as! String, font:UIFont.init(name: "PingFangSC-Light", size: 13.0)! , textColor: UIColor.whiteColor(), backColor: UIColor.blackColor())
                            label.frame = CGRectMake((ScreenWidth - itemSize.width - 20)/2, yOffset, itemSize.width, itemSize.height)
                            self.addSubview(label)
                        }
                        
                    }
                    
                    isScreenWidth = false
                    allItemSize = tempSize;
                    layoutItem = idx
                }
            }else{
                
            }
        }
        
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 90)
        return yOffset + 28;
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
