//
//  OrderApplyIntroductionCell.swift
//  Meet
//
//  Created by Zhang on 8/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderApplyIntroductionCell: UITableViewCell {

    var titleLabel:UILabel!
    var textView:TextViewAutoHeight!
    
    var numberText:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        titleLabel = UILabel()
        titleLabel.text = "添加约见说明"
        titleLabel.textColor = UIColor.init(hexString: OrderApplyMeetTitleColor)
        titleLabel.font = OrderApplyTitleFont
        self.contentView.addSubview(titleLabel)
        
        
        textView = TextViewAutoHeight(frame: CGRectMake(20, 20, ScreenWidth - 40, 100))
        textView.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        textView.font = LoginCodeLabelFont
        textView.maxHeight = 100
        self.contentView.addSubview(textView)
        
        numberText = UILabel()
        numberText.font = LoginCodeLabelFont
        numberText.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        numberText.textAlignment = .Right
        self.contentView.addSubview(numberText)
        
        numberText.snp_makeConstraints { (make) in
            make.top.equalTo(self.textView.snp_bottom).offset(0)
            make.right.equalTo(self.contentView.snp_right).offset(-20)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-10)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp_top).offset(29)
            make.left.equalTo(self.contentView.snp_left).offset(20)
            make.right.equalTo(self.contentView.snp_right).offset(-20)
            make.height.equalTo(20)
        }
        
        textView.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(14)
            make.left.equalTo(self.contentView.snp_left).offset(20)
            make.right.equalTo(self.contentView.snp_right).offset(-20)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-30)
        }
    }
    
    
    func setData(plachText:String){
        textView.placeholder = plachText
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
