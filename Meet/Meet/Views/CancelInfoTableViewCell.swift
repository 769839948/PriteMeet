//
//  CancelInfoTableViewCell.swift
//  Meet
//
//  Created by Zhang on 8/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class CancelInfoTableViewCell: UITableViewCell {

    var resonLabel:UILabel!
    var resonDetailLabel:UILabel!
    var appointmentBackGroundView: UIView!

    var  didSetupConstraints:Bool = false
    
    var meetInfo:UILabel!
    var meetImage:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setUpView() {
        appointmentBackGroundView = UIView()
        appointmentBackGroundView.backgroundColor = UIColor.init(hexString: CancelInfoBackGroundColor)
        appointmentBackGroundView.layer.shadowColor = UIColor.init(red: 90/255.0, green: 18/255.0, blue: 0, alpha: 1).CGColor
        appointmentBackGroundView.layer.shadowOpacity = 0.12;
        appointmentBackGroundView.layer.shadowRadius = 10//阴影半径，默认3
        appointmentBackGroundView.layer.shadowOffset = CGSizeMake(0, 10)
        appointmentBackGroundView.layer.cornerRadius = 5.0
        self.contentView.addSubview(appointmentBackGroundView)
        
        resonLabel = UILabel()
        resonLabel.font = OrderCancelInfoViewFont
        resonLabel.numberOfLines = 0
        resonLabel.textColor = UIColor.whiteColor()
        self.contentView.addSubview(resonLabel)
        
        
        resonDetailLabel = UILabel()
        resonDetailLabel.font = OrderInfoPayDetailFont
        resonDetailLabel.numberOfLines = 0
        resonDetailLabel.textColor = UIColor.whiteColor()
        self.contentView.addSubview(resonDetailLabel)
        
        
        meetInfo = UILabel()
        meetInfo.text = "POWERED BY MEET CONTROL CENTER"
        meetInfo.textColor = UIColor.init(white: 1, alpha: 0.5)
        meetInfo.textAlignment = .Right
        meetInfo.font = AppointMeetLogoPower
        appointmentBackGroundView.addSubview(meetInfo)
        
        meetImage = UIImageView()
        meetImage.image = UIImage.init(named: "order_logo")
        appointmentBackGroundView.addSubview(meetImage)
        
        self.updateConstraints()
        
    }
    
    func setUpData(reson:String, resonDetail:String) {
        
        resonLabel.text = reson
        resonDetailLabel.text = resonDetail
        resonLabel.snp_updateConstraints { (make) in
            make.height.equalTo(reson.heightWithConstrainedWidth(ScreenWidth - 70, font: OrderCancelInfoViewFont!) + 3)
        }
        resonDetailLabel.snp_updateConstraints { (make) in
            make.height.equalTo(reson.heightWithConstrainedWidth(ScreenWidth - 70, font: OrderInfoPayDetailFont!))
        }
    }
    
    override func updateConstraints() {
        if !self.didSetupConstraints {
            appointmentBackGroundView.snp_makeConstraints { (make) in
                make.left.equalTo(self.contentView.snp_left).offset(20)
                make.right.equalTo(self.contentView.snp_right).offset(-20)
                make.top.equalTo(self.contentView.snp_top).offset(0)
                make.bottom.equalTo(self.contentView.snp_bottom).offset(-10)
            }
            
            resonLabel.snp_makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp_left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp_right).offset(-15)
                make.top.equalTo(self.appointmentBackGroundView.snp_top).offset(25)
                make.bottom.equalTo(self.resonDetailLabel.snp_top).offset(-12)
            }
            
            resonDetailLabel.snp_makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp_left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp_right).offset(-15)
                make.top.equalTo(self.resonLabel.snp_bottom).offset(12)
                make.bottom.greaterThanOrEqualTo(self.appointmentBackGroundView.snp_top).offset(-66)
            }
            
            meetInfo.snp_makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp_left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp_right).offset(-40)
                make.bottom.equalTo(self.appointmentBackGroundView.snp_bottom).offset(-23)
            }
            
            meetImage.snp_makeConstraints { (make) in
                make.left.equalTo(self.meetInfo.snp_right).offset(8)
                make.bottom.equalTo(self.appointmentBackGroundView.snp_bottom).offset(-20)
                make.size.equalTo(CGSizeMake(17, 17))
            }
            
            self.didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
