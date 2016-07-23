//
//  BlackListCollectCell.swift
//  Meet
//
//  Created by Zhang on 7/23/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class BlackListCollectCell: UICollectionViewCell {

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
        reportBtn.layer.borderColor = UIColor.blackColor().CGColor
        reportBtn.layer.borderWidth = 1
    }
    
    func setUpSplashView() {
        splashView = UIView()
        //        [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]
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
    
    func setData(model:BlackListModel) {
        let blackModel = BlackListModel.mj_objectWithKeyValues(model)
        photoImageView.sd_setImageWithURL(NSURL.init(string: blackModel.avatar!)) { (image, error, cache, url) in
        }
        reportBtn.tag = model.id
        userName.text = blackModel.real_name
        jobLabel.text = blackModel.job_label
    }

}
