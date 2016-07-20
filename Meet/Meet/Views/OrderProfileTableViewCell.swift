//
//  OrderProfileTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var real_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(model:OrderModel){
        profileImage.sd_setImageWithURL(NSURL.init(string: (model.order_user_info?.avatar)!), placeholderImage: nil) { (image, error, carchTapy, url) in
            
        }
        real_name.text = model.order_user_info?.real_name
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
