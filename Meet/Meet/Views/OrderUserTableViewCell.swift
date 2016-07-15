//
//  OrderUserTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/14/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderUserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var job_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(model:OrderModel){
        name.text = model.order_user_info?.real_name
        distance.text = model.distance
        job_label.text = model.order_user_info?.job_label
        avatar.sd_setImageWithURL(NSURL.init(string: (model.order_user_info?.avatar)!), placeholderImage: nil)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
