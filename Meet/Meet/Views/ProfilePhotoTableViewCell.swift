//
//  ProfilePhotoTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/8/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class ProfilePhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var applyCodeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePhoto.layer.masksToBounds = true
        // Initialization code
    }

    
    func hidderapplyCodeLabel() {
        applyCodeLabel.hidden = true
    }
    
    func showapplyCodeLabel(){
        applyCodeLabel.hidden = false
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
