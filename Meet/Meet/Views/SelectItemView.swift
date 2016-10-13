//
//  SelectItemView.swift
//  Meet
//
//  Created by Zhang on 19/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

protocol SelectItemViewDelegate {
    func selectViewDidSelectItem(selectView: SelectItemView, selectItem:NSInteger) -> Void;
}

protocol SelectItemViewDataSource {
    func selectViewNuberOfItem(selectView:SelectItemView) -> NSInteger;
    func selectViewItemTitle(selectView: SelectItemView, index: NSInteger) -> String;
}

class SelectItemView: UIView {
    
    var delegate:SelectItemViewDelegate!
    var dataSource:SelectItemViewDataSource!
    
    var itemCell:SelectItemViewCell!
    
    var curentSelect:NSInteger = 1
    
    override init(frame: CGRect) {
        super.init(frame:frame)        
    }
    
    func setUpView(){
        let numberOfItem = self.dataSource.selectViewNuberOfItem(selectView: self)
        let spacllWith:CGFloat = 4
        var maxWidth:CGFloat = 0
        for index in 1...numberOfItem {
            let str = self.dataSource.selectViewItemTitle(selectView:self,index: index - 1)
            let itemWidth:CGFloat =  str.stringWidth(str, font: FilterViewSelectItemFont!, height: 31) + 28
            let item = SelectItemViewCell.init(frame:CGRect.init(x: maxWidth, y: 0, width: itemWidth, height: self.frame.size.height), title:str)
            
            let itemTap = UITapGestureRecognizer(target: self, action: #selector(SelectItemView.itemTapClick(_:)))
            item.tag = index + 100
            item.addGestureRecognizer(itemTap)
            maxWidth = item.frame.maxX + spacllWith
            if curentSelect == index {
                item.titleLabel.backgroundColor = UIColor.init(hexString: HomeDetailViewNameColor)
                item.titleLabel.textColor = UIColor.white
                
            }
            self.addSubview(item)
        }
        
    }
    
    func itemTapClick(_ sender:UIGestureRecognizer) {
        for index in 1...self.dataSource.selectViewNuberOfItem(selectView: self) {
            let itemCell = self.viewWithTag(index + 100) as! SelectItemViewCell
            if index == (sender.view?.tag)! - 100 {
                itemCell.changeTitleLabelType(.Select)
                self.delegate.selectViewDidSelectItem(selectView: self, selectItem: index - 1)
            }else{
                itemCell.changeTitleLabelType(.UnSelect)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSelectView(_ itemArray:NSArray, _ currentIndex:NSInteger) {
        
    }
    
}

