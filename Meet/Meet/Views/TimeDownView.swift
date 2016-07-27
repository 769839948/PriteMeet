//
//  TimeDownView.swift
//  LoginViewTest
//
//  Created by Zhang on 7/25/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

typealias SmsCodeClouse = () ->Void

class TimeDownView: UIView {

    var timeLabel:UILabel!
    var timeCount = 60
    var tapLabel:UITapGestureRecognizer!
    var time:NSTimer!
    var smsCodeClouse:SmsCodeClouse!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpTimeLabel()
        tapLabel = UITapGestureRecognizer(target: self, action: #selector(TimeDownView.timeDownAgaint(_:)))
        self.addGestureRecognizer(tapLabel)
        if time == nil {
            self.setUpTime()
        }
    }
    
    func setUpTime(){
        time = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimeDownView.timeDown(_:)), userInfo: nil, repeats: true)

        NSRunLoop.currentRunLoop().addTimer(time, forMode: "NSRunLoopDefault")
    }
    
    func setUpTimeLabel(){
        timeLabel = UILabel()
        timeLabel.textAlignment = .Center
        timeLabel.frame = CGRectMake(0, 0, 196, 20)
        timeLabel.font = UIFont.init(name: "PingFangSC-Light", size: 14.0)
        timeLabel.textColor = UIColor.init(hexString: "C9C9C9")
        self.addSubview(timeLabel)
    }
    
    func timeDown(sender:NSTimer) {
        timeCount  = timeCount - 1
        timeLabel.text = "如未收到可在 \(timeCount) 秒后重新获取"
        if timeCount == 0 {
            time.invalidate()
            time = nil
            let str = "如未收到可以 重新获取"
            let stringAttribute = NSMutableAttributedString(string: str)
            stringAttribute.addAttribute(NSForegroundColorAttributeName, value:UIColor.init(hexString: MeProfileCollectViewItemSelect), range: NSRange.init(location: 7, length: 4))
            timeLabel.attributedText = stringAttribute
        }
    }
    
    func timeDownAgaint(agagin:UITapGestureRecognizer) {
        if timeCount == 0 {
            timeCount = 60
            if self.smsCodeClouse != nil {
                self.smsCodeClouse()
            }
            if time == nil {
                self.setUpTime()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}