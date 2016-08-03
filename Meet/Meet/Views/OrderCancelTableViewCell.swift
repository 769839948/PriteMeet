//
//  OrderCancelTableViewCell.swift
//  Meet
//
//  Created by Zhang on 8/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderCancelTableViewCell: UITableViewCell {
    @IBOutlet weak var cancelBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        cancelBtn.layer.borderColor = UIColor.init(hexString: HomeDetailViewPositionColor).CGColor
        cancelBtn.layer.cornerRadius = 18.0
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
