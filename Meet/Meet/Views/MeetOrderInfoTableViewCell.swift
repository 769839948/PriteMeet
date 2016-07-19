//
//  MeetInfoTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class MeetOrderInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var weChatNum: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var orderCreateTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
