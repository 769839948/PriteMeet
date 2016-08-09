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
    var textView:UITextView!
    
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
        
        
        textView = UITextView()
        textView.tintColor = UIColor.blackColor()
        textView.font = LoginCodeLabelFont
        self.contentView.addSubview(textView)
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp_top).offset(29)
            make.left.equalTo(self.contentView.snp_left).offset(20)
            make.right.equalTo(self.contentView.snp_right).offset(-20)
            make.bottom.equalTo(self.textView.snp_top).offset(-14)
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
