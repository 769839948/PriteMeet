//
//  PhotoDetailTableViewCell.swift
//  Meet
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class PhotoDetailTableViewCell: UITableViewCell {

    var logoutView:UIView! = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        logoutView = UIView(frame: CGRectMake(0,0,ScreenWidth,self.bounds.height))
        logoutView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(logoutView)
//        self.setUpView()
        // Initialization code
    }

    func configLogoutView(){
        self.backgroundColor = UIColor.whiteColor()
        logoutView.hidden = true
    }
    
    func configCell(imageArray:NSArray) {
        logoutView.hidden = false
        var width:CGFloat = 0
        self.logoutView.backgroundColor = UIColor.init(hexString: "FBFBFB")
        let photoImage = UIImageView()
        photoImage.frame = CGRectMake(20 + width, 26, 59, 59)
        photoImage.backgroundColor = UIColor.blueColor()
        if imageArray.count > 0 {
            for index in 0...imageArray.count - 1 {
                let photoImage = UIImageView()
                photoImage.frame = CGRectMake(20 + width, 26, 59, 59)
                photoImage.sd_setImageWithURL(NSURL.init(string: imageArray.objectAtIndex(index) as! String), placeholderImage: nil, options: SDWebImageOptions.RetryFailed, completed: { (image, error, type, url) in
                    
                })
                print("\(index) times 5 is \(width)")
                self.logoutView.addSubview(photoImage)
                width = CGFloat(index) * 62
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
