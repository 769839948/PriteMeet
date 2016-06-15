//
//  PhotoDetailTableViewCell.swift
//  Meet
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SnapKit
class PhotoDetailTableViewCell: UITableViewCell {

    var logoutView:UIView! = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        logoutView = UIView(frame: self.contentView.bounds)
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
        if imageArray.count > 0 {
            for index in 0...imageArray.count - 1 {
                let photoImage = UIImageView()
                photoImage.frame = CGRectMake(20 + width, 26, 59, 59)
                photoImage.image = imageArray.objectAtIndex(index) as? UIImage
                

                self.logoutView.addSubview(photoImage)
                width = CGFloat(index) * 62
                print("\(index) times 5 is \(width)")
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
