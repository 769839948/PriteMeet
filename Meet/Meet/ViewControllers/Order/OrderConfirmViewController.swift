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
        self.talKingDataPageName = "Order-Order-Confirm"

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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let applyDetailView = ConfirmedViewController()
        applyDetailView.uid = self.guest
        let orderModel = (orderList[(indexPath as NSIndexPath).row])
        applyDetailView.myClouse = { status in
//            self.orderList.removeAtIndex(indexPath.row)
//            NSNotificationCenter.defaultCenter().postNotificationName(ReloadOrderCollectionView, object: self.orderState)
//            self.collectionView.reloadData()
        }
        applyDetailView.orderModel = orderModel
        self.navigationController?.pushViewController(applyDetailView, animated: true)
    }
    
    

}
