//
//  MeInfoTableViewCell.swift
//  Demo
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import SnapKit

let SwiftScreenWidth = UIScreen.mainScreen().bounds.size.width
let SwiftScreenHeight = UIScreen.mainScreen().bounds.size.height


class MeInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDetailLabel: UILabel!
    var lineLabel: UILabel!
    var didSetUpConstraints:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lineLabel = UILabel()
        self.lineLabel.backgroundColor = UIColor(hexString:"E7E7E7")
        infoDetailLabel.textColor = UIColor.whiteColor()
        infoDetailLabel.layer.cornerRadius = 10.0
        infoDetailLabel.layer.masksToBounds = true
        self.contentView.addSubview(self.lineLabel)
        self.Constraints()
        // Initialization code
    }

    func configCell(image:String, infoString:String, infoDetail:String){
        infoImageView.image = UIImage(named: image)
        infoLabel.text = infoString
        infoDetailLabel.text = infoDetail
        infoDetailLabel.snp_updateConstraints { (make) in
        }
    }
    
    func Constraints() {
        if !self.didSetUpConstraints {
            self.lineLabel.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self.contentView.snp_left).offset(20)
                make.right.equalTo(self.contentView.snp_right).offset(20)
                make.height.equalTo(0.5)
                make.top.equalTo(self.contentView.snp_top).offset(0)
            })
            self.didSetUpConstraints = true
        }
    }
    
    func hidderLine() {
        self.lineLabel.hidden = true
    }
    
    func setInfoButtonBackGroudColor(color:String){
        infoDetailLabel.backgroundColor = UIColor.init(hexString: color)
        infoDetailLabel.layer.cornerRadius = 10.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
