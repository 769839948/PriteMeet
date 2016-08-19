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
        flowView = ZDQFlowView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - flowViewWidth) / 2,28,flowViewWidth,51))
        flowView.dataSource = self
        self.contentView.addSubview(flowView)
    }
    
    func setData(status:String,statusType:String) {
        self.orderStatus = status
        self.statusType = statusType
        flowView.reloadData()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OrderFlowTableViewCell: ZDQFlowViewDataSource {
    func numberOfFlowViewItemCount(flowView: ZDQFlowView) -> NSInteger {
        if self.statusType == "receive_order" {
            if orderStatus == "7" || orderStatus == "8" || orderStatus == "12" || orderStatus == "13" || orderStatus == "9" || orderStatus == "10" {
                return 4
            }else{
                return 3
            }
        }
        return 4
    }
    
    func numberOfFlowViewItem(flowView: ZDQFlowView, index: NSInteger) -> ZDQFlowViewItem {
        if self.statusType == "receive_order" {
            let viewItem = ZDQFlowViewItem()
            if orderStatus == "1"{
                switch index {
                case 0:
                    viewItem.setData("待确认",type: ZDQFlowViewItemType.ItemWaitSelect)
                case 1:
                    viewItem.setData("对方付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "2" {
                switch index {
                case 0:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.ItemCancel)
                case 1:
                    viewItem.setData("对方付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "3" {
                switch index {
                case 0:
                    viewItem.setData("已拒绝",type: ZDQFlowViewItemType.ItemCancel)
                case 1:
                    viewItem.setData("对方付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "4" || orderStatus == "5" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemSelect)
                case 1:
                    viewItem.setData("对方付款",type: ZDQFlowViewItemType.ItemWaitSelect)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }
            else if orderStatus == "6" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemSelect)
                case 1:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.ItemSelect)
                default:
                    viewItem.setData("待见面",type: ZDQFlowViewItemType.ItemWaitSelect)
                }
            }else if orderStatus == "7" || orderStatus == "8" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.ItemCancelDone)
                case 2:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.ItemCancel)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "9" || orderStatus == "10" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.ItemCancelDone)
                case 2:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.ItemCancel)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "11" {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemSelect)
                case 1:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.ItemSelect)
                default:
                    viewItem.setData("已见面",type: ZDQFlowViewItemType.ItemSelect)
                }
            }else if orderStatus == "12"  {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.ItemCancel)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "13"  {
                switch index {
                case 0:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.ItemCancel)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }
            return viewItem
        }else{
            let viewItem = ZDQFlowViewItem()
            if orderStatus == "0"{
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemWaitSelect)
                case 1:
                    viewItem.setData("对方确认",type: ZDQFlowViewItemType.ItemNext)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "1"{
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemSelect)
                case 1:
                    viewItem.setData("对方确认",type: ZDQFlowViewItemType.ItemWaitSelect)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "2"{
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.ItemCancel)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "3" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("预约未接受",type: ZDQFlowViewItemType.ItemCancel)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.ItemNext)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "4" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemSelect)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemSelect)
                case 2:
                    viewItem.setData("付款",type: ZDQFlowViewItemType.ItemWaitSelect)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "6" || orderStatus == "5" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemSelect)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemSelect)
                case 2:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.ItemSelect)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemWaitSelect)
                }
            }else if orderStatus == "7" || orderStatus == "8" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemCancelDone)
                case 2:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.ItemCancelDone)
                default:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.ItemCancel)
                }
            }else if orderStatus == "9" || orderStatus == "10" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemCancelDone)
                case 2:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.ItemCancelDone)
                default:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.ItemCancel)
                }
            }else if orderStatus == "11" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemSelect)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemSelect)
                case 2:
                    viewItem.setData("已付款",type: ZDQFlowViewItemType.ItemSelect)
                default:
                    viewItem.setData("已见面",type: ZDQFlowViewItemType.ItemSelect)
                }
            }else if orderStatus == "12" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemCancelDone)
                case 2:
                    viewItem.setData("对方取消",type: ZDQFlowViewItemType.ItemCancel)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }else if orderStatus == "13" {
                switch index {
                case 0:
                    viewItem.setData("提交申请",type: ZDQFlowViewItemType.ItemCancelDone)
                case 1:
                    viewItem.setData("已确认",type: ZDQFlowViewItemType.ItemCancelDone)
                case 2:
                    viewItem.setData("已取消",type: ZDQFlowViewItemType.ItemCancel)
                default:
                    viewItem.setData("见面",type: ZDQFlowViewItemType.ItemNext)
                }
            }
            return viewItem
        }
    }
    
    func flowViewItemSize(flowView: ZDQFlowView) -> CGSize {
        return CGSizeMake(45, 57)
    }
}
