//
//  OrderApplyMeetTableViewCell.swift
//  Meet
//
//  Created by Zhang on 8/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SnapKit

typealias OrderApplyMeetItem = (selectItem:NSInteger) -> Void

class OrderApplyMeetTableViewCell: UITableViewCell {
    
    var interestView: SetInviteCollectView!
    var flowLayout: EqualSpaceFlowLayout!
    
    var clourse:OrderApplyMeetItem!
    
    
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
        interestView = SetInviteCollectView(frame: CGRectZero, collectionViewLayout: flowLayout)
        interestView.delegate = interestView
        interestView.dataSource = interestView
        flowLayout.delegate = interestView;
        
        interestView.block = { row in
            if (self.clourse != nil) {
                self.clourse(selectItem: row);
            }
        }
        
        self.contentView.addSubview(interestView)
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp_top).offset(12)
            make.left.equalTo(self.contentView.snp_left).offset(20)
            make.right.equalTo(self.contentView.snp_right).offset(-20)
            make.bottom.equalTo(self.interestView.snp_top).offset(-24)
        }
        
        interestView.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(24)
            make.left.equalTo(self.contentView.snp_left).offset(20)
            make.right.equalTo(self.contentView.snp_right).offset(-20)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-30)
        }
    }
    
    func setData(array:NSArray, selectItems:NSArray){
        self.setUpView()
        let selectItemsArray = NSMutableArray()
        for idx in 0...array.count - 1{
            var ret = "false"
            for str in selectItems{
                if array[idx] as! String == str as! String {
                    ret = "true"
                    break
                }
            }
            selectItemsArray.addObject(ret)
        }
        
        interestView.setCollectViewData(array as [AnyObject], andSelectArray: selectItemsArray as [AnyObject])
        interestView.snp_updateConstraints{ (make) in
            make.height.equalTo(self.cellHeight(array))
        }
    }
    
    func cellHeight(interArray:NSArray) -> CGFloat{
        var yOffset:CGFloat = 30
        var allSizeWidth:CGFloat = 0
        for idx in 0...interArray.count - 1 {
            let itemSize = CGSizeMake(self.cellWidth(interArray[idx] as! NSString), 30)
            allSizeWidth = allSizeWidth + itemSize.width + 10
            if allSizeWidth > ScreenWidth - 40 {
                yOffset = yOffset + 40
                allSizeWidth = 0;
            }
        }
        return yOffset
    }
    
    func cellWidth(itemString:NSString) -> CGFloat{
        var cellWidth:CGFloat = 0
        cellWidth = itemString.widthWithFont(UIFont.systemFontOfSize(13), constrainedToHeight: 18)
        return cellWidth + 18;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

