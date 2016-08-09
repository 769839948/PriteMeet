//
//  OrderApplyInfoTableViewCell.swift
//  Meet
//
//  Created by Zhang on 8/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderApplyInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var detailInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
        // Initialization code
    }

    func setData(detailInfo:String){
        self.detailTextLabel?.text = detailInfo
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
