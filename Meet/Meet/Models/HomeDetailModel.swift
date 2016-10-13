//
//  HomeDetailModel.swift
//  Meet
//
//  Created by Zhang on 6/16/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class User_Info: NSObject {
    
    
    var detail: [Detail]?
    
    var user_id: Int = 0
    
    var highlight: String = ""
    
    var auth_info: String = ""
    
    var experience: String = ""
}

class Engagement: NSObject {
    
    var created: String?
    
    var id: Int = 0
    
    var is_active: Bool = false
    
    var introduction_other: String = ""
    
    var theme: [Theme]?
    
    var user_id: Int = 0
    
}


class HomeDetailModel: NSObject {
    var gender: Int = 0
    
    var engagement: Engagement?
    
    var job_label: String = ""
    
    var id: Int = 0
    
    var age: Int = 0
            
    var laititude: String = ""

    var location: String = ""
    
    var real_name: String = ""
    
    var user_info: User_Info?
    
    var longtitude: String = ""
    
    var cover_photo: Cover_photo?
    
    var personal_label: String = ""
    
    var distance: String = ""
    
    var more_introduction: String = ""
    
    var web_url : String = ""
    
    var avatar : String = ""
    
    var cur_user_liked : Bool = false
    
    var liked_count : NSInteger = 0
    
    var head_photo_list: [Head_Photo_List]?

}



class Head_Photo_List: NSObject {

    var photo: String = ""

    var photo_id: Int = 0

}

