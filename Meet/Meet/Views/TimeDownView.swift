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
    var timeCount = 0
    var tapLabel:UITapGestureRecognizer!
    var time:NSTimer!
    var smsCodeClouse:SmsCodeClouse!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpTimeLabel()
        self.clipsToBounds = true
        tapLabel = UITapGestureRecognizer(target: self, action: #selector(TimeDownView.timeDownAgaint))
        self.addGestureRecognizer(tapLabel)
        self.setUpTime()
    }
    
    func setUpTime(){
        if time == nil {
            time = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimeDownView.timeDown(_:)), userInfo: nil, repeats: true)
            let str = "获取验证码"
            timeLabel.text = str
            NSRunLoop.currentRunLoop().addTimer(time, forMode: "NSRunLoopDefault")
        }
    }
    
    func setUpTimeLabel(){
        timeLabel = UILabel()
        timeLabel.textAlignment = .Center
        timeLabel.frame = CGRectMake(0, 0, 70, 30)
        timeLabel.layer.cornerRadius = 14.0
        timeLabel.text = "获取验证码"
        timeLabel.layer.masksToBounds = true
        timeLabel.font = LoginButtonTitleFont
        timeLabel.textColor = UIColor.whiteColor()
        self.addSubview(timeLabel)
    }
    
    func timeDown(sender:NSTimer) {
        if timeCount != 0 {
            if timeLabel.frame.size.width == 70 {
                self.zoomSmsLabel()
            }
            self.timeLabel.backgroundColor = UIColor.init(hexString: PlaceholderImageColor)
            timeCount  = timeCount - 1
            timeLabel.text = "\(timeCount)s"
        }
        if timeCount == 0 {
            if time != nil {
                time.invalidate()
            }
            if timeLabel.frame.size.width == 44 {
                self.inSmsLabel()
            }
            time = nil
            self.timeLabel.backgroundColor = UIColor.init(hexString: HomeDetailViewNameColor)
            let str = "获取验证码"
            timeLabel.text = str
        }
    }
    
    func zoomSmsLabel() {
        UIView.animateWithDuration(0.25, animations: { 
            self.timeLabel.frame = CGRectMake(26, 0, 44, 30)
            }) { (finish) in
                
        }
    }
    
    func inSmsLabel() {
        UIView.animateWithDuration(0.25, animations: {
            self.timeLabel.frame = CGRectMake(0, 0, 70, 30)
        }) { (finish) in
            
        }
    }
    
    func timeDownAgaint() {
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