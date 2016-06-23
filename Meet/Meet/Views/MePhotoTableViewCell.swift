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

typealias completeInfoBt = (tag:NSInteger) -> Void

class MePhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var placImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoCompleLabel: UILabel!
    @IBOutlet weak var completeInfo: UIButton!
    var block:completeInfoBt!
    let editImage = UIImage(named: "me_buttonedit")
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.image = UIImage.init(color: UIColor.init(hexString: "e7e7e7"), size: CGSizeZero)
        completeInfo.layer.cornerRadius = 15.0
        completeInfo.layer.masksToBounds = true
        
        // Initialization code
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
            self.completeInfo.hidden = false
            let compassString = "   \(compass.completeness)% \(compass.msg)     "
            let width = labelSize(compassString, attributes: [:])
            print("width=======\(width.width)")
            self.completeInfo.setTitle(compassString, forState: UIControlState.Normal)
            self.completeInfo.setImage(editImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Normal)
            self.completeInfo.tag = compass.next_page
            self.completeInfo.titleEdgeInsets = UIEdgeInsetsMake(0, -(editImage?.size.width)!, 0, (editImage?.size.width)!)
            self.completeInfo.imageEdgeInsets = UIEdgeInsetsMake(0, (self.completeInfo.titleLabel?.bounds.size.width)! - 10, 0, -(self.completeInfo.titleLabel?.bounds.size.width)! + 10)
            self.completeInfo.addTarget(self, action: #selector(MePhotoTableViewCell.completeInfoPress(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        }else{
            infoCompleLabel.text = infoCom;
            self.infoCompleLabel.hidden = false
            self.completeInfo.hidden = true
        }
        //        ManListCell.homeNameLabelColor(nameLabel)
    }
    
    func completeInfoPress(sender:UIButton){
        if (self.block != nil) {
            block(tag: sender.tag)
        }
    }
    
    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGRect{
        var size = CGRect();
        let size2 = CGSize(width: 100, height: 0);//设置label的最大宽度
        size = text.boundingRectWithSize(size2, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil , context: nil);
        return size
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
