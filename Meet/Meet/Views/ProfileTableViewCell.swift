//
//  ProfileTableViewCell.swift
//  Meet
//
//  Created by Zhang on 6/25/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePhoto: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePhoto.isUserInteractionEnabled = false;
        profilePhoto.layer.masksToBounds = true;
        profilePhoto.layer.cornerRadius = 44.5;
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
