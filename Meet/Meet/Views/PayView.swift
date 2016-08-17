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
    case WeiChat
    case AliPay
}

let PayViewHeight:CGFloat = (WXApi.isWXAppInstalled()) ? 400:340

typealias PayViewTypeChange = (tag:NSInteger) ->Void
typealias PaySelectItem = (payType:String) ->Void

class PayViewType: UIView {
    
    var imageView:UIImageView!
    var payTypeLabel:UILabel!
    var payTypeDetail:UILabel!
    var paySelect:UIImageView!
    var lineLabel:UIView!
    var panTap:UITapGestureRecognizer!
    var payViewTypeChange:PayViewTypeChange!
    var selectImage:UIImageView!
    
    init(frame:CGRect,type:PayType){
        super.init(frame: frame)
        self.setUpView(type)
        panTap = UITapGestureRecognizer(target: self, action: #selector(PayViewType.panTapClick(_:)))
        panTap.numberOfTapsRequired = 1
        panTap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(panTap)
    }
    
    func setUpView(type:PayType) {
        imageView = UIImageView(frame: CGRectMake(20, 20, 32, 32))
        self.addSubview(imageView)
        
        selectImage = UIImageView(frame: CGRectMake(ScreenWidth - 44, 20, 24, 24))
        self.selectImage.image = UIImage.init(named: "pay_unselect")
        self.addSubview(selectImage)
        
        payTypeLabel = UILabel(frame: CGRectMake(63,16,100,20))
        payTypeLabel.font = OrderPayViewPayTitleFont
        payTypeLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        self.addSubview(payTypeLabel)
        
        payTypeDetail = UILabel(frame: CGRectMake(63,35,ScreenWidth - 63 * 2,20))
        payTypeDetail.font = OrderPayViewPayDetailFont
        payTypeDetail.textColor = UIColor.init(hexString: HomeDetailViewMeetNumberColor)
        self.addSubview(payTypeDetail)
        
        lineLabel = UILabel(frame: CGRectMake(20,64,ScreenWidth - 40,0.5))
        self.addSubview(lineLabel)
        
        UIView.drawDashLine(lineLabel, lineLength: 2, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))

        switch type {
        case .WeiChat:
            imageView.image = UIImage.init(named: "pay_weChat")
            payTypeLabel.text = "微信支付"
            payTypeDetail.text = "亿万用户的选择，更快更安全"
            self.tag = 10000
        default:
            imageView.image = UIImage.init(named: "pay_AliPay")
            payTypeLabel.text = "支付宝支付"
            payTypeDetail.text = "推荐支付宝用户使用"
            self.tag = 20000
        }
    }
    
    func panTapClick(sender:UITapGestureRecognizer) {
        let tag = sender.view?.tag
        self.selectImage.image = UIImage.init(named: "pay_select")
        if self.payViewTypeChange != nil {
            self.payViewTypeChange(tag: tag!)
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
        backView = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height))
        backView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addSubview(backView)
        
        payView = UIView(frame: CGRectMake(0,ScreenHeight,ScreenWidth,PayViewHeight))
        payView.backgroundColor = UIColor.whiteColor()
        self.configPayView()
        payView.addSubview(self.payViewTitleView(CGRectMake(0, 0, ScreenWidth, 66)))
        payView.addSubview(self.orderInfoView(CGRectMake(0,PayViewHeight - 200,ScreenWidth,120)))
        payView.addSubview(self.payButton())
        self.addSubview(payView)
        
        payInfoView = UIView(frame: CGRectMake(ScreenWidth,ScreenHeight - PayViewHeight + 4,ScreenWidth,PayViewHeight - 100))
        payInfoView.backgroundColor = UIColor.whiteColor()
        payInfoView.addSubview(self.payInfoViewTitleView(CGRectMake(0, 0, ScreenWidth, 66)))
        payInfoView.addSubview(self.payOrderInfoView(CGRectMake(0, 66, ScreenWidth, 66)))
        self.addSubview(payInfoView)

        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.payView.frame = CGRectMake(0, ScreenHeight - PayViewHeight, ScreenWidth, PayViewHeight)
            }) { (finish) in
                
        }
    }

    func setUpData(name:String, themes:NSString, much:String) {
        nameLabel.text = "约见人: \(name)"
        infoLabel.text = "约见形式: \(themes)"
        muchLabel.text = "￥\(much)"
    }
    
    func payInfoViewTitleView(frame:CGRect) ->UIView {
        let payInfoViewTitle = UIView(frame: frame)
        let titleLabel = UILabel(frame: CGRectMake((ScreenWidth - 56)/2,26,56,20))
        titleLabel.text = "费用说明"
        titleLabel.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        titleLabel.font = OrderPayViewTitleFont
        payInfoViewTitle.addSubview(titleLabel)
        
        
        let disMissBtn = UIButton(type: .Custom)
        disMissBtn.addTarget(self, action: #selector(PayView.dismissView), forControlEvents: .TouchUpInside)
        disMissBtn.setImage(UIImage.init(named: "pay_dismiss"), forState: .Normal)
        disMissBtn.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - 40, 26, 20, 20)
        payInfoViewTitle.addSubview(disMissBtn)
        
        let backBtn = UIButton(type: .Custom)
        backBtn.addTarget(self, action: #selector(PayView.backBtnClick), forControlEvents: .TouchUpInside)
        backBtn.setImage(UIImage.init(named: "login_leftBtn"), forState: .Normal)
        backBtn.frame = CGRectMake(20, 26, 20, 20)
        payInfoViewTitle.addSubview(backBtn)
        
        let lineLabel = UILabel(frame: CGRectMake(20,64,UIScreen.mainScreen().bounds.size.width - 40,2))
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        payInfoViewTitle.addSubview(lineLabel)
        
        return payInfoViewTitle
    }
    
    func payOrderInfoView(frame:CGRect) -> UIView{
        let payOrderInfoView = UIView(frame: frame)
        let infoLabel = UILabel(frame:CGRectMake(20,26,ScreenWidth - 20,100))
        let str = "约见成功，Meet 将收取 48 元平台费用。\n对方接受约见后，您才需付款。\n付款成功后，双方可互见联系电话及微信。\n见面前，任何一方放弃约见，约见费用立即全额退还。"
        infoLabel.numberOfLines = 0
        let attributeString = NSMutableAttributedString(string: str)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .ByWordWrapping
        paragraph.alignment = .Left
        paragraph.lineSpacing = 5.0
        attributeString.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: HomeDetailViewPositionColor)], range: NSRange.init(location: 0, length: str.length))
        attributeString.addAttributes([NSParagraphStyleAttributeName:paragraph], range: NSRange.init(location: 0, length: str.length))
        attributeString.addAttributes([NSFontAttributeName:OrderInfoPayDetailFont!], range: NSRange.init(location: 0, length: str.length))
        infoLabel.attributedText = attributeString
        payOrderInfoView.addSubview(infoLabel)
        return payOrderInfoView
    }
    
    func backBtnClick(sender:UIButton) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.payInfoView.frame = CGRectMake(ScreenWidth, ScreenHeight - PayViewHeight, ScreenWidth, PayViewHeight - 100)
        }) { (finish) in
            
        }
    }
    
    func configPayView() {
        if WXApi.isWXAppInstalled() {
            let weChatPay = PayViewType.init(frame: CGRectMake(0, 66, UIScreen.mainScreen().bounds.size.width, 60), type: .WeiChat)
            weChatPay.selectImage.image = UIImage.init(named: "pay_select")
            payView.addSubview(weChatPay)
            
            let aliPay = PayViewType.init(frame: CGRectMake(0, CGRectGetMaxY(weChatPay.frame), UIScreen.mainScreen().bounds.size.width, 60), type: .AliPay)
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
            let aliPay = PayViewType.init(frame: CGRectMake(0, 66, UIScreen.mainScreen().bounds.size.width, 60), type: .AliPay)
            aliPay.selectImage.image = UIImage.init(named: "pay_select")
            aliPay.payViewTypeChange = { tag in
                self.payString = "aliPay"
            }
            payView.addSubview(aliPay)
        }
    }
    
    func payViewTitleView(frame:CGRect) ->UIView {
        let payViewTitle = UIView(frame: frame)
        let titleLabel = UILabel(frame: CGRectMake(20,26,56,20))
        titleLabel.text = "付款详情"
        titleLabel.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        titleLabel.font = OrderPayViewTitleFont
        payViewTitle.addSubview(titleLabel)
        
        
        let disMissBtn = UIButton(type: .Custom)
        disMissBtn.addTarget(self, action: #selector(PayView.dismissView), forControlEvents: .TouchUpInside)
        disMissBtn.setImage(UIImage.init(named: "pay_dismiss"), forState: .Normal)
        disMissBtn.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - 40, 26, 20, 20)
        payViewTitle.addSubview(disMissBtn)
        
        
        let lineLabel = UILabel(frame: CGRectMake(20,64,UIScreen.mainScreen().bounds.size.width - 40,2))
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        payViewTitle.addSubview(lineLabel)
        
        return payViewTitle
    }
    
    func orderInfoView(frame:CGRect) -> UIView{
        let orderInfoView = UIView(frame:frame)
        nameLabel = UILabel(frame: CGRectMake(20,14,ScreenWidth,16))
        nameLabel.text = "约见人:换 订单"
        nameLabel.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        nameLabel.font = OrderPayViewPayInfoFont
        orderInfoView.addSubview(nameLabel)
        
        infoLabel = UILabel(frame: CGRectMake(20,CGRectGetMaxY(nameLabel.frame),UIScreen.mainScreen().bounds.size.width,16))
        infoLabel.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        infoLabel.text = "约见形式:喝咖啡、看定影"
        infoLabel.font = OrderPayViewPayInfoFont
        orderInfoView.addSubview(infoLabel)
        
        let numberOfMuch = UILabel(frame: CGRectMake(20,80,48,17))
        numberOfMuch.text = "付款总额"
        numberOfMuch.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        numberOfMuch.font = OrderPayViewPayAllNumFont
        orderInfoView.addSubview(numberOfMuch)

        muchLabel = UILabel(frame: CGRectMake(ScreenWidth - 200,73,150,29))
        muchLabel.text = "￥50.00"
        muchLabel.textAlignment = .Right
        muchLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        muchLabel.font = OrderPayViewPayMuchFont
        orderInfoView.addSubview(muchLabel)
        
        let payImage = UIImageView(frame: CGRectMake(CGRectGetMaxX(muchLabel.frame) + 12, 80, 14, 14))
        payImage.image = UIImage.init(named: "pay_info")
        
        let panTap = UITapGestureRecognizer(target: self, action: #selector(PayView.showPayDetail(_:)))
        panTap.numberOfTapsRequired = 1
        panTap.numberOfTouchesRequired = 1
        payImage.userInteractionEnabled = true
        payImage.addGestureRecognizer(panTap)
        orderInfoView.addSubview(payImage)
        
        return orderInfoView
    }
    
    func showPayDetail(sender:UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.payInfoView.frame = CGRectMake(0, ScreenHeight - PayViewHeight, ScreenWidth, PayViewHeight - 100)
        }) { (finish) in
            
        }
    }
    
    func payButton() ->UIButton{
        let payButton = UIButton(type: .Custom)
        payButton.frame = CGRectMake(20, payView.frame.size.height - 75, ScreenWidth - 40, 45)
        payButton.backgroundColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        payButton.setTitle("立即支付", forState: .Normal)
        payButton.layer.cornerRadius = 24.0
        payButton.titleLabel?.font = MeetDetailImmitdtFont
        payButton.addTarget(self, action: #selector(PayView.payButtonClick(_:)), forControlEvents: .TouchUpInside)
        return payButton
    }
    
    func payButtonClick(sender:UIButton) {
        if self.paySelectItem != nil {
            self.paySelectItem(payType:self.payString)
            self.dismissView()
        }
    }
    
    func singPan(sender:UITapGestureRecognizer) {
        self.dismissView()
    }

    func dismissView() {
        self.removeFromSuperview()
    }
}
