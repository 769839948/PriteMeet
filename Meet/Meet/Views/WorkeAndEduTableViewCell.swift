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
    @IBOutlet weak var eidtImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setWorkerData(_ workeString:String){
        imageDetail.image = UIImage.init(named: "me_profile_work")
        let workArray = workeString.components(separatedBy: "-")
        titleName.text = workArray[0]
        position.text = workArray[1]
    }
    
    func setEduData(_ workeString:String){
        imageDetail.image = UIImage.init(named: "me_profile_edu")
        let workArray = workeString.components(separatedBy: "-")
        titleName.text = "\(workArray[0]) \(workArray[2])"
        position.text = workArray[1]
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
