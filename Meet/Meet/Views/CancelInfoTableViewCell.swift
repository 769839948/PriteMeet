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
        appointmentBackGroundView.layer.shadowColor = UIColor.init(red: 90/255.0, green: 18/255.0, blue: 0, alpha: 1).cgColor
        appointmentBackGroundView.layer.shadowOpacity = 0.12;
        appointmentBackGroundView.layer.shadowRadius = 10//阴影半径，默认3
        appointmentBackGroundView.layer.shadowOffset = CGSize(width: 0, height: 10)
        appointmentBackGroundView.layer.cornerRadius = 5.0
        self.contentView.addSubview(appointmentBackGroundView)
        
        resonLabel = UILabel()
        resonLabel.font = OrderCancelInfoViewFont
        resonLabel.numberOfLines = 0
        resonLabel.textColor = UIColor.white
        self.contentView.addSubview(resonLabel)
        
        
        resonDetailLabel = UILabel()
        resonDetailLabel.font = OrderInfoPayDetailFont
        resonDetailLabel.numberOfLines = 0
        resonDetailLabel.textColor = UIColor.white
        self.contentView.addSubview(resonDetailLabel)
        
        
        meetInfo = UILabel()
        meetInfo.text = "POWERED BY MEET CONTROL CENTER"
        meetInfo.textColor = UIColor.init(white: 1, alpha: 0.5)
        meetInfo.textAlignment = .right
        meetInfo.font = AppointMeetLogoPower
        appointmentBackGroundView.addSubview(meetInfo)
        
        meetImage = UIImageView()
        meetImage.image = UIImage.init(named: "order_logo")
        appointmentBackGroundView.addSubview(meetImage)
        
        self.updateConstraints()
        
    }
    
    func setUpData(_ reson:String, resonDetail:String) {
        
        resonLabel.text = reson
        resonDetailLabel.text = resonDetail
        resonLabel.snp.makeConstraints { (make) in
            make.height.equalTo(reson.heightWithConstrainedWidth(ScreenWidth - 70, font: OrderCancelInfoViewFont!) + 3)
        }
        resonDetailLabel.snp.makeConstraints { (make) in
            make.height.equalTo(resonDetail.heightWithConstrainedWidth(ScreenWidth - 70, font: OrderInfoPayDetailFont!))
        }
        self.updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        if !self.didSetupConstraints {
            appointmentBackGroundView.snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView.snp.left).offset(20)
                make.right.equalTo(self.contentView.snp.right).offset(-20)
                make.top.equalTo(self.contentView.snp.top).offset(0)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            }
            
            resonLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp.left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp.right).offset(-15)
                make.top.equalTo(self.appointmentBackGroundView.snp.top).offset(25)
                make.bottom.equalTo(self.resonDetailLabel.snp.top).offset(-12)
            }
            
            resonDetailLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp.left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp.right).offset(-15)
                make.top.equalTo(self.resonLabel.snp.bottom).offset(12)
                make.bottom.lessThanOrEqualTo(self.appointmentBackGroundView.snp.bottom).offset(-66)
            }
            
            meetInfo.snp.makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp.left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp.right).offset(-40)
                make.bottom.equalTo(self.appointmentBackGroundView.snp.bottom).offset(-23)
            }
            
            meetImage.snp.makeConstraints { (make) in
                make.left.equalTo(self.meetInfo.snp.right).offset(8)
                make.bottom.equalTo(self.appointmentBackGroundView.snp.bottom).offset(-20)
                make.size.equalTo(CGSize(width: 17, height: 17))
            }
            
            self.didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
