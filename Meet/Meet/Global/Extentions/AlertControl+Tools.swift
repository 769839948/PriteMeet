//
//  AlertControl+Tools.swift
//  AlertActionShow
//
//  Created by Zhang on 9/7/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import Foundation
import UIKit

typealias CancelAction = () -> Void
typealias DoneAction = () -> Void

extension UIAlertController {
    
    convenience init(message: String?) {
        self.init(title: nil, message: message, preferredStyle: .Alert)
        self.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
    
    class func shwoAlertControl(controller:UIViewController,title:String?,message:String?, cancel:String?, doneTitle:String?, cancelAction:CancelAction, doneAction:DoneAction){
        var alertControl = UIAlertController()
        if title == nil {
           alertControl = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        }else if message == nil{
            alertControl = UIAlertController(title: title, message: nil, preferredStyle: .Alert)

        }else{
            alertControl = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        }
        
        if cancel != nil {
            let leftAction = UIAlertAction(title: cancel, style: .Default) { (action) in
                cancelAction()
            }
            alertControl.addAction(leftAction)
        }
        if doneTitle != nil {
            let rightAction = UIAlertAction(title: doneTitle, style: .Default) { (action) in
                doneAction()
            }
            alertControl.addAction(rightAction)
        }
        controller.presentViewController(alertControl, animated: true) {
            
        }
    }
}