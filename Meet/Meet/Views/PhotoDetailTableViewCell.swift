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
typealias CellImageArray = (index:NSInteger,images:NSArray) ->Void

class PhotoDetailTableViewCell: UITableViewCell {

    var logoutView:UIView! = nil
    var addImageView:UIImageView! = nil
    var closure:ImageClick?
    var infoView:UIView!
    var shadowView:UIView!
    var cellImageArray:CellImageArray!
    var thumbnailImgArray:NSMutableArray = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.setUpView()
        
    }
    
    func setUpView() {
        logoutView = UIView(frame: CGRectMake(0,0,ScreenWidth,self.bounds.height))
        logoutView.backgroundColor = UIColor.whiteColor()
        
        self.addImageView = UIImageView()
        self.addImageView.image = UIImage(named: "me_addbtn")
        self.addImageView.userInteractionEnabled = true
        let singerTap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailTableViewCell.singerTap))
        singerTap.numberOfTapsRequired = 1
        singerTap.numberOfTouchesRequired = 1
        self.addImageView.frame = CGRectMake(10, 26, 59, 59)
        self.addImageView.addGestureRecognizer(singerTap)
        
        
        shadowView = UIView()
        shadowView.backgroundColor = UIColor.init(red: 242.0/255.5, green: 242.0/255.5, blue: 242.0/255.5, alpha: 1.0)
        shadowView.layer.cornerRadius = 5.0
        self.contentView.addSubview(shadowView)
        
        infoView = UIView()
        infoView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(infoView)
        
        infoView.addSubview(logoutView)
        infoView.addSubview(self.addImageView)
        
        shadowView.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp_top).offset(0)
            make.left.equalTo(self.contentView.snp_left).offset(10)
            make.right.equalTo(self.contentView.snp_right).offset(-10)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(0)
        }
        
        infoView.snp_makeConstraints { (make) in
            make.top.equalTo(self.shadowView.snp_top).offset(0)
            make.left.equalTo(self.shadowView.snp_left).offset(0)
            make.right.equalTo(self.shadowView.snp_right).offset(0)
            make.bottom.equalTo(self.shadowView.snp_bottom).offset(-3)
            make.height.equalTo(112)
        }
    }

    func configLogoutView(){
        self.backgroundColor = UIColor.whiteColor()
        logoutView.hidden = true
        addImageView.hidden = true
    }
    
    func configCell(imageArray:[Head_Photo_List]) {
        logoutView.hidden = false
        addImageView.hidden = false
        self.thumbnailImgArray.removeAllObjects()
        var width:CGFloat = 0
        let headPhotos = Head_Photo_List.mj_objectArrayWithKeyValuesArray(imageArray)
        if headPhotos.count > 0 {
            var originX:CGFloat = 72
            if headPhotos.count >= 8 {
               addImageView.hidden = true
                originX = 0
            }
            for index in 0...headPhotos.count - 1 {
                let model = headPhotos.objectAtIndex(index) as! Head_Photo_List
                let qiniuString = HomeDetailMoreInfoImageSize
                let urlString = "\(model.photo)\(qiniuString)"
                let photoImage = UIImageView()
                photoImage.tag = index
                photoImage.userInteractionEnabled = true
                photoImage.frame = CGRectMake(originX + width, 26, 59, 59)
                photoImage.sd_setImageWithURL(NSURL.init(string: urlString), placeholderImage: UIImage.init(color: UIColor.init(hexString: "e7e7e7"), size: CGSizeZero), options: SDWebImageOptions.RetryFailed, completed: { (image, error, type, url) in
                    self.thumbnailImgArray.addObject(image)
                })
                if CGRectGetMaxX(photoImage.frame) < ScreenWidth - 50 {
                    
                    infoView.addSubview(photoImage)
                    width = width + 62
                    let imageTap = UITapGestureRecognizer(target: self, action:#selector(PhotoDetailTableViewCell.imageTap(_:)))
                    imageTap.numberOfTapsRequired = 1
                    imageTap.numberOfTouchesRequired = 1
                    photoImage.addGestureRecognizer(imageTap)
                }else{
                    let detailImage = UIImageView(frame: CGRectMake(CGRectGetMaxX(photoImage.frame)  - 120 , 26, 78, 59))
                    detailImage.image = UIImage.init(named: "photo_detail")
                    infoView.addSubview(detailImage)
                    break;
                }
                
            }
           
            
            let detailNextImage = UIImageView(frame: CGRectMake(ScreenWidth - 47, 49.5, 7, 12))
            detailNextImage.image = UIImage.init(named: "info_next")
            infoView.addSubview(detailNextImage)
        }else{
            let photoImage = UIImageView()
            let singerTap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailTableViewCell.singerTap))
            singerTap.numberOfTapsRequired = 1
            singerTap.numberOfTouchesRequired = 1
            photoImage.frame = CGRectMake(72, 26, 59, 59)
            photoImage.addGestureRecognizer(singerTap)
            photoImage.image = UIImage.init(named: "me_detail_image")
            infoView.addSubview(photoImage)
            
            let detailImage = UIImageView(frame: CGRectMake(infoView.frame.size.width - 78, 26, 78, 59))
            detailImage.image = UIImage.init(named: "photo_detail")
            infoView.addSubview(detailImage)
            
            let detailNextImage = UIImageView(frame: CGRectMake(ScreenWidth - 47, 49.5, 7, 12))
            detailNextImage.image = UIImage.init(named: "info_next")
            infoView.addSubview(detailNextImage)
        }
        let maskPath = UIBezierPath.init(roundedRect: CGRectMake(0, 0, ScreenWidth - 20, 112), byRoundingCorners: [.BottomLeft,.BottomRight], cornerRadii: CGSizeMake(5, 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRectMake(0, 0, ScreenWidth - 20, 112)
        maskLayer.path = maskPath.CGPath
        infoView.layer.mask = maskLayer
        self.contentView.sendSubviewToBack(shadowView)
        self.contentView.bringSubviewToFront(infoView)
        
    }
    
    func singerTap(){
        if (self.closure != nil) {
            self.closure!()
        }
    }
    
    func imageTap(tap:UITapGestureRecognizer) {
        if self.cellImageArray != nil {
            self.cellImageArray(index: (tap.view?.tag)!,images: self.thumbnailImgArray)
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
