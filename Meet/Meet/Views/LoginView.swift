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

typealias ApplyCodeClouse = () -> Void
typealias ProtocolClouse = () -> Void
typealias NewUserLoginClouse = () -> Void
typealias ReloadMeViewClouse = () ->Void
typealias LoginWithDetailClouse = () ->Void

class LoginView: UIView {

    var backView:UIView!
    
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
    
    var checkLabelSms:PSWView!
    
    var applyCode:String = ""
    
    var reloadMeViewClouse:ReloadMeViewClouse!
    var applyCodeClouse:ApplyCodeClouse!
    var protocolClouse:ProtocolClouse!
    var newUserLoginClouse:NewUserLoginClouse!
    var loginWithDetailClouse:LoginWithDetailClouse!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backView = UIView(frame: frame)
        backView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        self.addSubview(backView)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        loginView = UIView()
        loginView.frame = CGRectMake((ScreenWidth - LoginViewWidth)/2, 91, LoginViewWidth, LoginViewHeight)
        loginView.layer.cornerRadius = 10.0
        loginView.backgroundColor = UIColor.whiteColor()
        self.addSubview(loginView)
        
        loginOldUser = UIView(frame: CGRectMake(0,0,loginView.frame.size.width,loginView.frame.size.height))
        loginOldUser.backgroundColor = UIColor.whiteColor()
        loginOldUser.tag = 2
        loginOldUser.clipsToBounds = true
        loginOldUser.layer.cornerRadius = 10.0
        loginView.addSubview(loginOldUser)
        
        
        smsCodeView = UIView(frame: CGRectMake(0,0,loginView.frame.size.width,loginView.frame.size.height))
        smsCodeView.backgroundColor = UIColor.whiteColor()
        smsCodeView.tag = 3
        smsCodeView.clipsToBounds = true
        smsCodeView.layer.cornerRadius = 10.0
        loginView.addSubview(smsCodeView)
        
        loginCodeView = UIView(frame: CGRectMake(0,0,loginView.frame.size.width,loginView.frame.size.height))
        loginCodeView.layer.cornerRadius = 10.0
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
        codeLabel.font = LoginCodeLabelFont
        codeLabel.textColor = UIColor.init(hexString: HomeMeetNumberColor)
        loginCodeView.addSubview(codeLabel)
        
        checkLabel = self.setUpCheckLabel(.Default)
        checkLabel.labelTouch(nil)
        checkLabel.keyBoardPressBlock = { code in
            self.applyCode = code
            self.checkCode(code)
        }
        loginCodeView.addSubview(checkLabel)
        
        let applyCodeBtn = self.setUpApplyCodeButton("申请邀请码")
        loginCodeView.addSubview(applyCodeBtn)
        
        let loginOldUser = UIButton()
        loginOldUser.setTitle("登录已有账号", forState: .Normal)
        loginOldUser.setTitleColor(UIColor.blackColor(), forState: .Normal)
        loginOldUser.titleLabel?.font = LoginOldUserBtnFont
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
            make.top.equalTo(applyCodeBtn.snp_bottom).offset(24)
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
        label.font = LoginPhoneLabelFont
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
        mobileTextField.autocorrectionType = .No
        mobileTextField.keyboardType = UIKeyboardType.PhonePad
        loginOldUser.addSubview(mobileTextField)
        
        let comfigLabel = UILabel()
        comfigLabel.text = "登录即代表您同意"
        comfigLabel.font = LoginOldUserBtnFont
        loginOldUser.addSubview(comfigLabel)
        
        let applyCodeBtn = self.setUpApplyCodeButton("发送验证码")
        loginOldUser.addSubview(applyCodeBtn)
        
        let proBtn = UIButton(type: .Custom)
        proBtn.setTitle("用户协议", forState: .Normal)
        proBtn.setTitleColor(UIColor.init(hexString: HomeDetailViewNameColor), forState: .Normal)
        proBtn.titleLabel?.font = LoginUserPropoclFont
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
        smsCode.font = LoginCodeLabelFont
        smsCode.text = "验证码已发送至"
        smsCode.textColor = UIColor.init(hexString: "C9C9C9")
        smsCodeView.addSubview(smsCode)
        
        phoneLabel = UILabel()
        phoneLabel.font = LoginPhoneTextFieldFont
        phoneLabel.textColor = UIColor.init(hexString: "C9C9C9")
        smsCodeView.addSubview(phoneLabel)
        
        timeDownLabel = TimeDownView(frame: CGRectMake(37, 164, loginView.frame.size.width - 37 * 2, 20))
        timeDownLabel.smsCodeClouse = { _ in
            self.viewModel.senderSms(self.phoneLabel.text, success: { (dic) in
                
                }, fail: { (dic) in
                    let appDic = dic as NSDictionary
                    self.shwoTools(appDic["msg"] as! String)
            })
        }
        smsCodeView.addSubview(timeDownLabel)
    
        checkLabelSms = self.setUpCheckLabel(.Num)
        checkLabelSms.keyBoardPressBlock = { code in
            self.loginWithCode(self.phoneLabel.text!, smsCode: code, applyCode: self.applyCode)
        }
        smsCodeView.addSubview(checkLabelSms)
        
        checkCodeCallBack = UILabel()
        checkCodeCallBack.text = "验证码输入有误或已过期"
        checkCodeCallBack.font = LoginCodeLabelFont
        checkCodeCallBack.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        checkCodeCallBack.hidden = true
        smsCodeView.addSubview(checkCodeCallBack)
        

        
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(loginCodeView.snp_centerX).offset(0)
            make.top.equalTo(loginCodeView.snp_top).offset(51)
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
        
        checkLabelSms.snp_makeConstraints { (make) in
            make.centerX.equalTo(smsCodeView.snp_centerX).offset(0)
            make.top.equalTo(phoneLabel.snp_bottom).offset(49)
            make.size.equalTo(CGSizeMake(199, 50))
        }
        
        checkCodeCallBack.snp_makeConstraints { (make) in
            make.centerX.equalTo(smsCodeView.snp_centerX).offset(0)
            make.top.equalTo(checkLabelSms.snp_bottom).offset(27)
            make.height.equalTo(20)
        }
    }
    
    func setUpApplyCodeButton(title:String) ->UIButton {
        let applyCodeBtn = UIButton(type: .Custom)
        applyCodeBtn.setTitle(title, forState: .Normal)
        applyCodeBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        applyCodeBtn.layer.borderColor = UIColor.blackColor().CGColor
        applyCodeBtn.titleLabel?.font = LoginOldUserBtnFont
        if title == "发送验证码" {
            applyCodeBtn.addTarget(self, action: #selector(LoginView.smsCode(_:)), forControlEvents: .TouchUpInside)
        }else{
            applyCodeBtn.addTarget(self, action: #selector(LoginView.applyCode(_:)), forControlEvents: .TouchUpInside)
        }
        applyCodeBtn.layer.borderWidth = 1.0
        applyCodeBtn.layer.cornerRadius = 19.0
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
                self.timeDownLabel.timeCount = 60
                self.timeDownLabel.setUpTime()
                self.checkLabelSms.labelTouch(nil)
                self.phoneLabel.text = self.mobileTextField.text
                self.phoneLabel.updateConstraintsIfNeeded()
                }, fail: { (dic) in
                    let appDic = dic as NSDictionary
                    self.shwoTools(appDic["msg"] as! String)
            })
        }else{
            UITools.showMessageToView(self, message: "手机号码不正确", autoHide: true)
        }
    }
    
    func shwoTools(str:String){
        UITools.showMessageToView(self, message: str, autoHide: true)
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
    
    func setUpCheckLabel(type:KeyboardType) -> PSWView{
        let checkLabel = PSWView(frame: CGRectZero, labelNum: 4, showPSW: true ,keyboarType: type)
        checkLabel.delegate = self
        return checkLabel
    }
    
    func setUpTitleLabel(title:String) -> UILabel{
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = title
        titleLabel.font = LoginPhoneTextFieldFont
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
        switch tag {
        case 1:
            checkLabel.labelTouch(nil)
        case 2:
            mobileTextField.becomeFirstResponder()
        case 3:
            checkLabelSms.labelTouch(nil)
        default:
            checkLabelSms.labelTouch(nil)
        }
        loginView.bringSubviewToFront(loginView.viewWithTag(tag)!)
    }
    
    
    func applyCode(sender:UIButton){
        if self.applyCodeClouse != nil {
            self.endEditing(true)
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
            checkLabel.changeLabelColor(UIColor.init(hexString: MeProfileCollectViewItemSelect))
        }else{
            checkLabelSms.changeLabelColor(UIColor.init(hexString: MeProfileCollectViewItemSelect))
            checkCodeCallBack.hidden = false
        }
    }
    
    func checkCodeNomalColor(){
        codeLabel.text = "使用邀请码或登录已有账号"
        codeLabel.textColor = UIColor.init(hexString: HomeMeetNumberColor)
    }
    
    func checkCode(code:String) {
        if code.length != 4 {
            self.checkCodeTextColorChange()
        }else{
            viewModel.checkCode(code, success: { (dic) in
                self.showViewWithTage(2)
                self.applyCode = code
                self.mobileTextField.becomeFirstResponder()
                }, fail: { (dic) in
                  self.checkCodeTextColorChange()
            }) { (msg) in
                
            }
        }
    }
    
    func proBtnPress(sender:UIButton) {
//        self.dismissView()
        if self.protocolClouse != nil {
            self.endEditing(true)
            self.protocolClouse()
        }
    }
    
    func loginWithCode(mobile:String, smsCode:String, applyCode:String){
        if smsCode.characters.count != 4 {
            checkCodeCallBack.hidden = false
        }else{
            
            viewModel.loginSms(mobile, code: smsCode, applyCode:applyCode, success: { (dic) in
               self.dismissView()
                UserInfo.sharedInstance().uid = mobile
                UserInfo.synchronizeWithDic(dic)
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isNewUser")
                UserInfo.sharedInstance().mobile_num = mobile
                if self.newUserLoginClouse != nil{
                    self.newUserLoginClouse()
                }
            }) { (dic) in
                if ((dic as NSDictionary).objectForKey("error") as! String) == "oldUser" {
                    self.viewModel.getUserInfo(mobile, success: { (dic) in
                        UserInfo.sharedInstance().uid = mobile
                        UserInfo.synchronizeWithDic(dic)
                        UserInfo.sharedInstance().isFirstLogin = true
                        if self.reloadMeViewClouse != nil{
                            self.reloadMeViewClouse()
                        }
                        if self.loginWithDetailClouse != nil {
                            self.loginWithDetailClouse()
                        }
                        self.dismissView()
                        }, fail: { (dic) in
                            
                        }, loadingString: { (msg) in
                            
                    })
                }else if ((dic as NSDictionary).objectForKey("error") as! String) == "noneuser"{
                    self.checkCodeCallBack.text = "该手机号用户不存在"
                    self.checkCodeCallBack.hidden = false
                }else{
                    self.checkCodeTextColorChange()
                    self.checkCodeCallBack.text = "验证码输入有误或已过期"
                    self.checkCodeCallBack.hidden = false
                }
            }
        }
        
    }
}

extension LoginView : DelegatePSW {
    func pwdNum(pwdNum: String!) {
        if fontViewTag == 1 {
            if pwdNum.characters.count == 4 {
                self.checkCode(pwdNum)
            }
            self.checkCodeNomalColor()
        }else{
            if pwdNum.characters.count == 4 {
                self.loginWithCode(phoneLabel.text!, smsCode: pwdNum, applyCode: applyCode)
            }
            checkCodeCallBack.hidden = true
        }
    }
}

extension LoginView : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if String.isValidateMobile(textField.text) || textField.text?.characters.count == 11 {
            viewModel.senderSms(textField.text, success: { (dic) in
                self.showViewWithTage(3)
                self.timeDownLabel.setUpTime()
                self.phoneLabel.text = textField.text
                self.phoneLabel.updateConstraintsIfNeeded()
                }, fail: { (dic) in
                  self.shwoTools(dic["msg"] as! String)
            })
        }else{
            UITools.showMessageToView(self, message: "手机号码不正确", autoHide: true)
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
    }
    
    
}



