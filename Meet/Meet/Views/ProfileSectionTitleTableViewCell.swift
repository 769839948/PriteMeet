//
//  ProfileSectionTitleTableViewCell.swift
//  Meet
//
//  Created by Zhang on 6/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class ProfileSectionTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(title:String, buttonTitle:String){
        titleLabel.text = title;
        if buttonTitle == "" {
            infoBtn.hidden = true
        }else{
            infoBtn.hidden = false
            infoBtn .setTitle(buttonTitle, forState: UIControlState.Normal)
            
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
