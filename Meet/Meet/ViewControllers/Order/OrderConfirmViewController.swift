//
//  OrderConfirmViewController.swift
//  Meet
//
//  Created by Zhang on 7/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderConfirmViewController: BaseOrderPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderState = "1"
        self.setOrderData(orderState, guest: UserInfo.sharedInstance().uid)
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloaCollectViewData() {
        self.setOrderData(orderState, guest: UserInfo.sharedInstance().uid)
    }
    
    //MARK:重写父类方法
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let applyDetailView = ConfirmedViewController()
        let orderModel = (orderList[indexPath.row] as! OrderModel)
        applyDetailView.myClouse = { status in
            self.orderList.removeObjectAtIndex(indexPath.row)
            NSNotificationCenter.defaultCenter().postNotificationName(ReloadOrderCollectionView, object: self.orderState)
            self.collectionView.reloadData()
        }
        orderModel.appointment_theme = ["吃饭聚餐","看电影","逛街","更多","资深设计","视觉设计"]
        applyDetailView.orderModel = orderModel
        self.navigationController?.pushViewController(applyDetailView, animated: true)
    }
    
    

}