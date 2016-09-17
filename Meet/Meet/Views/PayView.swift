//
//  PayView.swift
//  PayView
//
//  Created by Zhang on 8/10/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import pop

enum PayType {
    case weiChat
    case aliPay
}

let PayViewHeight:CGFloat = (WXApi.isWXAppInstalled()) ? 400:340

typealias PayViewTypeChange = (_ tag:NSInteger) ->Void
typealias PaySelectItem = (_ payType:String) ->Void

class PayViewType: UIView {
    
    var imageView:UIImageView!
    var payTypeLabel:UILabel!
    var payTypeDetail:UILabel!
    var paySelect:UIImageView!
    var lineLabel:UIView!
    var panTap:UITapGestureRecognizer!
    var payViewTypeChange:PayViewTypeChange! = nil
    var selectImage:UIImageView!
    
    init(frame:CGRect,type:PayType){
        super.init(frame: frame)
        self.setUpView(type)
        panTap = UITapGestureRecognizer(target: self, action: #selector(PayViewType.panTapClick(_:)))
        panTap.numberOfTapsRequired = 1
        panTap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(panTap)
    }
    
    func setUpView(_ type:PayType) {
        imageView = UIImageView(frame: CGRect(x: 20, y: 18, width: 32, height: 32))
        self.addSubview(imageView)
        
        selectImage = UIImageView(frame: CGRect(x: ScreenWidth - 44, y: 20, width: 24, height: 24))
        self.selectImage.image = UIImage.init(named: "pay_unselect")
        self.addSubview(selectImage)
        
        payTypeLabel = UILabel(frame: CGRect(x: 63,y: 16,width: 100,height: 20))
        payTypeLabel.font = OrderPayViewPayTitleFont
        payTypeLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        self.addSubview(payTypeLabel)
        
        payTypeDetail = UILabel(frame: CGRect(x: 63,y: 35,width: ScreenWidth - 63 * 2,height: 20))
        payTypeDetail.font = OrderPayViewPayDetailFont
        payTypeDetail.textColor = UIColor.init(hexString: HomeDetailViewMeetNumberColor)
        self.addSubview(payTypeDetail)
        
        lineLabel = UILabel(frame: CGRect(x: 20,y: 64,width: ScreenWidth - 40,height: 0.5))
        self.addSubview(lineLabel)
        
        UIView.drawDashLine(lineLabel, lineLength: 1, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))

        switch type {
        case .weiChat:
            imageView.image = UIImage.init(named: "pay_Wechat")
            payTypeLabel.text = "微信支付"
            payTypeDetail.text = "亿万用户的选择，更快更安全"
            self.tag = 10000
        default:
            imageView.image = UIImage.init(named: "pay_Alipay")
            payTypeLabel.text = "支付宝支付"
            payTypeDetail.text = "推荐支付宝用户使用"
            self.tag = 20000
        }
    }
    
    func panTapClick(_ sender:UITapGestureRecognizer) {
        let tag = sender.view?.tag
        self.selectImage.image = UIImage.init(named: "pay_select")
        if self.payViewTypeChange != nil {
            self.payViewTypeChange(tag!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class PayView: UIView {

    var backView:UIView!
    var singPan:UITapGestureRecognizer!
    var payView:UIView!
    var nameLabel:UILabel!
    var infoLabel:UILabel!
    var muchLabel:UILabel!
    
    var payInfoView:UIView!
    var paySelectItem:PaySelectItem!
    var payString:String = "weiChat"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
        self.setUpSingPan()
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
        
        payView = UIView(frame: CGRect(x: 0,y: ScreenHeight,width: ScreenWidth,height: PayViewHeight))
        payView.backgroundColor = UIColor.white
        self.configPayView()
        payView.addSubview(self.payViewTitleView(CGRect(x: 0, y: 0, width: ScreenWidth, height: 66)))
        payView.addSubview(self.orderInfoView(CGRect(x: 0,y: PayViewHeight - 200,width: ScreenWidth,height: 120)))
        payView.addSubview(self.payButton())
        self.addSubview(payView)
        
        payInfoView = UIView(frame: CGRect(x: ScreenWidth,y: ScreenHeight - PayViewHeight + 4,width: ScreenWidth,height: PayViewHeight - 100))
        payInfoView.backgroundColor = UIColor.white
        payInfoView.addSubview(self.payInfoViewTitleView(CGRect(x: 0, y: 0, width: ScreenWidth, height: 66)))
        payInfoView.addSubview(self.payOrderInfoView(CGRect(x: 0, y: 66, width: ScreenWidth, height: 66)))
        self.addSubview(payInfoView)

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.payView.frame = CGRect(x: 0, y: ScreenHeight - PayViewHeight, width: ScreenWidth, height: PayViewHeight)
            }) { (finish) in
                
        }
    }

    func setUpData(_ name:String, themes:NSString, much:String) {
        nameLabel.text = "约见人: \(name)"
        infoLabel.text = "约见形式: \(themes)"
        muchLabel.text = "￥\(much)"
    }
    
    func payInfoViewTitleView(_ frame:CGRect) ->UIView {
        let payInfoViewTitle = UIView(frame: frame)
        let titleLabel = UILabel(frame: CGRect(x: (ScreenWidth - 56)/2,y: 26,width: 56,height: 20))
        titleLabel.text = "费用说明"
        titleLabel.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        titleLabel.font = OrderPayViewTitleFont
        payInfoViewTitle.addSubview(titleLabel)
        
        
        let disMissBtn = UIButton(type: .custom)
        disMissBtn.addTarget(self, action: #selector(PayView.dismissView), for: .touchUpInside)
        disMissBtn.setImage(UIImage.init(named: "pay_dismiss"), for: UIControlState())
        disMissBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 40, y: 26, width: 20, height: 20)
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
            self.payInfoView.frame = CGRect(x: ScreenWidth, y: ScreenHeight - PayViewHeight, width: ScreenWidth, height: PayViewHeight - 100)
        }) { (finish) in
            
        }
    }
    
    func configPayView() {
        if WXApi.isWXAppInstalled() {
            let weChatPay = PayViewType.init(frame: CGRect(x: 0, y: 66, width: UIScreen.main.bounds.size.width, height: 60), type: .weiChat)
            weChatPay.selectImage.image = UIImage.init(named: "pay_select")
            payView.addSubview(weChatPay)
            
            let aliPay = PayViewType.init(frame: CGRect(x: 0, y: weChatPay.frame.maxY, width: UIScreen.main.bounds.size.width, height: 60), type: .aliPay)
            weChatPay.payViewTypeChange = { tag in
                aliPay.selectImage.image = UIImage.init(named: "pay_unselect")
                self.payString = "weiChat"
            }
            aliPay.payViewTypeChange = { tag in
                weChatPay.selectImage.image = UIImage.init(named: "pay_unselect")
                self.payString = "aliPay"
            }
             payView.addSubview(aliPay)
        }else{
            let aliPay = PayViewType.init(frame: CGRect(x: 0, y: 66, width: UIScreen.main.bounds.size.width, height: 60), type: .aliPay)
            aliPay.selectImage.image = UIImage.init(named: "pay_select")
            aliPay.payViewTypeChange = { tag in
                self.payString = "aliPay"
            }
            payView.addSubview(aliPay)
        }
    }
    
    func payViewTitleView(_ frame:CGRect) ->UIView {
        let payViewTitle = UIView(frame: frame)
        let titleLabel = UILabel(frame: CGRect(x: 20,y: 26,width: 56,height: 20))
        titleLabel.text = "付款详情"
        titleLabel.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        titleLabel.font = OrderPayViewTitleFont
        payViewTitle.addSubview(titleLabel)
        
        
        let disMissBtn = UIButton(type: .custom)
        disMissBtn.addTarget(self, action: #selector(PayView.dismissView), for: .touchUpInside)
        disMissBtn.setImage(UIImage.init(named: "pay_dismiss"), for: UIControlState())
        disMissBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 40, y: 26, width: 20, height: 20)
        payViewTitle.addSubview(disMissBtn)
        
        
        let lineLabel = UILabel(frame: CGRect(x: 20,y: 64,width: UIScreen.main.bounds.size.width - 40,height: 2))
        lineLabel.backgroundColor = UIColor.init(hexString: MeViewProfileBackGroundColor)
        payViewTitle.addSubview(lineLabel)
        
        return payViewTitle
    }
    
    func orderInfoView(_ frame:CGRect) -> UIView{
        let orderInfoView = UIView(frame:frame)
        nameLabel = UILabel(frame: CGRect(x: 20,y: 14,width: ScreenWidth,height: 16))
        nameLabel.text = "约见人:换 订单"
        nameLabel.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        nameLabel.font = OrderPayViewPayInfoFont
        orderInfoView.addSubview(nameLabel)
        
        infoLabel = UILabel(frame: CGRect(x: 20,y: nameLabel.frame.maxY,width: UIScreen.main.bounds.size.width,height: 16))
        infoLabel.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        infoLabel.text = "约见形式:喝咖啡、看定影"
        infoLabel.font = OrderPayViewPayInfoFont
        orderInfoView.addSubview(infoLabel)
        
        let numberOfMuch = UILabel(frame: CGRect(x: 20,y: 80,width: 48,height: 17))
        numberOfMuch.text = "付款总额"
        numberOfMuch.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        numberOfMuch.font = OrderPayViewPayAllNumFont
        orderInfoView.addSubview(numberOfMuch)

        muchLabel = UILabel(frame: CGRect(x: ScreenWidth - 200,y: 73,width: 150,height: 29))
        muchLabel.text = "￥50.00"
        muchLabel.textAlignment = .right
        muchLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        muchLabel.font = OrderPayViewPayMuchFont
        orderInfoView.addSubview(muchLabel)
        
        let payImage = UIImageView(frame: CGRect(x: muchLabel.frame.maxX + 12, y: 80, width: 14, height: 14))
        payImage.image = UIImage.init(named: "pay_info")
        
        let panTap = UITapGestureRecognizer(target: self, action: #selector(PayView.showPayDetail(_:)))
        panTap.numberOfTapsRequired = 1
        panTap.numberOfTouchesRequired = 1
        payImage.isUserInteractionEnabled = true
        payImage.addGestureRecognizer(panTap)
        orderInfoView.addSubview(payImage)
        
        return orderInfoView
    }
    
    func showPayDetail(_ sender:UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.payInfoView.frame = CGRect(x: 0, y: ScreenHeight - PayViewHeight, width: ScreenWidth, height: PayViewHeight - 100)
        }) { (finish) in
            
        }
    }
    
    func payButton() ->UIButton{
        let payButton = UIButton(type: .custom)
        payButton.frame = CGRect(x: 20, y: payView.frame.size.height - 75, width: ScreenWidth - 40, height: 45)
        payButton.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        payButton.setTitle("立即支付", for: UIControlState())
        payButton.layer.cornerRadius = 24.0
        payButton.titleLabel?.font = MeetDetailImmitdtFont
        payButton.addTarget(self, action: #selector(PayView.payButtonClick(_:)), for: .touchUpInside)
        return payButton
    }
    
    func payButtonClick(_ sender:UIButton) {
        if self.paySelectItem != nil {
            self.paySelectItem(self.payString)
            self.dismissView()
        }
    }
    
    func singPan(_ sender:UITapGestureRecognizer) {
        self.dismissView()
    }

    func dismissView() {
        self.removeFromSuperview()
    }
}
