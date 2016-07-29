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

let SpashViewFont =  version >= 9.0 ? UIFont.init(name: "PingFangSC-Regular", size: 10.0):UIFont.systemFontOfSize(10)

let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height