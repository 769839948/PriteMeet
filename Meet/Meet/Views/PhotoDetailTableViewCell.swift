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
typealias CellImageArray = (_ index:NSInteger,_ images:NSArray) ->Void

class PhotoDetailTableViewCell: UITableViewCell {

    var logoutView:UIView! = nil
    var addImageView:UIImageView! = nil
    var closure:ImageClick?
    var infoView:UIView!
    var detailImageView:UIView!
    var shadowView:UIView!
    var cellImageArray:CellImageArray!
    var thumbnailImgArray:NSMutableArray = NSMutableArray()
    
    var lineLable:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setUpView()
    }
    
    func setUpView() {
        logoutView = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: self.bounds.height))
        logoutView.isHidden = true
        logoutView.backgroundColor = UIColor.white
        
        self.addImageView = UIImageView()
        self.addImageView.image = UIImage(named: "me_addbtn")
        self.addImageView.isUserInteractionEnabled = true
        let singerTap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailTableViewCell.singerTap))
        singerTap.numberOfTapsRequired = 1
        singerTap.numberOfTouchesRequired = 1
        self.addImageView.frame = CGRect(x: 0, y: 26, width: 59, height: 59)
        self.addImageView.addGestureRecognizer(singerTap)
        
        
        shadowView = UIView()
        shadowView.backgroundColor = UIColor.init(red: 242.0/255.5, green: 242.0/255.5, blue: 242.0/255.5, alpha: 1.0)
        shadowView.layer.cornerRadius = 5.0
        self.contentView.addSubview(shadowView)
        
        infoView = UIView()
        infoView.backgroundColor = UIColor.white
        
        detailImageView = UIView()
        detailImageView.clipsToBounds = true
        detailImageView.addSubview(self.addImageView)
        
        infoView.addSubview(detailImageView)
        infoView.addSubview(logoutView)
        
        self.contentView.addSubview(infoView)

        
        lineLable = UILabel()
        lineLable.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        infoView.addSubview(lineLable)
        
        
        lineLable.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.top).offset(10)
            make.left.equalTo(self.infoView.snp.left).offset(10)
            make.right.equalTo(self.infoView.snp.right).offset(-10)
            make.height.equalTo(0.5)
        }
        
        shadowView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(0)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.shadowView.snp.top).offset(0)
            make.left.equalTo(self.shadowView.snp.left).offset(0)
            make.right.equalTo(self.shadowView.snp.right).offset(0)
            make.bottom.equalTo(self.shadowView.snp.bottom).offset(-3)
            make.height.equalTo(112)
        }
        
        detailImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.top).offset(0)
            make.left.equalTo(self.infoView.snp.left).offset(10)
            make.right.equalTo(self.infoView.snp.right).offset(-20)
            make.bottom.equalTo(self.infoView.snp.bottom).offset(0)
        }
    }

    func configLogoutView(){
        self.backgroundColor = UIColor.white
        logoutView.isHidden = false
        addImageView.isHidden = true
    }
    
    func configCell(_ imageArray:[Head_Photo_List]) {
        logoutView.isHidden = true
        addImageView.isHidden = false
        self.thumbnailImgArray.removeAllObjects()
        var width:CGFloat = 0
        let headPhotos = Head_Photo_List.mj_objectArray(withKeyValuesArray: imageArray)
        if (headPhotos?.count)! > 0 {
            var originX:CGFloat = 62
            if (headPhotos?.count)! >= 8 {
               addImageView.isHidden = true
                originX = 0
            }
            for index in 0...(headPhotos?.count)! - 1 {
                let model = headPhotos?.object(at: index) as! Head_Photo_List
                let qiniuString = HomeDetailMoreInfoImageSize
                let urlString = "\(model.photo)\(qiniuString)"
                let photoImage = UIImageView()
                photoImage.tag = index
                photoImage.isUserInteractionEnabled = true
                photoImage.frame = CGRect(x: originX + width, y: 26, width: 59, height: 59)
                photoImage.sd_setImage(with: URL.init(string: urlString), placeholderImage: UIImage.init(color: UIColor.init(hexString: "e7e7e7"), size: CGSize.zero), options: SDWebImageOptions.retryFailed, completed: { (image, error, type, url) in
                    if error != nil {
                        return
                    }
                    if image != nil {
                        self.thumbnailImgArray.add(image)
                    }
                })
                detailImageView.addSubview(photoImage)
                width = width + 62
                let imageTap = UITapGestureRecognizer(target: self, action:#selector(PhotoDetailTableViewCell.imageTap(_:)))
                imageTap.numberOfTapsRequired = 1
                imageTap.numberOfTouchesRequired = 1
                photoImage.addGestureRecognizer(imageTap)
            }
            let image = UIImage.init(named: "photo_detail")
            let detailImage = UIImageView(frame: CGRect(x: ScreenWidth - 40  - (image?.size.width)! , y: 26, width: (image?.size.width)!, height: (image?.size.height)!))
            detailImage.image = UIImage.init(named: "photo_detail")
            detailImageView.addSubview(detailImage)
            
            let detailNextImage = UIImageView(frame: CGRect(x: ScreenWidth - 20 - 27, y: 49.5, width: 7, height: 12))
            detailNextImage.image = UIImage.init(named: "info_next")
            infoView.addSubview(detailNextImage)
        }else{
//            let photoImage = UIImageView()
//            let singerTap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailTableViewCell.singerTap))
//            singerTap.numberOfTapsRequired = 1
//            singerTap.numberOfTouchesRequired = 1
//            photoImage.frame = CGRectMake(72, 26, 59, 59)
//            photoImage.addGestureRecognizer(singerTap)
//            photoImage.image = UIImage.init(named: "me_detail_image")
//            infoView.addSubview(photoImage)
            let image = UIImage.init(named: "photo_detail")
            let detailImage = UIImageView(frame: CGRect(x: ScreenWidth - 40 - (image?.size.width)! , y: 26, width: (image?.size.width)!, height: (image?.size.height)!))
            detailImage.image = UIImage.init(named: "photo_detail")
            detailImageView.addSubview(detailImage)
            
            let detailNextImage = UIImageView(frame: CGRect(x: ScreenWidth - 20 - 27, y: 49.5, width: 7, height: 12))
            detailNextImage.image = UIImage.init(named: "info_next")
            infoView.addSubview(detailNextImage)
        }
        let maskPath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: ScreenWidth - 20, height: 112), byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 5, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: ScreenWidth - 20, height: 112)
        maskLayer.path = maskPath.cgPath
        infoView.layer.mask = maskLayer
        self.contentView.sendSubview(toBack: shadowView)
        self.contentView.bringSubview(toFront: infoView)
        
    }
    
    func singerTap(){
        if (self.closure != nil) {
            self.closure!()
        }
    }
    
    func imageTap(_ tap:UITapGestureRecognizer) {
        if self.cellImageArray != nil {
            self.cellImageArray((tap.view?.tag)!,self.thumbnailImgArray)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
