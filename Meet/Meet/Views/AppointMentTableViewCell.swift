//
//  AppointMentTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

func tableViewHeight(interArray:NSArray,width:CGFloat) ->CGFloat {
    var yOffset:CGFloat  = 28
    var allSizeWidth:CGFloat  = 0
    for index in 0...interArray.count - 1 {
        let itemSize = CGSizeMake(cellWidth(interArray.objectAtIndex(index) as! String), 26)
        allSizeWidth = allSizeWidth + itemSize.width + 10
        if allSizeWidth > width {
            yOffset = yOffset + 35
            allSizeWidth = itemSize.width + 10
        }
    }
    return yOffset
}

func cellWidth(string:String) ->CGFloat {
    var cellWidth:CGFloat = 0
    
    cellWidth = string.stringWidth(string, font: OrderAppointThemeTypeFont!, height: 26)
    return cellWidth + 26;
}

class AppointMentTableViewCell: UITableViewCell {

    var appointmentType:AppointmentCollectView!
    var appointmentIntroduce: UILabel!
    var appointmentBackGroundView: UIView!
    var flowLayout:EqualSpaceFlowLayout!
    
    var meetInfo:UILabel!
    var meetImage:UIImageView!
    
    var  didSetupConstraints:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
        // Initialization code
    }

    func setUpView() {
        appointmentBackGroundView = UIView()
        appointmentBackGroundView.backgroundColor = UIColor.init(hexString: AppointMentBackGroundColor)
        appointmentBackGroundView.layer.cornerRadius = 5.0
        self.contentView.addSubview(appointmentBackGroundView)
        
        appointmentIntroduce = UILabel()
        appointmentIntroduce.font = OrderAppointThemeIntroudFont
        appointmentIntroduce.textColor = UIColor.whiteColor()
        appointmentBackGroundView.addSubview(appointmentIntroduce)
        
        flowLayout = EqualSpaceFlowLayout()
        appointmentType = AppointmentCollectView(frame: CGRectZero, collectionViewLayout: flowLayout)
        appointmentType.backgroundColor = UIColor.init(hexString: AppointMentBackGroundColor)
        flowLayout.delegate = appointmentType
        appointmentBackGroundView.addSubview(appointmentType)
       
        
        meetInfo = UILabel()
        meetInfo.text = "POWERED BY MEET CONTROL CENTER"
        meetInfo.textColor = UIColor.whiteColor()
        meetInfo.textAlignment = .Right
        meetInfo.font = AppointMeetLogoPower
        appointmentBackGroundView.addSubview(meetInfo)
        
        meetImage = UIImageView()
        meetImage.image = UIImage.init(named: "order_logo")
        appointmentBackGroundView.addSubview(meetImage)
        
        self.updateConstraints()
    }
        
    func setData(model: OrderModel) {
        appointmentIntroduce.text = model.appointment_desc
        appointmentType.setCollectViewData(model.appointment_theme as [AnyObject], style: CollectionViewItemStyle.ItemWhiteBoardOrginBacground)
        appointmentIntroduce.snp_updateConstraints { (make) in
            make.height.equalTo(self.titleHeight(model.appointment_desc, width: ScreenWidth - 70))
        }
        
        appointmentType.snp_updateConstraints { (make) in
            make.height.equalTo(tableViewHeight(model.appointment_theme, width: ScreenWidth - 70))
        }
    }
    
    func titleHeight(string:String,width:CGFloat) ->CGFloat {
        let titleHeight:CGFloat = string.stringHeight(OrderAppointThemeIntroudFont!, width: width)
        return titleHeight
    }
    
    override func updateConstraints() {
        if !self.didSetupConstraints {
            appointmentBackGroundView.snp_makeConstraints { (make) in
                make.left.equalTo(self.contentView.snp_left).offset(20)
                make.right.equalTo(self.contentView.snp_right).offset(-20)
                make.top.equalTo(self.contentView.snp_top).offset(0)
                make.bottom.equalTo(self.contentView.snp_bottom).offset(0)
            }
            
            appointmentIntroduce.snp_makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp_left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp_right).offset(-15)
                make.top.equalTo(self.appointmentBackGroundView.snp_top).offset(20)
                make.bottom.equalTo(self.appointmentType.snp_top).offset(-14)
            }
            
            appointmentType.snp_makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp_left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp_right).offset(-15)
                make.top.equalTo(self.appointmentIntroduce.snp_bottom).offset(14)
                make.bottom.equalTo(self.meetInfo.snp_top).offset(-33)
            }
            
            meetInfo.snp_makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp_left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp_right).offset(-40)
                make.top.equalTo(self.appointmentType.snp_bottom).offset(33)
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
