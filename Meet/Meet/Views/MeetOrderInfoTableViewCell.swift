//
//  MeetInfoTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

enum MeetInfoType {
    case payDas
    case normal
}


class MeetOrderInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var weChatNum: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var orderCreateTime: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var line1: UIView!
    
    @IBOutlet weak var order_id: UILabel!
    
    @IBOutlet weak var meetTip: UILabel!
    @IBOutlet weak var line2: UIView!
    
    @IBOutlet weak var contactInfo: UILabel!
    var phoneimageView:UIImageView!
    
    var tapGesture:UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func setData(_ model:OrderModel,type:MeetInfoType){
        if model.status?.status_code == "6" || model.status?.status_code == "11"  {
            weChatNum.text = model.order_user_info?.weixin_num
            phoneNum.text = model.order_user_info?.mobile_num
            weChatNum.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
            phoneNum.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            phoneNum.font = UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)
            phoneNum.isUserInteractionEnabled = true
            phoneimageView = UIImageView()
            phoneimageView.isHidden = false
            phoneimageView.image = UIImage.init(named: "order_phone")
            phoneimageView.frame = CGRect(x: ScreenWidth - 120, y: phoneNum.frame.origin.y, width: 9, height: 13)
            self.contentView.addSubview(phoneimageView)
            
            let panTap = UITapGestureRecognizer(target: self, action: #selector(MeetOrderInfoTableViewCell.callbuttonClick(_:)))
            panTap.numberOfTapsRequired = 1
            panTap.numberOfTouchesRequired = 1
            phoneNum.addGestureRecognizer(panTap)
        }else {
            if phoneimageView != nil {
                phoneimageView.isHidden = true
            }
            var str = ""
            if model.status?.status_type == "apply_order" {
                if model.status?.status_code == "1" {
                    str = "对方确认及付款后可见"
                }else if model.status?.status_code == "4" {
                    str = "付款后可见"
                }else{
                    str = "已关闭预约下不可见"
                }
            }else{
                if model.status?.status_code == "1" {
                    str = "接受及对方付款后可见"
                }else if model.status?.status_code == "4" {
                    str = "对方付款后可见"
                }else{
                    str = "已关闭预约下不可见"
                }
            }
            weChatNum.textColor = UIColor.init(hexString: ApplyCodeNextBtnColorDis)
            phoneNum.textColor = UIColor.init(hexString: ApplyCodeNextBtnColorDis)
            weChatNum.font = OrderPayViewPayAllNumFont
            phoneNum.font = OrderPayViewPayAllNumFont
            phoneNum.text = str
            weChatNum.text = str
        }
        var time = model.created_at
        time = time.replacingOccurrences(of: "T", with: " ")
        time = time.replacingOccurrences(of: "Z", with: "")
        time = time.replacingOccurrences(of: "-", with: "-")
        orderCreateTime.attributedText = self.setStringAttribute("预约时间：\(time)")
        order_id.attributedText = self.setStringAttribute("预约单号：\(model.order_id)")
        UIView.drawDashLine(line, lineLength: 1, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        UIView.drawDashLine(line1, lineLength: 1, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        UIView.drawDashLine(line2, lineLength: 1, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(MeetOrderInfoTableViewCell.panTapClick(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        if type == .payDas {
            let str = "你们已认识 \(model.meeted_days) 天了哦，聊得不错就赶快线下约见吧\n约见前别忘了先了解 约见贴士"
            let stringAttribute = NSMutableAttributedString(string: str)
            stringAttribute.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: MeProfileCollectViewItemSelect)], range: NSRange.init(location: str.length - 4, length: 4))
             stringAttribute.addAttributes([NSFontAttributeName:OrderMeetTipFont!], range: NSRange.init(location: str.length - 4, length: 4))
            meetTip.attributedText = stringAttribute
            meetTip.isUserInteractionEnabled = true
            meetTip.isHidden = false
            line2.isHidden = false
            meetTip.addGestureRecognizer(tapGesture)
        }else if type == .normal {
            let str = "约见前别忘了先了解 约见贴士"
            let stringAttribute = NSMutableAttributedString(string: str)
            stringAttribute.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: MeProfileCollectViewItemSelect)], range: NSRange.init(location: str.length - 4, length: 4))
            stringAttribute.addAttributes([NSFontAttributeName:OrderMeetTipFont!], range: NSRange.init(location: str.length - 4, length: 4))
            meetTip.attributedText = stringAttribute
            line2.isHidden = false
            meetTip.isHidden = false
            meetTip.isUserInteractionEnabled = true
            meetTip.addGestureRecognizer(tapGesture)
        }
        
        if model.order_user_info?.gender == 1 {
            contactInfo.text = "他的联系方式"
        }else{
            contactInfo.text = "她的联系方式"
        }
        self.updateConstraintsIfNeeded()
    }
    
    
    func setStringAttribute(_ string:String) -> NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: string)
        attribute.addAttributes([NSFontAttributeName:OrderPayViewPayInfoFont!], range: NSRange.init(location: 0, length: 5))
        return attribute
    }
    
    func callbuttonClick(_ tap:UITapGestureRecognizer) {
        let str = "tel:\((phoneNum.text)!)"
        let callWebView = UIWebView()
        callWebView.loadRequest(URLRequest.init(url: URL.init(string: str)!))
        self.addSubview(callWebView)
    }
    
    func panTapClick(_ tap:UIPanGestureRecognizer) {
        let tips:String = (PlaceholderText.shareInstance().appDic as NSDictionary).object(forKey: "1000006") as! String
        let orderTips = OrderTips(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), tips: tips.components(separatedBy: "\n"))
        KeyWindown?.addSubview(orderTips)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
