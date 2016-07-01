//
//  WorkeAndEduTableViewCell.swift
//  Meet
//
//  Created by Zhang on 6/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class WorkeAndEduTableViewCell: UITableViewCell {

    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setWorkerData(workeString:String){
        imageDetail.image = UIImage.init(named: "me_profile_work")
        let workArray = workeString.componentsSeparatedByString("-")
        titleName.text = workArray[0]
        position.text = workArray[1]
    }
    
    func setEduData(workeString:String){
        imageDetail.image = UIImage.init(named: "me_profile_edu")
        let workArray = workeString.componentsSeparatedByString("-")
        titleName.text = "\(workArray[0]) \(workArray[1])"
        position.text = workArray[1]
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
