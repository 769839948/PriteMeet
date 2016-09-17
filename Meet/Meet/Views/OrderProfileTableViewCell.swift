//
//  OrderProfileTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import SDWebImage

class OrderProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var real_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func setData(_ model:OrderModel){
        profileImage.sd_setImage(with: NSURL.init(string:(model.order_user_info?.avatar)!) as URL!, placeholderImage:         UIImage.init(color: UIColor.init(hexString:PlaceholderImageColor), size: CGSize.init(width: profileImage.frame.size.width, height: profileImage.frame.size.height))
, options: .retryFailed) { (image, error, cache, url) in
    
        }
        real_name.text = model.order_user_info?.real_name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
