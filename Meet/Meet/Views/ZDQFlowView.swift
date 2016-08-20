//
//  ZDQFlowView.swift
//  TestFlowView
//
//  Created by Zhang on 8/2/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

protocol ZDQFlowViewDelegate {
    func flowViewDidSelectItem(flowView:ZDQFlowView, selectItem:NSInteger) -> Void
    
}

protocol ZDQFlowViewDataSource {
    func numberOfFlowViewItemCount(flowView:ZDQFlowView) -> NSInteger
    
    func numberOfFlowViewItem(flowView:ZDQFlowView, index:NSInteger) -> ZDQFlowViewItem
    
    func flowViewItemSize(flowView:ZDQFlowView) -> CGSize
}


class ZDQFlowView: UIView {

    var delegate:ZDQFlowViewDelegate!
    var dataSource:ZDQFlowViewDataSource!
    var spaceWidthX:CGFloat = 0
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    //MARK: ===============
    func setDataSource(dataSource:ZDQFlowViewDataSource) {
        self.dataSource = dataSource
        self.reloadData()
    }
    
    func getDataSource() -> ZDQFlowViewDataSource{
        return dataSource
    }
    
    func reloadData() {
        let size = self.dataSource.flowViewItemSize(self)
        let number = self.dataSource.numberOfFlowViewItemCount(self)
        let itemWith:CGFloat = size.width * CGFloat(number)
        let count = CGFloat(number) - 1
        spaceWidthX = (self.frame.size.width - itemWith) / count
        for subviews in self.subviews {
            subviews.removeFromSuperview()
        }
        for index in 0...number - 1 {
            let item = self.dataSource.numberOfFlowViewItem(self, index: index) 
            item.frame = CGRectMake((size.width + spaceWidthX) * CGFloat(index), 0, size.width, size.height)
            let label = UILabel()
            label.frame = CGRectMake(CGRectGetMaxX(item.frame) + 2, 14, spaceWidthX - 4, 1)
            if item.itemType == ZDQFlowViewItemType.ItemSelect {
                label.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            }else{
                label.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
            }
            if index < number - 1 {
                self.addSubview(label)
            }
            self.addSubview(item)
        }
    }
    
}


