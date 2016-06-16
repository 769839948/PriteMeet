//
//  HomeDetailModel.swift
//  Meet
//
//  Created by Zhang on 6/16/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class User_Info: NSObject {
    
    var cover_photo: String?
    
    var detail: [Detail]?
    
    var user_id: Int = 0
    
    var highlight: String?
    
    var auth_info: String?
    
}

class Detail: NSObject {
    
    var id: Int = 0
    
    var content: String?
    
    var title: String?
    
    var photo: [String]?
    
}

class Engagement: NSObject {
    
    var created: String?
    
    var id: Int = 0
    
    var is_active: Bool = false
    
    var engagement_desc: String?
    
    var theme: [Theme]?
    
    var user_id: Int = 0
    
}

class Theme: NSObject {
    
    var id: Int = 0
    
    var price: Int = 0
    
    var theme: String?
    
}




class HomeDetailModel: NSObject {
    var gender: Int = 0
    
    var engagement: Engagement?
    
    var job_label: String?
    
    var id: Int = 0
    
    var age: Int = 0
    
    var laititude: String?
    
    var location: String?
    
    var real_name: String?
    
    var user_info: User_Info?
    
    var longtitude: String?
    
    var personal_label: String?
}
