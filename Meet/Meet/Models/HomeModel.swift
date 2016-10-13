//
//  HomeModel.swift
//  Meet
//
//  Created by Zhang on 8/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class HomeModel: NSObject {

    var real_name: String = ""
    
    var personal_label: String = ""
    
    var uid: Int = 0
    
    var age: Int = 0
    
    var liked_count: Int = 0
    
    var cover_photo: Cover_photo?
    
    var longitude: String = ""
    
    var job_label: String = ""
    
    var latitude: String = ""
    
    var avatar: String = ""
    
    var location: String = ""
    
    var birthday: String = ""
    
    var distance: String = ""
    
    var liked: Bool = false
    
    var gender: Int = 0
    
}

class Cover_photo: NSObject {
    
    var photo: String = ""
    
    var id: Int = 0
}


