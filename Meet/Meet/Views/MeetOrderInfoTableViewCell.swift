//
//  MeetInfoTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

enum MeetInfoType {
    case PayDas
    case Normal
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
    
    var phoneimageView:UIImageView!
    
    var tapGesture:UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func setData(model:OrderModel,type:MeetInfoType){
        if model.status?.status_code == "6" || model.status?.status_code == "11"  {
            weChatNum.text = model.order_user_info?.weixin_num
            phoneNum.text = model.order_user_info?.mobile_num
            weChatNum.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
            phoneNum.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            phoneNum.font = UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)
            phoneNum.userInteractionEnabled = true
            phoneimageView = UIImageView()
            phoneimageView.hidden = false
            phoneimageView.image = UIImage.init(named: "order_phone")
            phoneimageView.frame = CGRectMake(ScreenWidth - 120, phoneNum.frame.origin.y, 9, 13)
            self.contentView.addSubview(phoneimageView)
            
            let panTap = UITapGestureRecognizer(target: self, action: #selector(MeetOrderInfoTableViewCell.callbuttonClick(_:)))
            panTap.numberOfTapsRequired = 1
            panTap.numberOfTouchesRequired = 1
            phoneNum.addGestureRecognizer(panTap)
        }else {
            if phoneimageView != nil {
                phoneimageView.hidden = true
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
        time = time.stringByReplacingOccurrencesOfString("T", withString: " ")
        time = time.stringByReplacingOccurrencesOfString("Z", withString: "")
        time = time.stringByReplacingOccurrencesOfString("-", withString: "-")
        orderCreateTime.attributedText = self.setStringAttribute("预约时间：\(time)")
        order_id.attributedText = self.setStringAttribute("预约单号：\(model.order_id)")
        UIView.drawDashLine(line, lineLength: 1, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        UIView.drawDashLine(line1, lineLength: 1, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        UIView.drawDashLine(line2, lineLength: 1, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(MeetOrderInfoTableViewCell.panTapClick(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        if type == .PayDas {
            let str = "你们已认识 \(model.meeted_days) 天了哦，聊得不错就赶快线下约见吧\n约见前别忘了先了解 约见贴士"
            let stringAttribute = NSMutableAttributedString(string: str)
            stringAttribute.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: MeProfileCollectViewItemSelect)], range: NSRange.init(location: str.length - 4, length: 4))
             stringAttribute.addAttributes([NSFontAttributeName:OrderMeetTipFont!], range: NSRange.init(location: str.length - 4, length: 4))
            meetTip.attributedText = stringAttribute
            meetTip.userInteractionEnabled = true
            meetTip.hidden = false
            line2.hidden = false
            meetTip.addGestureRecognizer(tapGesture)
        }else if type == .Normal {
            let str = "约见前别忘了先了解 约见贴士"
            let stringAttribute = NSMutableAttributedString(string: str)
            stringAttribute.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: MeProfileCollectViewItemSelect)], range: NSRange.init(location: str.length - 4, length: 4))
            stringAttribute.addAttributes([NSFontAttributeName:OrderMeetTipFont!], range: NSRange.init(location: str.length - 4, length: 4))
            meetTip.attributedText = stringAttribute
            line2.hidden = false
            meetTip.hidden = false
            meetTip.userInteractionEnabled = true
            meetTip.addGestureRecognizer(tapGesture)
        }
    }
    
    
    func setStringAttribute(string:String) -> NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: string)
        attribute.addAttributes([NSFontAttributeName:OrderPayViewPayInfoFont!], range: NSRange.init(location: 0, length: 5))
        return attribute
    }
    
    func callbuttonClick(tap:UITapGestureRecognizer) {
        let str = "tel:\((phoneNum.text)!)"
        let callWebView = UIWebView()
        callWebView.loadRequest(NSURLRequest.init(URL: NSURL.init(string: str)!))
        self.addSubview(callWebView)
    }
    
    func panTapClick(tap:UIPanGestureRecognizer) {
        let tips:String = (PlaceholderText.shareInstance().appDic as NSDictionary).objectForKey("1000006") as! String
        let orderTips = OrderTips(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight), tips: tips.componentsSeparatedByString("\n"))
        KeyWindown?.addSubview(orderTips)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
