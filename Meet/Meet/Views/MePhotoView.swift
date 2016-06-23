//
//  MePhotoView.swift
//  Meet
//
//  Created by Zhang on 6/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SnapKit

class MePhotoView: UIView {

    
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var avatrImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoCompleLabel: UILabel!
    @IBOutlet weak var completeInfo: UIButton!
    var block:completeInfoBt!
    let editImage = UIImage(named: "me_buttonedit")

    override func drawRect(rect: CGRect) {
//        completeInfo.layer.cornerRadius = 15.0
//        completeInfo.layer.masksToBounds = true
    }
    
    
    func setUpView(){
        
    }
    
    func configlogoutView(){
        loginView.hidden = true
        logoutView.backgroundColor = UIColor.whiteColor()
        logoutView.hidden = false
    }
    
    func cofigLoginCell(name:String, infoCom:String, compass:Completeness){
        nameLabel.text = name
        logoutView.hidden = true
        self.loginView.hidden = false
        if infoCom == "" {
            infoCompleLabel.hidden = true
            let compassString = "   \(compass.completeness)% \(compass.msg)     "
            self.completeInfo.setTitle(compassString, forState: UIControlState.Normal)
            self.completeInfo.titleEdgeInsets = UIEdgeInsetsMake(0, -(editImage?.size.width)!, 0, (editImage?.size.width)!)
            self.completeInfo.tag = compass.next_page
            self.completeInfo.imageEdgeInsets = UIEdgeInsetsMake(0, (self.completeInfo.titleLabel?.bounds.size.width)! - 10, 0, -(self.completeInfo.titleLabel?.bounds.size.width)! + 10)
            completeInfo.setImage(editImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Normal)
            self.completeInfo.addTarget(self, action: #selector(MePhotoTableViewCell.completeInfoPress(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }else{
            infoCompleLabel.text = infoCom;
            self.completeInfo.hidden = true
        }
        //        ManListCell.homeNameLabelColor(nameLabel)
    }
    
    func completeInfoPress(sender:UIButton){
        if (self.block != nil) {
            block(tag: sender.tag)
        }
    }
}
