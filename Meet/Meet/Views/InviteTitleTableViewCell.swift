//
//  InviteTitleTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/5/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class InviteTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setData(title:String, isSwitch:Bool, isShowSwitch:Bool) {
        titleLabel.text = title;
        if isShowSwitch {
            switchControl.hidden = false
        }else{
            switchControl.hidden = true
        }
        switchControl.setOn(isSwitch, animated: true)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
