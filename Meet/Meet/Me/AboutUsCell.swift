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
        self.backgroundColor = UIColor.clear
        self.lineLabel.backgroundColor = UIColor(hexString:"E7E7E7")
        self.updateConstraints()

    }
    
    func setUpView() {
        
        infoView = UIView()
        infoView.backgroundColor = UIColor.white
        self.contentView.addSubview(infoView)
        
        titleLabel = UILabel()
        titleLabel.font = AboutUsTitleFont
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.textColor = UIColor.init(hexString: AboutUsCellTitleColor)
        infoView.addSubview(titleLabel)
        
        infoLabel = UILabel()
        infoLabel.font = AboutUsInfoFont
        infoLabel.numberOfLines = 0
        infoLabel.sizeToFit()
        infoLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        infoView.addSubview(infoLabel)
        
        infoView.addSubview(lineLabel)
    }
    
    func configCell(_ title:String, info:String) {
        let height:CGFloat = info.heightWithConstrainedWidth(ScreenWidth - 20, font: AboutUsInfoFont!)
        let infoLabelHeight:CGFloat = height > 100 ? 100:height
        if title == "" {
           titleLabel.isHidden = true
           infoLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.infoView.snp.top).offset(22)
                make.left.equalTo(self.infoView.snp.left).offset(10)
                make.right.equalTo(self.infoView.snp.right).offset(-10)
                make.bottom.equalTo(self.infoView.snp.bottom).offset(-34)
                make.height.equalTo(infoLabelHeight)
           })
        }else{
            titleLabel.isHidden = false
            infoLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
                make.left.equalTo(self.infoView.snp.left).offset(10)
                make.right.equalTo(self.infoView.snp.right).offset(-10)
                make.bottom.equalTo(self.infoView.snp.bottom).offset(-34)
                make.height.equalTo(infoLabelHeight)
            })
        }
        
        infoLabel.text = info
        titleLabel.text = title
        self.updateConstraintsIfNeeded()

    }
    
    override func updateConstraints() {
        if !self.didSetUpContraints {
            infoView.snp.makeConstraints( { (make) in
                make.top.equalTo(self.contentView.snp.top).offset(0)
                make.left.equalTo(self.contentView.snp.left).offset(10)
                make.right.equalTo(self.contentView.snp.right).offset(-10)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(0)
            })
            titleLabel.snp.makeConstraints( { (make) in
                make.top.equalTo(self.infoView.snp.top).offset(22)
                make.left.equalTo(self.infoView.snp.left).offset(10)
                make.right.equalTo(self.infoView.snp.right).offset(-10)
            })
            infoLabel.snp.makeConstraints( { (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
                make.left.equalTo(self.infoView.snp.left).offset(10)
                make.right.equalTo(self.infoView.snp.right).offset(-10)
                make.bottom.equalTo(self.infoView.snp.bottom).offset(-34)
            })
            
            lineLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.infoView.snp.left).offset(10)
                make.right.equalTo(self.infoView.snp.right).offset(-10)
                make.height.equalTo(0.5)
                make.top.equalTo(self.infoView.snp.top).offset(0)
            })
            self.didSetUpContraints = true
        }
        super.updateConstraints()
    }
    
    func hidderLine() {
        self.lineLabel.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
