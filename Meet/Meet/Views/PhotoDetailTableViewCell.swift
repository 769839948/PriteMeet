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

typealias ImageClick = ()->Void

class PhotoDetailTableViewCell: UITableViewCell {

    var logoutView:UIView! = nil
    var addImageView:UIImageView! = nil
    var closure:ImageClick?
    override func awakeFromNib() {
        super.awakeFromNib()
        logoutView = UIView(frame: CGRectMake(0,0,ScreenWidth,self.bounds.height))
        logoutView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(logoutView)
        self.addImageView = UIImageView()
        self.addImageView.image = UIImage(named: "me_addbtn")
        self.addImageView.userInteractionEnabled = true
        self.contentView.addSubview(self.addImageView)
        let singerTap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailTableViewCell.singerTap))
        singerTap.numberOfTapsRequired = 1
        singerTap.numberOfTouchesRequired = 1
        self.addImageView.addGestureRecognizer(singerTap)
    }

    func configLogoutView(){
        self.backgroundColor = UIColor.whiteColor()
        logoutView.hidden = true
        addImageView.hidden = true
    }
    
    func configCell(imageArray:NSArray) {
        logoutView.hidden = false
        addImageView.hidden = false
        var width:CGFloat = 0
        self.logoutView.backgroundColor = UIColor.init(hexString: "FBFBFB")
        let photoImage = UIImageView()
        if imageArray.count  >= 5 {
            self.addImageView.hidden = true
        }
        photoImage.frame = CGRectMake(20 + width, 26, 59, 59)
        photoImage.backgroundColor = UIColor.blueColor()
        if imageArray.count > 0 {
            if imageArray.count > 5 {
                for index in 0...5 {
                    let urlArray = (imageArray.objectAtIndex(index) as! String).componentsSeparatedByString("?")
                    let qiniuString = "?imageView2/1/w/200/h/200"
                    let urlString = "\(urlArray[0])\(qiniuString)"
                    let photoImage = UIImageView()
                    photoImage.frame = CGRectMake(20 + width, 26, 59, 59)
                    photoImage.sd_setImageWithURL(NSURL.init(string: urlString), placeholderImage: UIImage.init(color: UIColor.init(hexString: "e7e7e7"), size: CGSizeZero), options: SDWebImageOptions.RetryFailed, completed: { (image, error, type, url) in
                        
                    })
                    self.logoutView.addSubview(photoImage)
                    width = width + 62
                    let singerTap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailTableViewCell.singerTap))
                    singerTap.numberOfTapsRequired = 1
                    singerTap.numberOfTouchesRequired = 1
                    photoImage.addGestureRecognizer(singerTap)
                }
            }else{
                for index in 0...imageArray.count - 1 {
                    let urlArray = (imageArray.objectAtIndex(index) as! String).componentsSeparatedByString("?")
                    let qiniuString = "?imageView2/1/w/200/h/200"
                    let urlString = "\(urlArray[0])\(qiniuString)"
                    let photoImage = UIImageView()
                    photoImage.frame = CGRectMake(20 + width, 26, 59, 59)
                    photoImage.sd_setImageWithURL(NSURL.init(string: urlString), placeholderImage: UIImage.init(color: UIColor.init(hexString: "e7e7e7"), size: CGSizeZero), options: SDWebImageOptions.RetryFailed, completed: { (image, error, type, url) in
                        
                    })
                    self.logoutView.addSubview(photoImage)
                    width = width + 62
                    let singerTap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailTableViewCell.singerTap))
                    singerTap.numberOfTapsRequired = 1
                    singerTap.numberOfTouchesRequired = 1
                    photoImage.addGestureRecognizer(singerTap)
                }
                self.addImageView.frame = CGRectMake(width + 20, 26, 59, 59)
            }
        }else{
            self.addImageView.frame = CGRectMake(20, 26, 59, 59)

        }
    }
    
    func singerTap(){
        if (self.closure != nil) {
            self.closure!()
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
