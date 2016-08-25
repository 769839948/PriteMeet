//
//  LikeListCollectionViewCell.swift
//  Meet
//
//  Created by Zhang on 8/25/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class LikeListCollectionViewCell: UICollectionViewCell {
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
    
    func setData(model:LikeListModel) {
        reportBtn.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        reportBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let likeModel = LikeListModel.mj_objectWithKeyValues(model)
        photoImageView.sd_setImageWithURL(NSURL.init(string: likeModel.avatar)) { (image, error, cache, url) in
        }
        reportBtn.tag = model.uid
        userName.text = likeModel.real_name
        jobLabel.text = likeModel.job_label
    }

}
