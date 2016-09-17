//
//  OrderFlowTableViewCell.swift
//  Meet
//
//  Created by Zhang on 7/19/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

let flowViewWidth:CGFloat = 249

class OrderFlowTableViewCell: UITableViewCell {

    let orderStatusArray:NSArray = ["提交申请","待确认","待付款","待见面"]
    let font_orderStatus:NSArray = ["待确认","待付款","待见面"]
    var flowView:ZDQFlowView!
    var orderStatus:String!
    var statusType:String!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        flowView = ZDQFlowView(frame: CGRect(x: (UIScreen.main.bounds.size.width - flowViewWidth) / 2,y: 28,width: flowViewWidth,height: 51))
        flowView.dataSource = self
        self.contentView.addSubview(flowView)
    }
    
    func setData(_ status:String,statusType:String) {
        self.orderStatus = status
        self.statusType = statusType
        flowView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OrderFlowTableViewCell: ZDQFlowViewDataSource {
    func numberOfFlowViewItemCount(_ flowView: ZDQFlowView) -> NSInteger {
        if self.statusType == "receive_order" {
            if orderStatus == "7" || orderStatus == "8" || orderStatus == "12" || orderStatus == "13" || orderStatus == "9" || orderStatus == "10" {
                return 4
            }else{
                return 3
            }
        }
        return 4
    }
    
    func numberOfFlowViewItem(_ flowView: ZDQFlowView, index: NSInteger) -> ZDQFlowViewItem {
        if self.statusType == "receive_order" {
            let viewItem = ZDQFlowViewItem()
            if orderStatus == "1"{
                switch index {
                case 0:
                    viewItem.setData("待确认",type: ZDQFlowViewItemType.itemWaitSelect)
                case 1:
                    viewItem.setData("对方付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "2" {
                switch index {
                case 0:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.itemCancel)
                case 1:
                    viewItem.setData("对方付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "3" {
                switch index {
                case 0:
                    viewItem.setData("已拒绝",type: ZDQFlowViewItemType.itemCancel)
                case 1:
                    viewItem.setData("对方付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "4" || orderStatus == "5" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemSelect)
                case 1:
                    viewItem.setData("对方付款",type: ZDQFlowViewItemType.itemWaitSelect)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }
            else if orderStatus == "6" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemSelect)
                case 1:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.itemSelect)
                default:
                    viewItem.setData("待见面",type: ZDQFlowViewItemType.itemWaitSelect)
                }
            }else if orderStatus == "7" || orderStatus == "8" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.itemCancelDone)
                case 2:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.itemCancel)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "9" || orderStatus == "10" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.itemCancelDone)
                case 2:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.itemCancel)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "11" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemSelect)
                case 1:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.itemSelect)
                default:
                    viewItem.setData("已见面",type: ZDQFlowViewItemType.itemSelect)
                }
            }else if orderStatus == "12"  {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.itemCancel)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "13"  {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.itemCancel)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }
            return viewItem
        }else{
            let viewItem = ZDQFlowViewItem()
            if orderStatus == "0"{
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemWaitSelect)
                case 1:
                    viewItem.setData("对方确认",type: ZDQFlowViewItemType.itemNext)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "1"{
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemSelect)
                case 1:
                    viewItem.setData("对方确认",type: ZDQFlowViewItemType.itemWaitSelect)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "2"{
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.itemCancel)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "3" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("预约未接受",type: ZDQFlowViewItemType.itemCancel)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.itemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "4" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemSelect)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemSelect)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.itemWaitSelect)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "6" || orderStatus == "5" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemSelect)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemSelect)
                case 2:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.itemSelect)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemWaitSelect)
                }
            }else if orderStatus == "7" || orderStatus == "8" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemCancelDone)
                case 2:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.itemCancelDone)
                default:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.itemCancel)
                }
            }else if orderStatus == "9" || orderStatus == "10" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemCancelDone)
                case 2:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.itemCancelDone)
                default:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.itemCancel)
                }
            }else if orderStatus == "11" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemSelect)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemSelect)
                case 2:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.itemSelect)
                default:
                    viewItem.setData("已见面",type: ZDQFlowViewItemType.itemSelect)
                }
            }else if orderStatus == "12" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemCancelDone)
                case 2:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.itemCancel)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }else if orderStatus == "13" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.itemCancelDone)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.itemCancelDone)
                case 2:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.itemCancel)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.itemNext)
                }
            }
            return viewItem
        }
    }
    
    func flowViewItemSize(_ flowView: ZDQFlowView) -> CGSize {
        return CGSize(width: 45, height: 57)
    }
}
