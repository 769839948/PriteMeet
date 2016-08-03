//
//  SwiftDefine.swift
//  Meet
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import Foundation

let version = (UIDevice.currentDevice().systemVersion as NSString).floatValue

let ApplyControllerTextFont = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 14.0):UIFont.systemFontOfSize(14)
let LoginCodeLabelFont      = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 14.0):UIFont.systemFontOfSize(14)
let LoginOldUserBtnFont      = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 12.0):UIFont.systemFontOfSize(12)
let LoginPhoneLabelFont      = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 18.0):UIFont.systemFontOfSize(18)

let LoginUserPropoclFont      = version >= 9.0 ? UIFont.init(name: "PingFangSC-Medium", size: 12.0):UIFont.systemFontOfSize(12)

let LoginPhoneTextFieldFont      = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 20.0):UIFont.systemFontOfSize(20)

let MeetDetailInterFont      = version >= 9.0 ? UIFont.init(name: "PingFangTC-Light", size: 23.0):UIFont.systemFontOfSize(23)

let MeetDetailImmitdtFont = version >= 9.0 ? UIFont.init(name: "PingFangSC-Semibold", size: 15):UIFont.systemFontOfSize(15)

let EmptyDataTitleFont   = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 14.0):UIFont.systemFontOfSize(14)

let OrderConfirmBtnFont      = version >= 9.0 ? UIFont.init(name: "PingFangSC-Regular", size: 12.0):UIFont.systemFontOfSize(12)

let OrderAppointThemeTypeFont   = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 11.0):UIFont.systemFontOfSize(11)

let OrderAppointThemeIntroudFont   = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 13.0):UIFont.systemFontOfSize(13)

let SpashViewFont =  version >= 9.0 ? UIFont.init(name: "PingFangSC-Regular", size: 10.0):UIFont.systemFontOfSize(10)

let AppointMeetLogoPower      =     version >= 9.0 ? UIFont.init(name: "HelveticaNeue-LightItalic", size: 8.0):UIFont.systemFontOfSize(8)

let AppointPositionLabelFont    = version >= 9.0 ? UIFont.init(name: "PingFangSC-Light", size: 11.0):UIFont.systemFontOfSize(11)

let AppointNameLabelFont    = version >= 9.0 ? UIFont.init(name: "PingFangSC-Regular", size: 11.0):UIFont.systemFontOfSize(11)

let ReloadOrderCollectionView = "ReloadOrderCollectionView"

func Stroyboard(storyName:String, viewControllerId:String) -> UIViewController {
    let storyboard = UIStoryboard.init(name: storyName, bundle: NSBundle.mainBundle())
    let viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerId)
    return viewController
}

func UserDefaultsGetSynchronize(key:String) -> String {
    return NSUserDefaults.standardUserDefaults().objectForKey("lastModifield")! as! String
}


let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height