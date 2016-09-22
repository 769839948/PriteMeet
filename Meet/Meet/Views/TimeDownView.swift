//
//  TimeDownView.swift
//  LoginViewTest
//
//  Created by Zhang on 7/25/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

typealias SmsCodeClouse = () ->Bool

class TimeDownView: UIView {

    var timeLabel:UILabel!
    var timeCount = 0
    var tapLabel:UITapGestureRecognizer!
    var time:Timer!
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
            time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimeDownView.timeDown(_:)), userInfo: nil, repeats: true)
            let str = "获取验证码"
            timeLabel.text = str
            RunLoop.current.add(time, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    
    func setUpTimeLabel(){
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        timeLabel.layer.cornerRadius = 14.0
        timeLabel.text = "获取验证码"
        timeLabel.layer.masksToBounds = true
        timeLabel.font = LoginButtonTitleFont
        timeLabel.textColor = UIColor.white
        timeLabel.backgroundColor = UIColor.init(hexString: HomeDetailViewNameColor)
        self.addSubview(timeLabel)
    }
    
    func phoneError() {
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
    
    func timeDown(_ sender:Timer) {
        
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
        UIView.animate(withDuration: 0.25, animations: { 
            self.timeLabel.frame = CGRect(x: 26, y: 0, width: 44, height: 30)
            }, completion: { (finish) in
                
        }) 
    }
    
    func inSmsLabel() {
        UIView.animate(withDuration: 0.25, animations: {
            self.timeLabel.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        }, completion: { (finish) in
            
        }) 
    }
    
    func timeDownAgaint() {
        if timeCount == 0 {
            if self.smsCodeClouse != nil {
                if self.smsCodeClouse() {
                     timeCount = 60
                }
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
