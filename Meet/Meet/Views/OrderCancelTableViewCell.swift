//
//  OrderCancelTableViewCell.swift
//  Meet
//
//  Created by Zhang on 8/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

enum CellType {
    case cancel
    case normal
}

typealias CanCelButtonClickClouse = () ->Void

class OrderCancelTableViewCell: UITableViewCell {
    @IBOutlet weak var cancelBtn: UIButton!
    var cancelBtnClickclouse:CanCelButtonClickClouse!
    
    @IBOutlet weak var infoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelBtn.layer.borderColor = UIColor.init(hexString: OrderApplyMeetTitleColor).cgColor
        cancelBtn.titleLabel?.textColor = UIColor.init(hexString: OrderApplyMeetTitleColor)
        cancelBtn.layer.cornerRadius = 18.0
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.masksToBounds = true
        cancelBtn.addTarget(self, action: #selector(OrderCancelTableViewCell.cancelBtnClick(_:)), for: .touchUpInside)
        // Initialization code
        infoLabel.text = "客服电话：\(UserDefaultsGetSynchronize("customer_service_number"))   客服微信：Meetjun1"

    }
    
    func setButtonTitle(_ title:String,type:CellType ) {
        if type == .cancel {
            cancelBtn.isHidden = true
        }else{
            cancelBtn.isHidden = false
        }
        cancelBtn.setTitle(title, for: UIControlState())
    }
    
    func cancelBtnClick(_ sender:UIButton) {
        if self.cancelBtnClickclouse != nil {
            self.cancelBtnClickclouse()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
