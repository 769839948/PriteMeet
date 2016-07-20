//
//  StringClass.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import Foundation
// swift file
// extend the NSObject class
extension NSObject {
    // create a static method to get a swift class for a string name
    class func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  var appName: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
//            let classStringName = "_TtC\(appName!.utf16count)\(appName)\(countElements(className))\(className)"
            // return the class!
            return NSClassFromString(className)
        }
        return nil;
    }
}
