//
//  MeInfoTableViewCell.swift
//  Demo
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import SnapKit

let SwiftScreenWidth = UIScreen.main.bounds.size.width
let SwiftScreenHeight = UIScreen.main.bounds.size.height

enum CornerRadiusType {
    case none
    case top
    case bottom
    case left
    case right
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
        
        
        infoDetailLabel.textColor = UIColor.white
        infoDetailLabel.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
        self.lineLabel.backgroundColor = UIColor(hexString:"E7E7E7")
        self.contentView.addSubview(self.lineLabel)
        shadownView.layer.cornerRadius = 5.0
        // Initialization code
    }
    
    func configCell(_ image:String, infoString:String, infoDetail:String, shadowColor:Bool,cornerRadiusType:CornerRadiusType){
        
        
        
        infoImageView.image = UIImage(named: image)
        infoLabel.text = infoString
        infoDetailLabel.text = infoDetail
        
        if cornerRadiusType == .top {
            let maskPath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: ScreenWidth - 20, height: 61), byRoundingCorners: [.topRight,.topLeft], cornerRadii: CGSize(width: 5, height: 0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = CGRect(x: 0, y: 0, width: ScreenWidth - 10, height: 61)
            maskLayer.path = maskPath.cgPath
            infoView.layer.mask = maskLayer
        }else if cornerRadiusType == .bottom {
            let maskPath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: ScreenWidth - 20, height: 58), byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 5, height: 0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = CGRect(x: 0, y: 0, width: ScreenWidth - 10, height: 58)
            maskLayer.path = maskPath.cgPath
            infoView.layer.mask = maskLayer
        }
        
        let offset = shadowColor ? -3:0
        infoView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.shadownView.snp.bottom).offset(offset)
        }
        if !shadowColor {
            shadownView.isHidden = true
        }
        self.updateConstraintsIfNeeded()
        
    }
    
    override func updateConstraints() {
        if !self.didSetUpConstraints {
            self.lineLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(20)
                make.right.equalTo(self.contentView.snp.right).offset(-20)
                make.height.equalTo(0.5)
                make.top.equalTo(self.contentView.snp.top).offset(0)
            })
            
            shadownView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.contentView.snp.top).offset(0)
                make.left.equalTo(self.contentView.snp.left).offset(10)
                make.right.equalTo(self.contentView.snp.right).offset(-10)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(0)
            })
            
            infoView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.contentView.snp.top).offset(0)
                make.left.equalTo(self.contentView.snp.left).offset(10)
                make.right.equalTo(self.contentView.snp.right).offset(-10)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(0)
            })
            
            infoImageView.snp.makeConstraints({ (make) in
                make.left.equalTo(self.infoView.snp.left).offset(10)
                make.centerY.equalTo(self.infoView.snp.centerY).offset(0)
                make.size.equalTo(CGSize(width: 16, height: 16))
            })
            
            infoLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.infoImageView.snp.right).offset(10)
                make.centerY.equalTo(self.infoView.snp.centerY).offset(0)
            })
            
            infoDetailLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(self.info_next.snp.left).offset(-10)
                make.centerY.equalTo(self.infoView.snp.centerY).offset(0)
            })
            
            info_next.snp.makeConstraints({ (make) in
                make.right.equalTo(self.infoView.snp.right).offset(-20)
                make.centerY.equalTo(self.infoView.snp.centerY).offset(0)
                make.size.equalTo(CGSize(width: 7, height: 12))
            })
            self.didSetUpConstraints = true
        }
        super.updateConstraints()
    }
    
    func hidderLine() {
        self.lineLabel.isHidden = true
    }
    
    func showLine(){
        self.lineLabel.isHidden = false
    }
    
    func setInfoButtonBackGroudColor(_ color:String){
        infoDetailLabel.backgroundColor = UIColor.init(hexString: color)
        infoDetailLabel.layer.cornerRadius = 12.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
