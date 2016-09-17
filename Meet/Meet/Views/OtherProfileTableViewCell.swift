//
//  OtherProfileTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OtherProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ title:String) {
        titleLabel.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
