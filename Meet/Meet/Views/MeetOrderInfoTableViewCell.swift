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
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var line1: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func setData(model:OrderModel){
        if model.status?.status_code == "6" {
            weChatNum.text = model.order_user_info?.weixin_num
            phoneNum.text = model.order_user_info?.mobile_num
        }
        orderCreateTime.text = model.created_at
        UIView.drawDashLine(line, lineLength: 2, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        UIView.drawDashLine(line1, lineLength: 2, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
