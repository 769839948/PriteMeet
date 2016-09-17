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
        
        
        textView = TextViewAutoHeight(frame: CGRect(x: 10, y: 20, width: ScreenWidth - 30, height: 100))
        textView.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        textView.font = LoginCodeLabelFont
        textView.maxHeight = 100
        textView.returnKeyType = .done
        self.contentView.addSubview(textView)
        
        numberText = UILabel()
        numberText.font = LoginCodeLabelFont
        numberText.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        numberText.textAlignment = .right
        self.contentView.addSubview(numberText)
        
        numberText.snp.makeConstraints { (make) in
            make.top.equalTo(self.textView.snp.bottom).offset(0)
            make.right.equalTo(self.contentView.snp.right).offset(-20)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(29)
            make.left.equalTo(self.contentView.snp.left).offset(20)
            make.right.equalTo(self.contentView.snp.right).offset(-20)
            make.height.equalTo(20)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(14)
            make.left.equalTo(self.contentView.snp.left).offset(15)
            make.right.equalTo(self.contentView.snp.right).offset(-15)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-30)
        }
    }
    
    
    func setData(_ plachText:String){
        textView.placeholderColor = UIColor.init(hexString: PlaceholderTextViewColor)
        textView.placeholder = plachText
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
