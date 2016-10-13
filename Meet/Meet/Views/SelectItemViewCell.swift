//
//  SelectItemViewCell.swift
//  Meet
//
//  Created by Zhang on 19/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
enum TitleLabelType{
    case Select
    case UnSelect
}

class SelectItemViewCell: UIView {
    
    var titleLabel:UILabel!
    
    init(frame: CGRect, title:String) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = FilterViewSelectItemFont!
        titleLabel.layer.cornerRadius = 15.0
        titleLabel.layer.masksToBounds = true
        self.addSubview(titleLabel)
    }
    
    func changeTitleLabelType(_ type:TitleLabelType){
        switch type {
        case TitleLabelType.Select:
            titleLabel.backgroundColor = UIColor.init(hexString: HomeDetailViewNameColor)
            titleLabel.textColor = UIColor.white
        default:
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
