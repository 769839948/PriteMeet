//
//  InPurchaseTableViewCell.swift
//  Meet
//
//  Created by Zhang on 09/10/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class InPurchaseTableViewCell: UITableViewCell {

    var cellImage:UIImageView!
    var cellTitleLabel:UILabel!
    var line:UIView!
    var cellButton:UIButton!

    var didSetUpContraints:Bool = false
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        cellImage = UIImageView()
        self.addSubview(cellImage)
        
        cellTitleLabel = UILabel()
        cellTitleLabel.textColor = UIColor.init(hexString: AboutUsLabelColor)
        cellTitleLabel.font = InPurchaseDetailFont!
        self.addSubview(cellTitleLabel)
        
        cellButton = UIButton(type: .custom)
        cellButton.setTitleColor(UIColor.init(hexString: MeProfileCollectViewItemSelect), for: .normal)
        cellButton.layer.cornerRadius = 5.0
        cellButton.layer.borderColor = UIColor.init(hexString: MeProfileCollectViewItemSelect).cgColor
        cellButton.layer.borderWidth = 1.0
        cellButton.titleLabel?.font = InPurchaseButtonFont!
        cellButton.isUserInteractionEnabled = false
        self.addSubview(cellButton)
        
        line = UIView()
//        line.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        UIView.drawDashLine(line, lineLength: 1, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))

        self.addSubview(line)
    }

    func setUpData(image:UIImage?, title:String?, buttonTitle:String?){
        cellImage.image = image
        cellTitleLabel.text = title
        cellButton.setTitle("   \((buttonTitle)!)  ", for: .normal)
        self.updateConstraintsIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func updateConstraints() {
        if !didSetUpContraints {
            cellImage.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp.centerY).offset(0)
                make.left.equalTo(self.snp.left).offset(19)
                make.size.equalTo(CGSize.init(width: 27, height: 27))
            })
            
            cellTitleLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp.centerY).offset(0)
                make.left.equalTo(cellImage.snp.right).offset(7)
                make.height.equalTo(17)
            })
            
            cellButton.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp.centerY).offset(0)
                make.right.equalTo(self.snp.right).offset(-19)
                make.height.equalTo(26)
            })
            line.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(19)
                make.right.equalTo(self.snp.right).offset(-19)
                make.bottom.equalTo(self.snp.bottom).offset(0)
                make.height.equalTo(1)
            })
            
            didSetUpContraints = true
        }
        
        super.updateConstraints()
    }
}
