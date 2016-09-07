//
//  AboutUsCell.swift
//  Meet
//
//  Created by Zhang on 9/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class AboutUsCell: UITableViewCell {

    var titleLabel:UILabel!
    var infoLabel:UILabel!
    var infoView:UIView!
    let lineLabel: UILabel = UILabel()
    var didSetUpContraints:Bool = false
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
        self.backgroundColor = UIColor.clearColor()
        self.lineLabel.backgroundColor = UIColor(hexString:"E7E7E7")
    }
    
    func setUpView() {
        
        infoView = UIView()
        infoView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(infoView)
        
        titleLabel = UILabel()
        titleLabel.font = AboutUsTitleFont
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.textColor = UIColor.init(hexString: AboutUsCellTitleColor)
        infoView.addSubview(titleLabel)
        
        infoLabel = UILabel()
        infoLabel.font = AboutUsInfoFont
        infoLabel.numberOfLines = 0
        infoLabel.sizeToFit()
        infoLabel.lineBreakMode = .ByWordWrapping
        infoLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        infoView.addSubview(infoLabel)
        
        infoView.addSubview(lineLabel)
        self.updateConstraints()
    }
    
    func configCell(title:String, info:String) {
        if title == "" {
           titleLabel.snp_updateConstraints(closure: { (make) in
                make.top.equalTo(self.contentView.snp_top).offset(0.01)
           })
        }else{
            titleLabel.snp_updateConstraints(closure: { (make) in
                make.top.equalTo(self.contentView.snp_top).offset(22)
            })
            infoLabel.snp_updateConstraints(closure: { (make) in
                make.top.equalTo(self.titleLabel.snp_bottom).offset(22)
            })
        }
        infoLabel.text = info
        titleLabel.text = title
        self.updateConstraintsIfNeeded()
        self.updateConstraints()
    }
    
    override func updateConstraints() {
        if !self.didSetUpContraints {
            infoView.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(self.contentView.snp_top).offset(0)
                make.left.equalTo(self.contentView.snp_left).offset(10)
                make.right.equalTo(self.contentView.snp_right).offset(-10)
                make.bottom.equalTo(self.contentView.snp_bottom).offset(0)
            })
            titleLabel.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(self.infoView.snp_top).offset(22)
                make.left.equalTo(self.infoView.snp_left).offset(10)
                make.right.equalTo(self.infoView.snp_right).offset(-10)
                make.bottom.equalTo(self.infoLabel.snp_top).offset(-12)
            })
            infoLabel.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(self.titleLabel.snp_bottom).offset(12)
                make.left.equalTo(self.infoView.snp_left).offset(10)
                make.right.equalTo(self.infoView.snp_right).offset(-10)
                make.bottom.equalTo(self.infoView.snp_bottom).offset(-34)
            })
            
            lineLabel.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self.infoView.snp_left).offset(10)
                make.right.equalTo(self.infoView.snp_right).offset(-10)
                make.height.equalTo(0.5)
                make.top.equalTo(self.infoView.snp_top).offset(0)
            })
            self.didSetUpContraints = true
        }
        super.updateConstraints()
    }
    
    func hidderLine() {
        self.lineLabel.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
