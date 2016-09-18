//
//  InviteTitleTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/5/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

typealias switchChangeValueCourse = () -> Void

class InviteTitleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    var myCourse:switchChangeValueCourse!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setData(_ title:String, isSwitch:Bool, isShowSwitch:Bool) {
        titleLabel.text = title;
        switchControl.addTarget(self, action: #selector(InviteTitleTableViewCell.switchChangeValue(_:)), for: UIControlEvents.valueChanged)
        if isShowSwitch {
            switchControl.isHidden = false
        }else{
            switchControl.isHidden = true
        }
        switchControl.setOn(isSwitch, animated: true)
        self.updateConstraintsIfNeeded()
    }
    
    func switchChangeValue(_ switchCol:UISwitch){
        if switchCol.isOn {
            UserInviteModel.shareInstance().results[0].is_active = true
        }else{
            if (self.myCourse != nil) {
                self.myCourse()
            }

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
