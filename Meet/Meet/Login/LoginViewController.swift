//
//  LoginViewController.swift
//  Meet
//
//  Created by Zhang on 9/9/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

typealias ProtocolClouse = () -> Void
typealias NewUserLoginClouse = () -> Void
typealias ReloadMeViewClouse = () ->Void
typealias LoginWithDetailClouse = () ->Void
typealias LoginWithOrderListClouse = () ->Void
typealias OrderListShorOrderButton = () ->Void

class LoginViewController: UIViewController {

    
    var loginInfoView : UIView!
    
    var mobileField:UITextField!
    var smsCodeField:UITextField!
    
    var loginButton:UIButton!
    
    var timeDownLabel:TimeDownView!

    var keyboardHeight:CGFloat!
    
    var originFrame:CGRect!
    
    var reloadMeViewClouse:ReloadMeViewClouse!
    var protocolClouse:ProtocolClouse!
    var newUserLoginClouse:NewUserLoginClouse!
    var loginWithDetailClouse:LoginWithDetailClouse!
    var loginWithOrderListClouse:LoginWithOrderListClouse!
    var orderListShorOrderButton:OrderListShorOrderButton!
    
    let viewModel = LoginViewModel()
    
    var loginLabel:UILabel!
    
    var phoneStr : String? = ""
    
    var smsCodeStr : String? = ""
    
    var mobileLabel : UILabel!
    
    var smsCode : UILabel!
    
    var scllocView:UIScrollView!
    
    var contentView:UIView!
    
    var proBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setUpNavigationBar()
        if ScreenHeight == 480.0 {
            scllocView = UIScrollView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: ScreenHeight))
            scllocView.contentSize = CGSize(width: ScreenWidth, height: 634)
            self.view.addSubview(scllocView)
        }
        contentView = ScreenHeight == 480.0 ? scllocView : self.view
        self.setUpView()
        self.setupForDismissKeyboard()
        self.changeLoginButtonColor()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillDisappear(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.talKingDataPageName = "LoginView"
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.removeBottomLine()
    }
    
    func setUpView() {
        loginInfoView = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 200))
//        loginInfoView.backgroundColor = UIColor.redColor()
        contentView.addSubview(loginInfoView)
        
        loginLabel = UILabel(frame: CGRect(x: 40, y: 41, width: ScreenWidth, height: 42))
        loginLabel.text = "立即登录"
        loginLabel.font = LoginViewLabelFont
        loginLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        contentView.addSubview(loginLabel)
        
        mobileLabel = self.setUpLabel("移动电话")
        loginInfoView.addSubview(mobileLabel)
        
        smsCode = self.setUpLabel("短信验证码")
        loginInfoView.addSubview(smsCode)
        
        mobileField = self.setUpTextField()
        mobileField.tag = 1
        mobileField.returnKeyType = .next
        mobileField.keyboardType = .phonePad
        loginInfoView.addSubview(mobileField)
        
        smsCodeField = self.setUpTextField()
        smsCodeField.tag = 2
        smsCodeField.returnKeyType = .done
        smsCodeField.keyboardType = .numberPad
        loginInfoView.addSubview(smsCodeField)
        
        let lineLabel1 = self.setUpLineLabel()
        loginInfoView.addSubview(lineLabel1)
        
        let lineLabel2 = self.setUpLineLabel()
        loginInfoView.addSubview(lineLabel2)
        
        loginButton = self.setUpLoginButton()
        if ScreenHeight == 480 {
            loginButton.frame = CGRect(x: 36, y: (634 - 200 - 96)/2 + 200, width: 70, height: 46)
        }else{
            loginButton.frame = CGRect(x: 36, y: (ScreenHeight - 200 - 96)/2 + 200, width: 70, height: 46)
        }
        originFrame = self.loginButton.frame
        contentView.addSubview(loginButton)
        
        let comfigLabel = UILabel()
        comfigLabel.text = "登录即代表您同意"
        comfigLabel.font = LoginOldUserBtnFont
        contentView.addSubview(comfigLabel)
        
        proBtn = UIButton(type: .custom)
        proBtn.setTitle("用户协议", for: UIControlState())
        proBtn.setTitleColor(UIColor.init(hexString: HomeDetailViewNameColor), for: UIControlState())
        proBtn.titleLabel?.font = LoginUserPropoclFont
        proBtn.addTarget(self, action: #selector(LoginViewController.proBtnPress(_:)), for: .touchUpInside)
        contentView.addSubview(proBtn)
        
        timeDownLabel = TimeDownView()
        timeDownLabel.layer.cornerRadius = 15.0
        timeDownLabel.backgroundColor = UIColor.clear
        timeDownLabel.smsCodeClouse = { _ in
            self.smsButtonClick()
            if String.isValidateMobile(self.phoneStr) || self.phoneStr!.length == 11  {
                return true
            }
            return false
        }
        
        loginInfoView.addSubview(timeDownLabel)
        
        mobileLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginInfoView.snp.top).offset(141)
            make.left.equalTo(loginInfoView.snp.left).offset(40)
            make.size.equalTo(CGSize(width: 44, height: 16))
        }
        
        mobileField.snp.makeConstraints { (make) in
            make.top.equalTo(mobileLabel.snp.bottom).offset(8)
            make.left.equalTo(loginInfoView.snp.left).offset(39)
            make.right.equalTo(loginInfoView.snp.right).offset(-120)
            make.height.equalTo(29)
        }
        
        timeDownLabel.snp.makeConstraints { (make) in
            make.right.equalTo(loginInfoView.snp.right).offset(-40)
            make.bottom.equalTo(lineLabel1.snp.bottom).offset(-15)
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        
        lineLabel1.snp.makeConstraints { (make) in
            make.top.equalTo(mobileField.snp.bottom).offset(15)
            make.right.equalTo(self.loginInfoView.snp.right).offset(-40)
            make.left.equalTo(self.loginInfoView.snp.left).offset(40)
            make.height.equalTo(1)
        }
        
        smsCode.snp.makeConstraints { (make) in
            make.top.equalTo(lineLabel1.snp.bottom).offset(19)
            make.left.equalTo(self.loginInfoView.snp.left).offset(40)
            make.size.equalTo(CGSize(width: 55, height: 16))
        }
        
        smsCodeField.snp.makeConstraints { (make) in
            make.top.equalTo(smsCode.snp.bottom).offset(8)
            make.left.equalTo(self.loginInfoView.snp.left).offset(39)
            make.right.equalTo(self.loginInfoView.snp.right).offset(-40)
            make.height.equalTo(29)
        }
        
        lineLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(smsCodeField.snp.bottom).offset(15)
            make.right.equalTo(self.loginInfoView.snp.right).offset(-40)
            make.left.equalTo(self.loginInfoView.snp.left).offset(40)
            make.height.equalTo(1)
        }
        
        
        if ScreenHeight == 480 {
            comfigLabel.frame = CGRect(x: 40, y: 500, width: 100, height: 17)
            proBtn.frame = CGRect(x: 140, y: 500, width: 60, height: 17)
        }else{
            comfigLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView.snp.left).offset(40)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-50)
                make.height.equalTo(17)
            }
            
            proBtn.snp.makeConstraints { (make) in
                make.left.equalTo(comfigLabel.snp.right).offset(10)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-50)
                make.height.equalTo(17)
            }
        }
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        // 获取键盘信息
        let keyboardinfo = (notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey]
        if let keyboardSize = (keyboardinfo as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // ...
        }
        let frame = self.loginButton.frame
        UIView.animate(withDuration: 0.25, animations: {
            if IPHONE_5_Height {
                self.loginLabel.frame = CGRect(x: 40, y: 21, width: ScreenWidth, height: 42)
                self.loginInfoView.frame = CGRect(x: 0, y: -40, width: ScreenWidth, height: 300)
            }else{
                self.loginLabel.frame = CGRect(x: 40, y: -80, width: ScreenWidth, height: 42)
                self.loginInfoView.frame = CGRect(x: 0, y: -100, width: ScreenWidth, height: 300)
            }
            if ScreenHeight != 480 {
                self.loginButton.frame = CGRect(x: 36, y: ScreenHeight - self.keyboardHeight - 130, width: frame.size.width, height: frame.size.height)
            }
            }, completion: { (finish) in
        }) 
    }
    
    func keyboardWillDisappear(_ notification:Notification){
        UIView.animate(withDuration: 0.25, animations: {
            self.loginLabel.frame = CGRect(x: 40, y: 41, width: ScreenWidth, height: 42)
            self.loginInfoView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 300)
            self.loginButton.frame = CGRect(x: 36, y: self.originFrame.origin.y, width: 70, height: 46)
        }, completion: { (finish) in
            
        }) 
    }
    
    func proBtnPress(_ sender:UIButton) {
        let userProtocolVC = UserProtocolViewController()
        self.navigationController?.pushViewController(userProtocolVC, animated: true)
    }
    
    func setUpTextField() -> UITextField {
        let textField = UITextField()
        textField.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        textField.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        textField.delegate = self
        return textField
    }
    
    func setUpLabel(_ str:String) -> UILabel {
        let label = UILabel()
        label.text = str
        label.font = LoginInfoLabelFont
        label.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        return label
    }
    
    func setUpLineLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.init(hexString: HomeDetailViewNameColor)
        return label
    }
    
    func loginButtonClick() {
        
        if  phoneStr!.length != 11 {
            MainThreadAlertShow("手机号码输入有误", view: self.view)
            return
        }else if smsCodeStr!.length != 4 {
            MainThreadAlertShow("验证码输入", view: self.view)
            return
        }
        self.view.endEditing(true)
        loginLabel.text = "正在登录，请稍候..."
        self.loginClickSelectChangeColor()
        
        viewModel.loginSms(phoneStr, code: smsCodeStr, success: { (dic) in
            if (dic?["success"] as! String) == "oldUser" {
                self.viewModel.getUserInfo(self.phoneStr, success: { (dic) in
                    UserInfo.synchronize(withDic: dic)
                    UserInfo.sharedInstance().isFirstLogin = true
                    if self.reloadMeViewClouse != nil{
                        self.reloadMeViewClouse()
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                    
                    if self.loginWithDetailClouse != nil {
                        self.loginWithDetailClouse()
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                    
                    if self.loginWithOrderListClouse != nil {
                        self.loginWithOrderListClouse()
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                    self.dismiss(animated: true, completion: {
                        
                    })
                    }, fail: { (dic) in
                        self.loginLabel.text = "重试"
                        self.loginClickNomalChangeColor()
                    }, loadingString: { (msg) in
                        
                })
            }else if (dic?["success"] as! String) == "newUser"{
                UserInfo.sharedInstance().uid = "\(dic?["uid"] as! NSInteger)"
                self.viewModel.getUserInfo(UserInfo.sharedInstance().uid, success: { (dic) in
                    UserInfo.synchronize(withDic: dic)
                    UserInfo.sharedInstance().isFirstLogin = true
                    UserInfo.sharedInstance().mobile_num = self.mobileField.text
                    let baseUserInfo = Stroyboard("Me", viewControllerId: "BaseInfoViewController") as! BaseUserInfoViewController
                    self.navigationController?.pushViewController(baseUserInfo, animated: true)
                    }, fail: { (dic) in
                        MainThreadAlertShow("获取用户信息失败", view: self.view)
                        self.loginLabel.text = "重试"
                        self.loginClickNomalChangeColor()
                    }, loadingString: { (msg) in
                        
                })
                UserDefaults.standard.set(true, forKey: "isNewUser")
            }
        }, fail: { (dic) in
            if (dic?["error"] as! String) == "errorcode" {
                MainThreadAlertShow("验证码输入有误或已过期", view: self.view)
                self.loginClickNomalChangeColor()
                self.smsCodeField.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
                self.loginLabel.text = "重试"
            }else if (dic?["error"] as! String) == "errornet" {
                MainThreadAlertShow("网络错误", view: self.view)
                self.smsCodeField.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
                self.loginLabel.text = "重试"
                self.loginClickNomalChangeColor()
            }
        })
    }

    func changeLoginButtonColor() {
        smsCodeField.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        if phoneStr!.length == 11 && smsCodeStr!.length == 4 {
            loginButton.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeDetailViewNameColor), size: CGSize(width: 70, height: 46)), for: UIControlState())
        }else{
            loginButton.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: PlaceholderImageColor), size: CGSize(width: 70, height: 46)), for: UIControlState())
        }
    }
    
    func loginClickSelectChangeColor() {
        smsCode.textColor = UIColor.init(hexString: PlaceholderImageColor)
        mobileLabel.textColor = UIColor.init(hexString: PlaceholderImageColor)
        smsCodeField.textColor = UIColor.init(hexString: PlaceholderImageColor)
        mobileField.textColor = UIColor.init(hexString: PlaceholderImageColor)
        proBtn.setTitleColor(UIColor.init(hexString: PlaceholderImageColor), for: UIControlState())
        timeDownLabel.isHidden = true
        loginButton.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: PlaceholderImageColor), size: CGSize(width: 70, height: 46)), for: UIControlState())
    }
    
    func loginClickNomalChangeColor() {
        smsCode.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        mobileLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        smsCodeField.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        mobileField.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        proBtn.setTitleColor(UIColor.init(hexString: HomeDetailViewNameColor), for: UIControlState())
        timeDownLabel.isHidden = false
        self.changeLoginButtonColor()
    }
    
    func setUpLoginButton() -> UIButton{
        let loginButton = UIButton(type: .custom)
        loginButton.clipsToBounds = true
        loginButton.setImage(UIImage.init(named: "login_next"), for: UIControlState())
        loginButton.layer.cornerRadius = 24
        loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonClick), for: .touchUpInside)
        return loginButton
    }
    
    func smsButtonClick() {
        if String.isValidateMobile(phoneStr) || phoneStr!.length == 11 {
            viewModel.senderSms(phoneStr, success: { (dic) in
                }, fail: { (dic) in
                    MainThreadAlertShow((dic! as [AnyHashable:Any] as NSDictionary).object(forKey: "error") as! String, view: self.view)
            })
        }else{
            MainThreadAlertShow("手机号错误", view: self.view)
        }
    }
    
    func setUpNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(LoginViewController.disMissView))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.white, size: CGSize(width: ScreenWidth, height: 64)), for: .default)
        self.navigationItemWhiteColorAndNotLine()
    }
    
    func disMissView() {
        self.dismiss(animated: true) { 
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string != "" {
            if textField.tag == 1 {
                phoneStr = ((textField.text)! + string)
            }else if textField.tag == 2 {
                smsCodeStr = ((textField.text)! + string)
            }
        }else{
            if textField.tag == 1 {
                if textField.text?.length == 0 || (range.location == 0 && string == ""){
                    phoneStr = textField.text!
                }else{
                    phoneStr = ""
                }
            }else if textField.tag == 2 {
                if textField.text?.length == 0 || (range.location == 0 && string == "") {
                    smsCodeStr = textField.text!
                }else{
                    smsCodeStr = ""
                }
            }
        }

        self.changeLoginButtonColor()
        return true
    }
}
