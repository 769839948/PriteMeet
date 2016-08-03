//
//  AppointmentCell.swift
//  Meet
//
//  Created by Zhang on 8/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class AppointmentCell: UICollectionViewCell {
    
    var titleLable:UILabel!
    var isHeightCaculated:Bool = false
    var didSetupConstraints:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLable = UILabel()
        titleLable.frame = frame
        titleLable.font = OrderAppointThemeTypeFont
        titleLable.textAlignment = .Center
        titleLable.textColor = UIColor.whiteColor()
        self.contentView.addSubview(titleLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillCellWidthFeed(text:String){
        self.titleLable.text = text
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !self.isHeightCaculated {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            let size = self.contentView.systemLayoutSizeFittingSize(layoutAttributes.size)
            var newSize:CGRect = layoutAttributes.frame
            newSize.size.width = size.width
            newSize.size.height = size.height
            self.isHeightCaculated  = true
        }
        return layoutAttributes
    }
}
