//
//  UploadImages.swift
//  Meet
//
//  Created by Zhang on 9/5/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

let CenterViewWidtht:CGFloat = 190
let CenterViewHeight:CGFloat = 60

class UploadImages: UIView {

    var centerView:UIView!
    var centerLabel:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        self.setUpCenterView()
    }
    
    func setUpCenterView(){
        centerView = UIView(frame: CGRect(x: (ScreenWidth - CenterViewWidtht)/2,y: ScreenHeight / 2 * 0.76,width: CenterViewWidtht,height: CenterViewHeight))
        centerView.backgroundColor = UIColor.white
        centerView.layer.cornerRadius = 10.0
        self.addSubview(centerView)
        
        centerLabel = UILabel(frame: CGRect(x: 0,y: 0,width: CenterViewWidtht,height: CenterViewHeight))
        centerLabel.textAlignment = .center
        centerLabel.font = OrderApplyTitleFont!
        centerLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        centerView.addSubview(centerLabel)
        
    }
    
    func updateLabelText(_ number:String, allnumber:String) {
        centerLabel.text = "正在上传 \(number) of \(allnumber) ..."
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
