//
//  LikeListCollectionViewCell.swift
//  Meet
//
//  Created by Zhang on 8/25/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SDWebImage

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
        self.contentView.sendSubview(toBack: splashView)
        splashView.layer.cornerRadius = 5.0
        splashView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(0)
            make.left.equalTo(self.contentView.snp.left).offset(0)
            make.right.equalTo(self.contentView.snp.right).offset(0)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(3)
        }
        
    }
    
    func setData(_ model:LikeListModel) {
        reportBtn.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        reportBtn.setTitleColor(UIColor.white, for: UIControlState())
        let likeModel = LikeListModel.mj_object(withKeyValues: model)
        let imageArray = likeModel?.avatar.components(separatedBy: "?")
        
        photoImageView.sd_setImage(with: URL.init(string: (imageArray?[0])! + AvatarImageSize), placeholderImage: PlaceholderImage(CGSize.init(width: 56, height: 56)), options: .retryFailed)
        reportBtn.tag = model.uid
        userName.text = likeModel?.real_name
        jobLabel.text = likeModel?.job_label
        self.updateConstraintsIfNeeded()
    }

}
