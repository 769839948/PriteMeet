//
//  MeInfoTableViewCell.swift
//  Demo
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import SnapKit

let SwiftScreenWidth = UIScreen.mainScreen().bounds.size.width
let SwiftScreenHeight = UIScreen.mainScreen().bounds.size.height

enum CornerRadiusType {
    case None
    case Top
    case Bottom
    case Left
    case Right
}


class MeInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDetailLabel: UILabel!
    @IBOutlet weak var info_next: UIImageView!
    
    var lineLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var shadownView: UIView!
    var didSetUpConstraints:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lineLabel = UILabel()
        self.backgroundColor = UIColor.clearColor()
        self.lineLabel.backgroundColor = UIColor(hexString:"E7E7E7")
        infoDetailLabel.textColor = UIColor.whiteColor()
        infoDetailLabel.layer.masksToBounds = true
        
        self.contentView.addSubview(self.lineLabel)
        shadownView.layer.cornerRadius = 5.0
        // Initialization code
    }
    
    func configCell(image:String, infoString:String, infoDetail:String, shadowColor:Bool,cornerRadiusType:CornerRadiusType){
        infoImageView.image = UIImage(named: image)
        infoLabel.text = infoString
        infoDetailLabel.text = infoDetail
        
        if cornerRadiusType == .Top {
            let maskPath = UIBezierPath.init(roundedRect: CGRectMake(0, 0, ScreenWidth - 20, 50), byRoundingCorners: [.TopRight,.TopLeft], cornerRadii: CGSizeMake(5, 0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = CGRectMake(0, 0, ScreenWidth - 10, 50)
            maskLayer.path = maskPath.CGPath
            infoView.layer.mask = maskLayer
        }else if cornerRadiusType == .Bottom {
            let maskPath = UIBezierPath.init(roundedRect: CGRectMake(0, 0, ScreenWidth - 20, 50), byRoundingCorners: [.BottomLeft,.BottomRight], cornerRadii: CGSizeMake(5, 0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = CGRectMake(0, 0, ScreenWidth - 10, 50)
            maskLayer.path = maskPath.CGPath
            infoView.layer.mask = maskLayer
        }
        
        let offset = shadowColor ? -3:0
        infoView.snp_updateConstraints { (make) in
            make.bottom.equalTo(self.contentView.snp_bottom).offset(offset)
        }
        if !shadowColor {
            shadownView.hidden = true
        }
        self.updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        if !self.didSetUpConstraints {
            self.lineLabel.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self.contentView.snp_left).offset(20)
                make.right.equalTo(self.contentView.snp_right).offset(-20)
                make.height.equalTo(0.5)
                make.top.equalTo(self.contentView.snp_top).offset(0)
            })
            
            shadownView.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(self.contentView.snp_top).offset(0)
                make.left.equalTo(self.contentView.snp_left).offset(10)
                make.right.equalTo(self.contentView.snp_right).offset(-10)
                make.bottom.equalTo(self.contentView.snp_bottom).offset(0)
            })
            
            infoView.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(self.contentView.snp_top).offset(0)
                make.left.equalTo(self.contentView.snp_left).offset(10)
                make.right.equalTo(self.contentView.snp_right).offset(-10)
            })
            
            infoImageView.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self.infoView.snp_left).offset(10)
                make.centerY.equalTo(self.infoView.snp_centerY).offset(0)
                make.size.equalTo(CGSizeMake(16, 16))
            })
            
            infoLabel.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self.infoImageView.snp_right).offset(10)
                make.centerY.equalTo(self.infoView.snp_centerY).offset(0)
            })
            
            infoDetailLabel.snp_makeConstraints(closure: { (make) in
                make.right.equalTo(self.info_next.snp_left).offset(-10)
                make.centerY.equalTo(self.infoView.snp_centerY).offset(0)
            })
            
            info_next.snp_makeConstraints(closure: { (make) in
                make.right.equalTo(self.infoView.snp_right).offset(-10)
                make.centerY.equalTo(self.infoView.snp_centerY).offset(0)
                make.size.equalTo(CGSizeMake(7, 12))
            })
            self.didSetUpConstraints = true
        }
        super.updateConstraints()
    }
    
    func hidderLine() {
        self.lineLabel.hidden = true
    }
    
    func setInfoButtonBackGroudColor(color:String){
        infoDetailLabel.backgroundColor = UIColor.init(hexString: color)
        infoDetailLabel.layer.cornerRadius = 12.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
