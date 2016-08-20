//
//  BlackListCollectCell.swift
//  Meet
//
//  Created by Zhang on 7/23/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    var splashView:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpSplashView()
        photoImageView.layer.masksToBounds = true
        reportBtn.layer.cornerRadius = 15.0
        
    }
    
    func setUpSplashView() {
        splashView = UIView()
        splashView.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        self.contentView.addSubview(splashView)
        self.contentView.sendSubviewToBack(splashView)
        splashView.layer.cornerRadius = 5.0
        splashView.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp_top).offset(0)
            make.left.equalTo(self.contentView.snp_left).offset(0)
            make.right.equalTo(self.contentView.snp_right).offset(0)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(3)
        }
        
    }
    
    func setOrderModel(model:OrderModel) {
        let orderModel = OrderModel.mj_objectWithKeyValues(model)
        //"http://7xsatk.com1.z0.glb.clouddn.com/35acc8bd7b176b21ec2c1019468617f8.jpg?imageView2/1/w/1125/h/816"
        let imageArray = orderModel.order_user_info!.avatar.componentsSeparatedByString("?")
        //        print(ScreenWidth)
        photoImageView.sd_setImageWithURL(NSURL.init(string: imageArray[0].stringByAppendingString(AvatarImageSize))) { (image, error, cache, url) in
        }
        userName.text = orderModel.order_user_info!.real_name
        jobLabel.text = orderModel.order_user_info!.job_label
        reportBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        reportBtn.titleLabel?.font = OrderConfirmBtnFont
        if model.status?.status_type == "apply_order" {
            if model.status?.status_code == "6" || model.status?.status_code == "4" {
                reportBtn.setTitle(orderModel.status?.order_status, forState: .Normal)
                reportBtn.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            }else{
                reportBtn.setTitle(orderModel.status?.order_status, forState: .Normal)
                reportBtn.backgroundColor = UIColor.init(hexString: MeViewProfileContentLabelColorLight)
            }
        }else{
            if  model.status?.status_code == "1" || model.status?.status_code == "6" {
                reportBtn.setTitle(orderModel.status?.order_status, forState: .Normal)
                reportBtn.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            }else{
                reportBtn.setTitle(orderModel.status?.order_status, forState: .Normal)
                reportBtn.backgroundColor = UIColor.init(hexString: MeViewProfileContentLabelColorLight)
            }
        }
    }
    
    func setData(model:BlackListModel) {
        reportBtn.layer.borderColor = UIColor.blackColor().CGColor
        reportBtn.layer.borderWidth = 1
        let blackModel = BlackListModel.mj_objectWithKeyValues(model)
        photoImageView.sd_setImageWithURL(NSURL.init(string: blackModel.avatar!)) { (image, error, cache, url) in
        }
        reportBtn.tag = model.id
        userName.text = blackModel.real_name
        jobLabel.text = blackModel.job_label
    }
    
}
