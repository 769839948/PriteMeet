//
//  ApplyMeetView.swift
//  Meet
//
//  Created by Zhang on 05/10/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit


let ApplyMeetViewHeight:CGFloat = 420


class ApplyMeetView: UIView {
    
    var backView:UIView!
    var singPan:UITapGestureRecognizer!
    var applyMeetView:UIView!
    
    var applyText:UITextView!
    
    var applyInfoView:UIView!
    
    var keyboardHeight:CGFloat = 0
    
    var appointment_theme:String!
    
    var isApplyOrder:Bool = false
    
    var host:String!
 
    let viewModel = OrderViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
        self.setUpSingPan()
        NotificationCenter.default.addObserver(self, selector: #selector(ApplyMeetView.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ApplyMeetView.keyboardWillDisappear(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        // 获取键盘信息
        let keyboardinfo = (notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey]
        if let keyboardSize = (keyboardinfo as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // ...
        }
        
        UIView.animate(withDuration: 0.25, animations: {
           self.applyMeetView.frame = CGRect(x: 0, y: ScreenHeight - ApplyMeetViewHeight - 90, width: ScreenWidth, height: ApplyMeetViewHeight)
            }, completion: { (finish) in
                
        })
        
    }
    
    func keyboardWillDisappear(_ notification:Notification){
        UIView.animate(withDuration: 0.25, animations: {
            self.applyMeetView.frame = CGRect(x: 0, y: ScreenHeight - ApplyMeetViewHeight, width: ScreenWidth, height: ApplyMeetViewHeight)
            }, completion: { (finish) in
                
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSingPan() {
        singPan = UITapGestureRecognizer(target: self, action: #selector(PayView.singPan(_:)))
        singPan.numberOfTapsRequired = 1
        singPan.numberOfTouchesRequired = 1
        backView.addGestureRecognizer(singPan)
    }
    
    func setUpView() {
        backView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height))
        backView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addSubview(backView)
        
        applyMeetView = UIView(frame: CGRect(x: 0,y: ScreenHeight,width: ScreenWidth,height: ApplyMeetViewHeight))
        applyMeetView.backgroundColor = UIColor.white
        self.configApplyView()
        applyMeetView.addSubview(self.applyMeetViewTitleView(CGRect(x: 0, y: 0, width: ScreenWidth, height: 66)))
        applyMeetView.addSubview(self.applyButton())
        self.addSubview(applyMeetView)
        
        applyInfoView = UIView(frame: CGRect(x: ScreenWidth,y: ScreenHeight - ApplyMeetViewHeight + 4,width: ScreenWidth,height: ApplyMeetViewHeight - 100))
        applyInfoView.backgroundColor = UIColor.white
        applyInfoView.addSubview(self.applyViewTitleView(CGRect(x: 0, y: 0, width: ScreenWidth, height: 66)))
        applyInfoView.addSubview(self.payOrderInfoView(CGRect(x: 0, y: 66, width: ScreenWidth, height: 66)))
        self.addSubview(applyInfoView)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.applyMeetView.frame = CGRect(x: 0, y: ScreenHeight - ApplyMeetViewHeight, width: ScreenWidth, height: ApplyMeetViewHeight)
        }) { (finish) in
            
        }
    }
    
    func applyViewTitleView(_ frame:CGRect) ->UIView {
        let payInfoViewTitle = UIView(frame: frame)
        
        let disMissBtn = UIButton(type: .custom)
        disMissBtn.addTarget(self, action: #selector(PayView.dismissView), for: .touchUpInside)
        disMissBtn.setImage(UIImage.init(named: "pay_dismiss"), for: UIControlState())
        disMissBtn.frame = CGRect(x: ScreenWidth - 40, y: 26, width: 20, height: 20)
        payInfoViewTitle.addSubview(disMissBtn)
        
        let backBtn = UIButton(type: .custom)
        backBtn.addTarget(self, action: #selector(PayView.backBtnClick), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "pay_back"), for: UIControlState())
        backBtn.frame = CGRect(x: 20, y: 26, width: 20, height: 20)
        payInfoViewTitle.addSubview(backBtn)
        
        let lineLabel = UILabel(frame: CGRect(x: 20,y: 64,width: UIScreen.main.bounds.size.width - 40,height: 2))
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        payInfoViewTitle.addSubview(lineLabel)
        
        return payInfoViewTitle
    }
    
    func payOrderInfoView(_ frame:CGRect) -> UIView{
        let payOrderInfoView = UIView(frame: frame)
        let infoLabel = UILabel(frame:CGRect(x: 20,y: 26,width: ScreenWidth - 20,height: 100))
        let str = "约见成功，Meet 将收取 48 元平台费用。\n对方接受约见后，您才需付款。\n付款成功后，双方可互见联系电话及微信。\n见面前，任何一方放弃约见，约见费用立即全额退还。"
        infoLabel.numberOfLines = 0
        let attributeString = NSMutableAttributedString(string: str)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .left
        paragraph.lineSpacing = 5.0
        attributeString.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: HomeDetailViewPositionColor)], range: NSRange.init(location: 0, length: str.length))
        attributeString.addAttributes([NSParagraphStyleAttributeName:paragraph], range: NSRange.init(location: 0, length: str.length))
        attributeString.addAttributes([NSFontAttributeName:OrderInfoPayDetailFont!], range: NSRange.init(location: 0, length: str.length))
        infoLabel.attributedText = attributeString
        payOrderInfoView.addSubview(infoLabel)
        return payOrderInfoView
    }
    
    func backBtnClick(_ sender:UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.applyInfoView.frame = CGRect(x: ScreenWidth, y: ScreenHeight - ApplyMeetViewHeight, width: ScreenWidth, height: ApplyMeetViewHeight - 100)
        }) { (finish) in
            
        }
    }
    
    func configApplyView() {
        applyText = UITextView(frame: CGRect.init(x: 25, y: 74, width: ScreenWidth - 50, height: 180))
        applyText.placeholderText = "\((PlaceholderText.shareInstance().appDic as NSDictionary).object(forKey: "1000002")!)"
        applyText.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        applyText.font = LoginCodeLabelFont
//        applyText.maxHeight = 100
        applyText.delegate = self
        applyText.returnKeyType = .done
        applyText.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemUnSelect)
        applyMeetView.addSubview(applyText)
    }
    
    func applyMeetViewTitleView(_ frame:CGRect) ->UIView {
        let payViewTitle = UIView(frame: frame)
        
        let payImage = UIImageView(frame: CGRect(x: ScreenWidth - 40, y: 26, width: 20, height: 20))
        payImage.image = UIImage.init(named: "pay_info")
        
        let disMissBtn = UIButton(type: .custom)
        disMissBtn.addTarget(self, action: #selector(PayView.dismissView), for: .touchUpInside)
        disMissBtn.setImage(UIImage.init(named: "pay_dismiss"), for: UIControlState())
        disMissBtn.frame = CGRect(x: 20, y: 26, width: 20, height: 20)
        payViewTitle.addSubview(disMissBtn)
        
        let panTap = UITapGestureRecognizer(target: self, action: #selector(PayView.showPayDetail(_:)))
        panTap.numberOfTapsRequired = 1
        panTap.numberOfTouchesRequired = 1
        payImage.isUserInteractionEnabled = true
        payImage.addGestureRecognizer(panTap)
        payViewTitle.addSubview(payImage)
        
        return payViewTitle
    }
    
    func showPayDetail(_ sender:UITapGestureRecognizer) {
        self.endEditing(true)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.applyInfoView.frame = CGRect(x: 0, y: ScreenHeight - ApplyMeetViewHeight, width: ScreenWidth, height: ApplyMeetViewHeight - 100)
        }) { (finish) in
            
        }
    }
    
    func applyButton() ->UIButton {
        let payButton = UIButton(type: .custom)
        payButton.frame = CGRect(x: (ScreenWidth - 175)/2, y: applyMeetView.frame.size.height - 75, width: 175, height: 45)
        payButton.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        payButton.setTitle("提交申请", for: UIControlState())
        payButton.layer.cornerRadius = 24.0
        payButton.titleLabel?.font = MeetDetailImmitdtFont
        payButton.addTarget(self, action: #selector(ApplyMeetView.applyMeetButtonClick(_:)), for: .touchUpInside)
        return payButton
    }
    
    func applyMeetButtonClick(_ sender:UIButton) {
        if isApplyOrder {
            UITools.showMessage(to: self, message: "预约提交中请稍后", autoHide: true)
            return
        }
        
        
        if applyText.text == "" {
            MainThreadAlertShow("未填写约见说明哦", view: self)
            return
        }
        
        if applyText.text.length > 300 {
            MainThreadAlertShow("约见说明超过最多300字限制了哦", view: self)
            return
        }
        
        if applyText.text.length < 15 {
            MainThreadAlertShow("约见说明可以再丰富些哦", view: self)
            return
        }
        self.isApplyOrder = true
        let applyModel = ApplyMeetModel()
        applyModel.appointment_desc = applyText.text;
        applyModel.appointment_theme = appointment_theme
        applyModel.host = self.host
        applyModel.guest = UserInfo.sharedInstance().uid
        viewModel.applyMeetOrder(applyModel, successBlock: { (dic) in
            let orderDic = dic! as [AnyHashable:Any] as NSDictionary
//            self.viewModel.orderDetail(orderDic.object(forKey: "order_id") as! String, successBlock: { (dic) in
//                let orderModel = OrderModel.mj_object(withKeyValues: dic?["order"])
//                UserDefaults.standard.set(dic?["customer_service_number"], forKey: "customer_service_number")
//                let applyDetailView = ConfirmedViewController()
//                applyDetailView.uid = self.host
//                applyDetailView.isAppliViewPush = true
//                applyDetailView.orderModel = orderModel
//                self.navigationController?.pushViewController(applyDetailView, animated: true)
//                }, fialBlock: { (dic) in
//                    
//            })
            self.dismissView()
            self.isApplyOrder = false
        }) { (dic) in
            let failDic = dic! as [AnyHashable:Any] as NSDictionary
            MainThreadAlertShow(failDic.object(forKey: "error") as! String, view: self)
            self.isApplyOrder = false
        }
    }

    
    func singPan(_ sender:UITapGestureRecognizer) {
        self.dismissView()
    }
    
    func dismissView() {
        self.removeFromSuperview()
    }
}

extension ApplyMeetView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let length = 300 - textView.text.length
//        introductionCell.numberText.text = "\(length)"
//        if textView.text.length > 280 {
//            introductionCell.numberText.isHidden = false
//        }else{
//            introductionCell.numberText.isHidden = true
//        }
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
}

