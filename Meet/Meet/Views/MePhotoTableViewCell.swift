//
//  MePhotoTableViewCell.swift
//  Meet
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//


//[button setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
//[button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
/*
uibutton默认是左图片，右文字。并且在设置edge insets之前，位置已经有了设定。所以设置title的edge insets，真实的作用是在原来的边距值基础上增加或减少某个间距，负值便是减少。以title为例，设置右边距增加图片宽度，就使得自己的右边界距离按钮的右边界多了图片的宽度，正好放下图片。此时，title lable变小了，而title lable的左边界还在原来的位置上，所以lable的左边界距离按钮的左边界减少图片的宽度，lable就和原来一样大了，而且左侧起始位置和图片的左侧起始位置相同了。
*/


import UIKit

typealias completeInfoBt = (_ tag:NSInteger) -> Void

class MePhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoCompleLabel: UILabel!
    @IBOutlet weak var completeInfoView: UIView!
    @IBOutlet weak var completeInfoLabel: UILabel!
    var block:completeInfoBt!
    let editImage = UIImage(named: "me_buttonedit")
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.image = UIImage.init(color: UIColor.init(hexString: "e7e7e7"), size: CGSize.zero)
        avatarImageView.layer.masksToBounds = true
        loginView.clipsToBounds = true
        completeInfoView.layer.cornerRadius = 14.0
        completeInfoView.layer.masksToBounds = true
        completeInfoView.backgroundColor = UIColor.init(hexString:MeProfileCollectViewItemSelect)
        
        // Initialization code
    }
    
    
    func configlogoutView(){
        loginView.isHidden = true
        logoutView.backgroundColor = UIColor.clear
        logoutView.isHidden = false
        
    }

    func cofigLoginCell(_ name:String, infoCom:String, compass:Completeness){
        if name == "" {
            nameLabel.text = "无名氏"
        }else{
            nameLabel.text = name
        }
        logoutView.isHidden = true
        self.loginView.isHidden = false
        self.loginView.backgroundColor = UIColor.white
        if compass.completeness != 100 {
            completeInfoView.isHidden = false
            let compassString = "\(compass.completeness)% \(compass.msg!)"
            completeInfoLabel.text = compassString;
            completeInfoView.tag = compass.next_page
            let singerTap = UITapGestureRecognizer(target: self, action: #selector(MePhotoTableViewCell.singerTapPress(_:)))
            singerTap.numberOfTouchesRequired = 1
            singerTap.numberOfTapsRequired = 1
            completeInfoView.addGestureRecognizer(singerTap)
            infoCompleLabel.text = infoCom;
            
        }else{
            completeInfoView.isHidden = true
            infoCompleLabel.text = infoCom;
//            infoCompleLabel.snp.makeConstraints({ (make) in
//                make.height.equalTo(infoCom.he)
//            })
            self.infoCompleLabel.isHidden = false
        }
        let maskPath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355)
        maskLayer.path = maskPath.cgPath
        avatarImageView.layer.mask = maskLayer
        
        let loginMaskPath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355 + 137), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 0))
        let loginMaskLayer = CAShapeLayer()
        loginMaskLayer.frame = CGRect(x: 0, y: 0, width: ScreenWidth - 20, height: (ScreenWidth - 20)*236/355 + 137)
        loginMaskLayer.path = loginMaskPath.cgPath
        loginView.layer.mask = loginMaskLayer
        self.updateConstraintsIfNeeded()
    }
    
    func singerTapPress(_ tap:UITapGestureRecognizer) {
        if (self.block != nil) {
            self.block((tap.view?.tag)!)
        }
    }
    
    func labelSize(_ text:String ,attributes : [AnyHashable: Any]) -> CGRect{
        var size = CGRect();
        let size2 = CGSize(width: 100, height: 0);//设置label的最大宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil , context: nil);
        return size
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
