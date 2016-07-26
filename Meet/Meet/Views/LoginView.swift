//
//  LoginView.swift
//  LoginViewTest
//
//  Created by Zhang on 7/23/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import SnapKit

let LoginViewWidth:CGFloat = 270
let LoginViewHeight:CGFloat = 320

typealias ApplyCodeClouse = () ->Void
typealias ProtocolClouse = () -> Void
class LoginView: UIView {

    var loginView:UIView!
    var loginCodeView:UIView!
    var loginOldUser:UIView!
    var smsCodeView:UIView!
    
    var codeLabel:UILabel!
    var checkLabel:PSWView!
    var phoneLabel:UILabel!
    var timeDownLabel:TimeDownView!
    var checkCodeCallBack:UILabel!
    var fontViewTag:NSInteger!
    var mobileTextField:UITextField!
    
    let viewModel = LoginViewModel()
    
    var applyCode:String = ""
    
    var applyCodeClouse:ApplyCodeClouse!
    var protocolClouse:ProtocolClouse!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        loginView = UIView()
        loginView.frame = CGRectMake((ScreenWidth - LoginViewWidth)/2, 91, LoginViewWidth, LoginViewHeight)
        loginView.layer.cornerRadius = 5.0
        loginView.backgroundColor = UIColor.whiteColor()
        self.addSubview(loginView)
        
        loginOldUser = UIView(frame: CGRectMake(0,0,loginView.frame.size.width,loginView.frame.size.height))
        loginOldUser.backgroundColor = UIColor.whiteColor()
        loginOldUser.tag = 2
        loginOldUser.clipsToBounds = true
        loginOldUser.layer.cornerRadius = 5.0
        loginView.addSubview(loginOldUser)
        
        
        smsCodeView = UIView(frame: CGRectMake(0,0,loginView.frame.size.width,loginView.frame.size.height))
        smsCodeView.backgroundColor = UIColor.whiteColor()
        smsCodeView.tag = 3
        smsCodeView.clipsToBounds = true
        smsCodeView.layer.cornerRadius = 5.0
        loginView.addSubview(smsCodeView)
        
        loginCodeView = UIView(frame: CGRectMake(0,0,loginView.frame.size.width,loginView.frame.size.height))
        loginCodeView.layer.cornerRadius = 5.0
        loginCodeView.backgroundColor = UIColor.whiteColor()
        loginView.addSubview(loginCodeView)
        loginCodeView.clipsToBounds = true
        loginCodeView.tag = 1
        
        
        
        self.setUpLoginCodeView()
        self.setUpLoginOldUser()
        self.setUpSmsView()
        self.showViewWithTage(1)
        
        
    }
    
    func setUpLoginCodeView() {
        
        self.setUpBackImageView(loginCodeView)
        let titleLable = self.setUpTitleLabel("你好朋友")
        loginCodeView.addSubview(titleLable)
        
        codeLabel = UILabel(frame: CGRectZero)
        codeLabel.text = "使用邀请码或登录已有账号"
        codeLabel.font = UIFont.init(name: "PingFangSc-Light", size: 14.0)
        loginCodeView.addSubview(codeLabel)
        
        let checkLabel = self.setUpCheckLabel()
        checkLabel.labelTouch(nil)
        checkLabel.keyBoardPressBlock = { code in
            self.applyCode = code
            self.checkCode(code)
        }
        loginCodeView.addSubview(checkLabel)
        
        let applyCodeBtn = self.setUpApplyCodeButton("申请验证码")
        loginCodeView.addSubview(applyCodeBtn)
        
        let loginOldUser = UIButton()
        loginOldUser.setTitle("登录已有账号", forState: .Normal)
        loginOldUser.setTitleColor(UIColor.blackColor(), forState: .Normal)
        loginOldUser.titleLabel?.font = UIFont.init(name: "PingFangSC-Light", size: 12.0)
        loginOldUser.addTarget(self, action: #selector(LoginView.loginWithOldUser(_:)), forControlEvents: .TouchUpInside)
        loginCodeView.addSubview(loginOldUser)
        
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.blackColor()
        loginCodeView.addSubview(lineLabel)
        
        
        let rightBtn = UIButton(type: .Custom)
        rightBtn.setImage(UIImage.init(named: "login_dismiss"), forState: .Normal)
        rightBtn.addTarget(self, action: #selector(LoginView.dismissView), forControlEvents: .TouchUpInside)
        loginCodeView.addSubview(rightBtn)
        
        titleLable.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.top.equalTo(loginCodeView.snp_top).offset(51)
            make.height.equalTo(28)
        }
        
        codeLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.top.equalTo(titleLable.snp_bottom).offset(5)
            make.height.equalTo(20)
        }
        
        checkLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.top.equalTo(codeLabel.snp_bottom).offset(22)
            make.size.equalTo(CGSizeMake(199, 50))
        }
        
        applyCodeBtn.snp_makeConstraints { (make) in
            make.top.equalTo(checkLabel.snp_bottom).offset(32)
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.size.equalTo(CGSizeMake(96, 37))
        }
        
        loginOldUser.snp_makeConstraints { (make) in
            make.top.equalTo(applyCodeBtn.snp_bottom).offset(20)
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.height.equalTo(17)
        }
        
        lineLabel.snp_makeConstraints { (make) in
            make.top.equalTo(loginOldUser.snp_bottom).offset(3)
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.width.equalTo(loginOldUser.snp_width).offset(0)
            make.height.equalTo(1)
        }
        
        rightBtn.snp_makeConstraints { (make) in
            make.right.equalTo(loginCodeView.snp_right).offset(-10)
            make.top.equalTo(loginCodeView.snp_top).offset(9)
            make.size.equalTo(CGSizeMake(40, 40))
        }

    }
    
    
    func setUpLoginOldUser(){
        self.setUpBackImageView(loginOldUser)

        let label = UILabel()
        label.text = "输入手机获取验证码"
        label.font = UIFont.init(name: "PingFangSC-Light", size: 18.0)
        label.numberOfLines = 0
        label.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        label.textAlignment = .Center
        loginOldUser.addSubview(label)
        
        mobileTextField = UITextField()
        mobileTextField.leftView = UIView.init(frame: CGRectMake(0, 0, 21, 20))
        mobileTextField.leftViewMode = .Always
        mobileTextField.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        mobileTextField.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
        mobileTextField.delegate = self
        loginOldUser.addSubview(mobileTextField)
        
        let comfigLabel = UILabel()
        comfigLabel.text = "登录即代表您同意"
        comfigLabel.font = UIFont.init(name: "PingFangSC-Light", size: 12.0)
        loginOldUser.addSubview(comfigLabel)
        
        let applyCodeBtn = self.setUpApplyCodeButton("获取验证码")
        loginOldUser.addSubview(applyCodeBtn)
        
        let proBtn = UIButton(type: .Custom)
        proBtn.setTitle("用户协议", forState: .Normal)
        proBtn.setTitleColor(UIColor.init(hexString: HomeDetailViewNameColor), forState: .Normal)
        proBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 12.0)
        proBtn.addTarget(self, action: #selector(LoginView.proBtnPress(_:)), forControlEvents: .TouchUpInside)
        loginOldUser.addSubview(proBtn)

        label.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginOldUser.snp_centerX).offset(0)
            make.top.equalTo(loginOldUser.snp_top).offset(60)
            make.height.equalTo(25)
        }
        
        mobileTextField.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginOldUser.snp_centerX).offset(0)
            make.top.equalTo(label.snp_bottom).offset(29)
            make.size.equalTo(CGSizeMake(199, 50))
        }
        
        applyCodeBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginOldUser.snp_centerX).offset(0)
            make.top.equalTo(mobileTextField.snp_bottom).offset(42)
            make.size.equalTo(CGSizeMake(96, 37))
        }
        
        comfigLabel.snp_makeConstraints { (make) in
            make.left.equalTo(loginOldUser.snp_left).offset(61)
            make.top.equalTo(applyCodeBtn.snp_bottom).offset(26)
            make.height.equalTo(17)
        }
        
        proBtn.snp_makeConstraints { (make) in
            make.left.equalTo(comfigLabel.snp_right).offset(10)
            make.top.equalTo(applyCodeBtn.snp_bottom).offset(26)
            make.height.equalTo(17)
        }
        
        self.navigationView(loginOldUser)

    }
    
    func setUpSmsView(){
        self.setUpBackImageView(smsCodeView)

        self.navigationView(smsCodeView)
        
        let titleLabel = self.setUpTitleLabel("短信验证")
        smsCodeView.addSubview(titleLabel)
        
        
        let smsCode = UILabel()
        smsCode.font = UIFont.init(name: "PingFangSC-Light", size: 14)
        smsCode.text = "验证码已发送至"
        smsCodeView.addSubview(smsCode)
        
        phoneLabel = UILabel()
        phoneLabel.font = UIFont.init(name: "Helvetica-Light", size: 20.0)
        smsCodeView.addSubview(phoneLabel)
        
        timeDownLabel = TimeDownView(frame: CGRectMake(37, 161, loginView.frame.size.width - 37 * 2, 20))
        timeDownLabel.smsCodeClouse = { _ in
            self.viewModel.senderSms(self.phoneLabel.text, success: { (dic) in
                
                }, fail: { (dic) in
                    
            })
        }
        smsCodeView.addSubview(timeDownLabel)
    
        let checkLabel = self.setUpCheckLabel()
        checkLabel.keyBoardPressBlock = { code in
            self.loginWithCode(self.phoneLabel.text!, smsCode: code, applyCode: self.applyCode)
        }
        smsCodeView.addSubview(checkLabel)
        
        checkCodeCallBack = UILabel()
        checkCodeCallBack.text = "验证码输入有误或已过期"
        checkCodeCallBack.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        checkCodeCallBack.hidden = true
        smsCodeView.addSubview(checkCodeCallBack)
        

        
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.top.equalTo(loginCodeView.snp_top).offset(60)
            make.height.equalTo(28)
        }
        
        smsCode.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.top.equalTo(titleLabel.snp_bottom).offset(30)
            make.height.equalTo(20)
        }
        
        phoneLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.top.equalTo(smsCode.snp_bottom).offset(4)
            make.height.equalTo(24)
        }
        
        checkLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(smsCodeView.snp_centerX).offset(0)
            make.top.equalTo(phoneLabel.snp_bottom).offset(49)
            make.size.equalTo(CGSizeMake(199, 50))
        }
        
        checkCodeCallBack.snp_makeConstraints { (make) in
            make.centerX.equalTo(smsCodeView.snp_centerX).offset(0)
            make.top.equalTo(checkLabel.snp_bottom).offset(27)
            make.height.equalTo(20)
        }
    }
    
    func setUpApplyCodeButton(title:String) ->UIButton {
        let applyCodeBtn = UIButton(type: .Custom)
        applyCodeBtn.setTitle(title, forState: .Normal)
        applyCodeBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        applyCodeBtn.layer.borderColor = UIColor.blackColor().CGColor
        applyCodeBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Light", size: 12.0)
        if title == "获取验证码" {
            applyCodeBtn.addTarget(self, action: #selector(LoginView.smsCode(_:)), forControlEvents: .TouchUpInside)
        }else{
            applyCodeBtn.addTarget(self, action: #selector(LoginView.applyCode(_:)), forControlEvents: .TouchUpInside)
        }
        applyCodeBtn.layer.borderWidth = 1.0
        applyCodeBtn.layer.cornerRadius = 18.0
        return applyCodeBtn
    }
    
    func navigationView(view:UIView){
        let navigationView = UIView()
        let leftBtn = UIButton(type: .Custom)
        leftBtn.setImage(UIImage.init(named: "login_leftBtn"), forState: .Normal)
        leftBtn.tag = view.tag
        leftBtn.addTarget(self, action: #selector(LoginView.leftbuttonPress(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(leftBtn)
        
        let rightBtn = UIButton(type: .Custom)
        rightBtn.setImage(UIImage.init(named: "login_dismiss"), forState: .Normal)
        rightBtn.addTarget(self, action: #selector(LoginView.dismissView), forControlEvents: .TouchUpInside)
        navigationView.userInteractionEnabled = true
        view.addSubview(rightBtn)
        
        view.addSubview(navigationView)
        view.userInteractionEnabled = true
        leftBtn.snp_makeConstraints { (make) in
            make.left.equalTo(view.snp_left).offset(10)
            make.top.equalTo(view.snp_top).offset(9)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        
        rightBtn.snp_makeConstraints { (make) in
            make.right.equalTo(view.snp_right).offset(-10)
            make.top.equalTo(view.snp_top).offset(9)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        
    }
    
    func smsCode(sender:UIButton) {
        if String.isValidateMobile(mobileTextField.text) || mobileTextField.text?.characters.count == 11 {
            viewModel.senderSms(mobileTextField.text, success: { (dic) in
                self.showViewWithTage(3)
                self.timeDownLabel.timeCount = 10
                self.phoneLabel.text = self.mobileTextField.text
                self.phoneLabel.updateConstraintsIfNeeded()
                }, fail: { (dic) in
                    
            })
        }else{
            UITools.showMessageToView(self, message: "手机号码不正确", autoHide: true)
        }
    }
    
    func setUpBackImageView(view:UIView){
        let topImageView = UIImageView()
        let topImage = UIImage.init(named: "splash_image1")
        topImageView.image  = topImage
        topImageView.frame = CGRectMake(91, -91, (topImage?.size.width)!, (topImage?.size.height)!)
        view.addSubview(topImageView)
        
        let rightImageView = UIImageView()
        let rightImage = UIImage.init(named: "login_image2")
        rightImageView.image  = rightImage
        rightImageView.frame = CGRectMake(82, 83, (rightImage?.size.width)!, (rightImage?.size.height)!)
        view.sendSubviewToBack(rightImageView)
        view.addSubview(rightImageView)
        
        let leftImageView = UIImageView()
        let leftImage = UIImage.init(named: "splash_image4")
        leftImageView.image  = leftImage
        leftImageView.frame = CGRectMake(-185, 79, (leftImage?.size.width)!, (leftImage?.size.height)!)
        view.addSubview(leftImageView)
    }
    
    func setUpCheckLabel() -> PSWView{
        checkLabel = PSWView(frame: CGRectZero, labelNum: 4, showPSW: true)
        checkLabel.delegate = self
        return checkLabel
    }
    
    func setUpTitleLabel(title:String) -> UILabel{
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = title
        titleLabel.font = UIFont.init(name: "PingFangSC-Light", size: 20.0)
        return titleLabel
    }
    
    func loginWithOldUser(sender:UIButton) {
        self.showViewWithTage(2)
        mobileTextField.becomeFirstResponder()
    }
    
    func leftbuttonPress(sender:UIButton) {
        self.showViewWithTage(sender.tag - 1)
    }
    
    func showViewWithTage(tag:NSInteger){
        fontViewTag = tag
        loginView.bringSubviewToFront(loginView.viewWithTag(tag)!)
    }
    
    
    func applyCode(sender:UIButton){
        self.dismissView()
        if self.applyCodeClouse != nil {
            self.applyCodeClouse()
        }
    }
    
    func dismissView(){
        self.removeFromSuperview()
    }
    
    func checkCodeTextColorChange(){
        if fontViewTag == 1 {
            codeLabel.text = "邀请码输入有误或已过期"
            codeLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            checkLabel.changeLabelColor(false)
        }else{
            checkCodeCallBack.hidden = false
            checkLabel.changeLabelColor(false)
        }
    }
    
    func checkCodeNomalColor(){
        codeLabel.text = "使用邀请码或登录已有账号"
        codeLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        checkLabel.changeLabelColor(true)
    }
    
    func checkCode(code:String) {
        if code.length != 4 {
            self.checkCodeTextColorChange()
        }else{
            viewModel.checkCode(code, success: { (dic) in
                self.showViewWithTage(2)
                self.mobileTextField.becomeFirstResponder()
                }, fail: { (dic) in
                  self.checkCodeTextColorChange()
            }) { (msg) in
                
            }
        }
    }
    
    func proBtnPress(sender:UIButton) {
        self.dismissView()
        if self.protocolClouse != nil {
            self.protocolClouse()
        }
    }
    
    func loginWithCode(mobile:String, smsCode:String, applyCode:String){
        if smsCode.characters.count != 4 {
            checkCodeCallBack.hidden = false
        }else{
            viewModel.loginSms(mobile, code: smsCode, applyCode:applyCode, success: { (dic) in
               self.dismissView()
            }) { (dic) in
                self.checkCodeCallBack.hidden = false
            }
        }
        
    }
}

extension LoginView : DelegatePSW {
    func pwdNum(pwdNum: String!) {
        if fontViewTag == 1{
            self.checkCodeNomalColor()
        }else{
            checkCodeCallBack.hidden = true
        }
    }
}

extension LoginView : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if String.isValidateMobile(textField.text) || textField.text?.characters.count == 11 {
            viewModel.senderSms(textField.text, success: { (dic) in
                self.showViewWithTage(3)
                self.timeDownLabel.timeCount = 10
                self.phoneLabel.text = textField.text
                self.phoneLabel.updateConstraintsIfNeeded()
                }, fail: { (dic) in
                    
            })
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
    }
    
    
}



