//
//  ZDQFlowViewItem.swift
//  TestFlowView
//
//  Created by Zhang on 8/2/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

enum ZDQFlowViewItemType {
    case itemSelect
    case itemUnSelect
    case itemWaitSelect
    case itemCancel
    case itemNext
    case itemCancelDone
}

class ZDQFlowViewItem: UIView {

    var titleLabel:UILabel!
    var imageView:UIImageView!
    var itemType:ZDQFlowViewItemType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.frame = CGRect(x: 8, y: 0, width: 29, height: 29)
        self.addSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 11.0)
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: -6, y: imageView.frame.maxY + 6, width: 57, height: 16)
        self.addSubview(titleLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ title:String, type:ZDQFlowViewItemType){
        itemType = type
        switch type {
        case .itemSelect:
            imageView.image = UIImage.init(named: "item_select")
            titleLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        case .itemUnSelect:
            imageView.image = UIImage.init(named: "item_unselect")
            titleLabel.textColor = UIColor.init(hexString: OrderApplyMeetTitleColor)
        case .itemWaitSelect:
            imageView.image = UIImage.init(named: "item_wait_select")
            titleLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        case .itemNext:
            imageView.image = UIImage.init(named: "item_next")
            titleLabel.textColor = UIColor.init(hexString: OrderApplyMeetTitleColor)
        case .itemCancelDone:
            imageView.image = UIImage.init(named: "item_unselect")
            titleLabel.textColor = UIColor.init(hexString: OrderApplyMeetTitleColor)
        default:
            imageView.image = UIImage.init(named: "item_cancel")
            titleLabel.textColor = UIColor.init(hexString: OrderFlowTitleCnacel)
        }
        titleLabel.text = title
    }
}
