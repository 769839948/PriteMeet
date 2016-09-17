//
//  InviteItemsTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/5/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SnapKit

typealias selectItems = (_ selectItem:NSInteger) -> Void

class InviteItemsTableViewCell: UITableViewCell {

    var interestView: SetInviteCollectView!
    var flowLayout: EqualSpaceFlowLayout!
    
    var clourse:selectItems!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setUpView()
        // Initialization code
    }
    
    func setUpView(){
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
        interestView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(2)
            make.left.equalTo(self.contentView.snp.left).offset(20)
            make.right.equalTo(self.contentView.snp.right).offset(-20)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-20)
        }
    }

    func setData(_ array:NSArray, selectItems:NSArray){
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
            selectItemsArray.add(ret)
        }
        interestView.setCollectViewData(array as [AnyObject], andSelect: selectItemsArray as [AnyObject])
        interestView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(2)
            make.left.equalTo(self.contentView.snp.left).offset(20)
            make.right.equalTo(self.contentView.snp.right).offset(-20)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-20)
            make.height.equalTo(self.cellHeight(array))
        }
        
        
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

}
