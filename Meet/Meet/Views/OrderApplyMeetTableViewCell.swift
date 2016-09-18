//
//  OrderApplyMeetTableViewCell.swift
//  Meet
//
//  Created by Zhang on 8/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SnapKit

typealias OrderApplyMeetItem = (_ selectItem:NSInteger) -> Void

class OrderApplyMeetTableViewCell: UITableViewCell {
    
    var interestView: SetInviteCollectView!
    var flowLayout: EqualSpaceFlowLayout!
    
    var clourse:OrderApplyMeetItem!
    
    var didUpdateConstraints:Bool = false
    
    var titleLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.setUpView()
        // Initialization code
    }
    
    func setUpView(){
        titleLabel = UILabel()
        titleLabel.text = "选择约见形式"
        titleLabel.textColor = UIColor.init(hexString: OrderApplyMeetTitleColor)
        titleLabel.font = OrderApplyTitleFont
        self.contentView.addSubview(titleLabel)
        
        flowLayout = EqualSpaceFlowLayout()
        interestView = SetInviteCollectView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        interestView.delegate = interestView
        interestView.dataSource = interestView
        flowLayout.delegate = interestView;
        
        interestView.selectBlock = { row in
            if (self.clourse != nil) {
                self.clourse(row)
            }
        }
        
        self.contentView.addSubview(interestView)
        
        
    }
    
    func setData(_ array:NSArray, selectItems:NSArray){
        self.setUpView()        
        interestView.setCollectViewData(array as [AnyObject], andSelect: selectItems as [AnyObject])
        interestView.snp.makeConstraints{ (make) in
            make.height.equalTo(self.cellHeight(array))
        }
        self.updateConstraintsIfNeeded()
    }
    
    func cellHeight(_ interArray:NSArray) -> CGFloat{
        var yOffset:CGFloat = 30
        var allSizeWidth:CGFloat = 0
        for idx in 0...interArray.count - 1 {
            let itemSize = CGSize(width: self.cellWidth(interArray[idx] as! NSString), height: 30)
            allSizeWidth = allSizeWidth + itemSize.width + 10
            if allSizeWidth > ScreenWidth - 40 {
                yOffset = yOffset + 40
                allSizeWidth = 0;
            }
        }
        return yOffset
    }
    
    func cellWidth(_ itemString:NSString) -> CGFloat{
        var cellWidth:CGFloat = 0
        cellWidth = itemString.width(with: UIFont.systemFont(ofSize: 13), constrainedToHeight: 18)
        return cellWidth + 18;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateConstraints() {
        if !self.didUpdateConstraints {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.contentView.snp.top).offset(12)
                make.left.equalTo(self.contentView.snp.left).offset(20)
                make.right.equalTo(self.contentView.snp.right).offset(-20)
                make.bottom.equalTo(self.interestView.snp.top).offset(-24)
            }
            
            interestView.snp.makeConstraints { (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
                make.left.equalTo(self.contentView.snp.left).offset(20)
                make.right.equalTo(self.contentView.snp.right).offset(-20)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-30)
            }
            self.didUpdateConstraints = true
        }
        super.updateConstraints()
    }
    
}

