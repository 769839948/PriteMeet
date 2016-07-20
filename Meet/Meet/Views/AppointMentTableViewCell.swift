//
//  AppointMentTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class AppointMentTableViewCell: UITableViewCell {

    @IBOutlet weak var appointmentType: UILabel!
    @IBOutlet weak var appointmentIntroduce: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

        
    func setData(model: OrderModel) {
        appointmentType.text = model.appointment_theme[0] as! String
        appointmentIntroduce.text = model.appointment_desc
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
