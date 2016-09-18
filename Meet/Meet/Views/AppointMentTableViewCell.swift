//
//  AppointMentTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

func tableViewHeight(_ interArray:NSArray,width:CGFloat) ->CGFloat {
    var yOffset:CGFloat  = 28
    var allSizeWidth:CGFloat  = 0
    for index in 0...interArray.count - 1 {
        let itemSize = CGSize(width: cellWidth(interArray.object(at: index) as! String), height: 26)
        allSizeWidth = allSizeWidth + itemSize.width + 10
        if allSizeWidth > width {
            yOffset = yOffset + 35
            allSizeWidth = itemSize.width + 10
        }
    }
    return yOffset
}

func cellWidth(_ string:String) ->CGFloat {
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
    
    var backImageView:UIImageView!
    

    var  didSetupConstraints:Bool = false
    
    let gradient: CAGradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
        // Initialization code
    }

    func setUpView() {
        appointmentBackGroundView = UIView()
        appointmentBackGroundView.layer.shadowColor = UIColor.init(red: 90/255.0, green: 18/255.0, blue: 0, alpha: 1).cgColor
        appointmentBackGroundView.layer.shadowOpacity = 0.12;
        appointmentBackGroundView.layer.shadowRadius = 10//阴影半径，默认3
        appointmentBackGroundView.layer.shadowOffset = CGSize(width: 0, height: 10)
        appointmentBackGroundView.layer.cornerRadius = 5.0
        self.contentView.addSubview(appointmentBackGroundView)
        
        backImageView = UIImageView()
        backImageView.image = UIImage.init(named: "order_appointment_back")
        backImageView.layer.cornerRadius = 5.0
        backImageView.layer.masksToBounds = true
        appointmentBackGroundView.addSubview(backImageView)

        
        appointmentIntroduce = UILabel()
        appointmentIntroduce.numberOfLines = 0
        appointmentIntroduce.font = OrderAppointThemeIntroudFont
        appointmentIntroduce.textColor = UIColor.white
        appointmentIntroduce.lineBreakMode = .byWordWrapping
        appointmentBackGroundView.addSubview(appointmentIntroduce)
        
        flowLayout = EqualSpaceFlowLayout()
        appointmentType = AppointmentCollectView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        appointmentType.backgroundColor = UIColor.clear
        flowLayout.delegate = appointmentType
        appointmentBackGroundView.addSubview(appointmentType)
       
        
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
        
    func setData(_ model: OrderModel) {
        let string = model.appointment_desc.replacingOccurrences(of: " ", with: "")
        appointmentIntroduce.text = string
        appointmentType.setCollectViewData(model.appointment_theme as [AnyObject], style: CollectionViewItemStyle.ItemWhiteBoardOrginBacground)
        appointmentType.snp.makeConstraints { (make) in
            make.height.equalTo(tableViewHeight(model.appointment_theme, width: ScreenWidth - 70))
        }
        
        appointmentIntroduce.snp.makeConstraints { (make) in
            make.height.equalTo(self.titleHeight(string, width: ScreenWidth - 70))
        }
        gradient.frame = appointmentBackGroundView.bounds
        
        self.updateConstraintsIfNeeded()
    }
    
    func titleHeight(_ string:String,width:CGFloat) ->CGFloat {
        let titleHeight:CGFloat = string.heightWithConstrainedWidth(width, font: OrderAppointThemeIntroudFont!)
        return titleHeight
    }
    
    override func updateConstraints() {
        if !self.didSetupConstraints {
            appointmentBackGroundView.snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView.snp.left).offset(20)
                make.right.equalTo(self.contentView.snp.right).offset(-20)
                make.top.equalTo(self.contentView.snp.top).offset(0)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-30)
            }
            
            backImageView.snp.makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp.left).offset(0)
                make.right.equalTo(self.appointmentBackGroundView.snp.right).offset(0)
                make.top.equalTo(self.appointmentBackGroundView.snp.top).offset(0)
                make.bottom.equalTo(self.appointmentBackGroundView.snp.bottom).offset(0)
            }
            
            appointmentIntroduce.snp.makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp.left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp.right).offset(-15)
                make.top.equalTo(self.appointmentBackGroundView.snp.top).offset(20)
                make.bottom.equalTo(self.appointmentType.snp.top).offset(-14)
            }
            
            appointmentType.snp.makeConstraints { (make) in
                make.left.equalTo(self.appointmentBackGroundView.snp.left).offset(15)
                make.right.equalTo(self.appointmentBackGroundView.snp.right).offset(-15)
                make.top.equalTo(self.appointmentIntroduce.snp.bottom).offset(14)
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
