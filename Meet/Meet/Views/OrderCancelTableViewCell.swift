//
//  OrderCancelTableViewCell.swift
//  Meet
//
//  Created by Zhang on 8/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

enum CellType {
    case Cancel
    case Normal
}

typealias CanCelButtonClickClouse = () ->Void

class OrderCancelTableViewCell: UITableViewCell {
    @IBOutlet weak var cancelBtn: UIButton!
    var cancelBtnClickclouse:CanCelButtonClickClouse!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelBtn.layer.borderColor = UIColor.init(hexString: OrderBaseCancelBtnColor).CGColor
        cancelBtn.layer.cornerRadius = 18.0
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.masksToBounds = true
        cancelBtn.addTarget(self, action: #selector(OrderCancelTableViewCell.cancelBtnClick(_:)), forControlEvents: .TouchUpInside)
        // Initialization code
    }
    
    func setButtonTitle(title:String,type:CellType ) {
        if type == .Cancel {
            cancelBtn.hidden = true
        }else{
            cancelBtn.hidden = false
        }
        cancelBtn.setTitle(title, forState: .Normal)
    }
    
    func cancelBtnClick(sender:UIButton) {
        if self.cancelBtnClickclouse != nil {
            self.cancelBtnClickclouse()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
