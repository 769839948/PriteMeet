//
//  OhterProfileModel.swift
//  Meet
//
//  Created by Zhang on 7/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OhterProfileModel: NSObject {

    var work: [Work]?

    var base_info: Base_Info?

    var more_info: More_Info?

    var edu: [Edu]?

}

class Base_Info: NSObject {

    var gender: Int = 0

    var job_label: String = ""
    
    var weixin_num: String = ""

    var location: String = ""

    var birthday: String = ""

    var real_name: String = ""

    var mobile_num: Int = 0
    
    var age: Int = 0
}

class More_Info: NSObject {

    var industry: Int = 0
    
    var height: Int = 0

    var affection: Int = 0

    var income: Int = 0

    var hometown: String = ""

    var constellation: Int = 0

}

class Work: NSObject {

    var wid: Int = 0

    var company_name: String = ""

    var profession: String = ""

}

class Edu: NSObject {

    var eid: Int = 0

    var graduated: String = ""

    var major: String = ""

    var education: String = ""

}

