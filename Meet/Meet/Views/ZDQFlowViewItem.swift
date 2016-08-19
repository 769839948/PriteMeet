//
//  ZDQFlowViewItem.swift
//  TestFlowView
//
//  Created by Zhang on 8/2/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

enum ZDQFlowViewItemType {
    case ItemSelect
    case ItemUnSelect
    case ItemWaitSelect
    case ItemCancel
    case ItemNext
    case ItemCancelDone
}

class ZDQFlowViewItem: UIView {

    var titleLabel:UILabel!
    var imageView:UIImageView!
    var itemType:ZDQFlowViewItemType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.frame = CGRectMake(8, 0, 29, 29)
        self.addSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(11.0)
        titleLabel.textAlignment = .Center
        titleLabel.frame = CGRectMake(-6, CGRectGetMaxY(imageView.frame) + 6, 57, 16)
        self.addSubview(titleLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(title:String, type:ZDQFlowViewItemType){
        itemType = type
        switch type {
        case .ItemSelect:
            imageView.image = UIImage.init(named: "item_select")
            titleLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        case .ItemUnSelect:
            imageView.image = UIImage.init(named: "item_unselect")
            titleLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelectColor)
        case .ItemWaitSelect:
            imageView.image = UIImage.init(named: "item_wait_select")
            titleLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        case .ItemNext:
            imageView.image = UIImage.init(named: "item_next")
            titleLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelectColor)
        case .ItemCancelDone:
            imageView.image = UIImage.init(named: "item_unselect")
            titleLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelectColor)
        default:
            imageView.image = UIImage.init(named: "item_cancel")
            titleLabel.textColor = UIColor.init(hexString: OrderFlowTitleCnacel)
        }
        titleLabel.text = title
    }
}
