//
//  TextViewAutoHeight.swift
//  Meet
//
//  Created by Zhang on 8/13/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class TextViewAutoHeight: UITextView {

    //MARK: attributes
    
    var  maxHeight:CGFloat?
    var  heightConstraint:NSLayoutConstraint?
    
    //MARK: initialize
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUpInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpInit()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraint()
    }
    
    //MARK: private
    
    fileprivate func setUpInit() {
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.height {
                self.heightConstraint = constraint
                break;
            }
        }
        
    }
    
    fileprivate func setUpConstraint() {
        var finalContentSize:CGSize = self.contentSize
        finalContentSize.width  += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0
        finalContentSize.height += (self.textContainerInset.top  + self.textContainerInset.bottom) / 2.0
        
        fixTextViewHeigth(finalContentSize)
    }
    
    fileprivate func fixTextViewHeigth(_ finalContentSize:CGSize) {
        if let maxHeight = self.maxHeight {
            var  customContentSize = finalContentSize;
            
            customContentSize.height = min(customContentSize.height, CGFloat(maxHeight))
            
            self.heightConstraint?.constant = customContentSize.height;
            
            if finalContentSize.height <= self.frame.height {
                let textViewHeight = (self.frame.height - self.contentSize.height * self.zoomScale)/2.0
                
                self.contentOffset = CGPoint(x: 0, y: -(textViewHeight < 0.0 ? 0.0 : textViewHeight))
                
            }
        }
    }

}
