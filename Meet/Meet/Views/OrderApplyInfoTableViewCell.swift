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
        let strArray = detailInfo.componentsSeparatedByString(" ")
        let stringAttribute = NSMutableAttributedString(string: detailInfo)
        stringAttribute.addAttributes([NSFontAttributeName:OrderInfoViewMuchFont!], range: NSRange.init(location: (strArray[0]).length + 1, length: strArray[1].length))
        detailInfoLabel.attributedText = stringAttribute
        self.detailTextLabel?.attributedText = stringAttribute

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
