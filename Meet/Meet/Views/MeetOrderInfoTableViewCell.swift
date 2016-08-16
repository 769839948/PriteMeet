//
//  MeetInfoTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

enum MeetInfoType {
    case WaitMeet
    case WaitPay
    case Cancel
}


class MeetOrderInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var weChatNum: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var orderCreateTime: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var line1: UIView!
    
    @IBOutlet weak var meetTip: UILabel!
    @IBOutlet weak var line2: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func setData(model:OrderModel,type:MeetInfoType){
        if model.status?.status_code == "6" || model.status?.status_code == "11" || model.status?.status_code == "11" || model.status?.status_code == "11" {
            weChatNum.text = model.order_user_info?.weixin_num
            
            phoneNum.text = model.order_user_info?.mobile_num
            weChatNum.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
            phoneNum.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            phoneNum.font = UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)
            phoneNum.userInteractionEnabled = true
            let imageView = UIImageView()
            imageView.image = UIImage.init(named: "order_phone")
            imageView.frame = CGRectMake(ScreenWidth - 120, phoneNum.frame.origin.y, 9, 13)
            self.contentView.addSubview(imageView)
            
            let panTap = UITapGestureRecognizer(target: self, action: #selector(MeetOrderInfoTableViewCell.callbuttonClick(_:)))
            panTap.numberOfTapsRequired = 1
            panTap.numberOfTouchesRequired = 1
            phoneNum.addGestureRecognizer(panTap)
        }else {
            var str = ""
            if model.status?.status_type == "apply_code" {
                if model.status?.status_code == "1" {
                    str = "待对方确认及付款后可见"
                }else if model.status?.status_code == "4" {
                    str = "付款后可见"
                }else{
                    
                }
            }else{
                if model.status?.status_code == "1" {
                    str = "确认及对方付款后可见"
                }else if model.status?.status_code == "4" {
                    str = "对方付款后可见"
                }else{
                    
                }
            }
            phoneNum.text = str
            weChatNum.text = str
        }
        var time = model.created_at
        time = time.stringByReplacingOccurrencesOfString("T", withString: " ")
        time = time.stringByReplacingOccurrencesOfString("Z", withString: "")
        orderCreateTime.text = time
        UIView.drawDashLine(line, lineLength: 2, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        UIView.drawDashLine(line1, lineLength: 2, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        UIView.drawDashLine(line2, lineLength: 2, lineSpacing: 3, lineColor: UIColor.init(hexString: lineLabelBackgroundColor))
        
        if type == .WaitPay  {
            meetTip.hidden = true
            line2.hidden = true
        }else if type == .WaitMeet {
            let str = "你们已认识 \(model.meeted_days) 天了哦，聊得不错就赶快线下约见吧\n约见前别忘了先了解 约见贴士"
            let stringAttribute = NSMutableAttributedString(string: str)
            stringAttribute.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: MeProfileCollectViewItemSelect)], range: NSRange.init(location: str.length - 4, length: 4))
             stringAttribute.addAttributes([NSFontAttributeName:OrderMeetTipFont!], range: NSRange.init(location: str.length - 4, length: 4))
            meetTip.attributedText = stringAttribute
            meetTip.hidden = false
            line2.hidden = false
        }else if type == .Cancel {
            let str = "约见前别忘了先了解 约见贴士"
            let stringAttribute = NSMutableAttributedString(string: str)
            stringAttribute.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: MeProfileCollectViewItemSelect)], range: NSRange.init(location: str.length - 4, length: 4))
            stringAttribute.addAttributes([NSFontAttributeName:OrderMeetTipFont!], range: NSRange.init(location: str.length - 4, length: 4))
            meetTip.attributedText = stringAttribute
            line2.hidden = false
            meetTip.hidden = false

        }
    }
    
    func callbuttonClick(tap:UITapGestureRecognizer) {
        let str = "tel:\((phoneNum.text)!)"
        let callWebView = UIWebView()
        callWebView.loadRequest(NSURLRequest.init(URL: NSURL.init(string: str)!))
        self.addSubview(callWebView)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
