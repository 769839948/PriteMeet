//
//  OrderAllViewController.swift
//  Meet
//
//  Created by Zhang on 7/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderAllViewController: BaseOrderPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderState = ""
        self.setOrderData(orderState, guest: UserInfo.sharedInstance().uid)
        self.talKingDataPageName = "Order-Order-History"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloaCollectViewData() {
        self.setOrderData(orderState, guest: UserInfo.sharedInstance().uid)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let orderModel = orderList[(indexPath as NSIndexPath).row]
        
        if orderModel.status?.status_code == "2" || orderModel.status?.status_code == "3" || orderModel.status?.status_code == "7" || orderModel.status?.status_code == "8" || orderModel.status?.status_code == "13"  {
            let applyDetailView = OrderCancelViewController()
            applyDetailView.uid = self.guest
            applyDetailView.myClouse = { status in
                self.orderList.remove(at: (indexPath as NSIndexPath).row)
                self.collectionView.reloadData()
            }
            applyDetailView.orderModel = orderModel
            self.navigationController?.pushViewController(applyDetailView, animated: true)
        }else{
            let applyDetailView = AllMeetViewController()
            applyDetailView.uid = self.guest
            applyDetailView.myClouse = { status in
                self.orderList.remove(at: (indexPath as NSIndexPath).row)
                self.collectionView.reloadData()
            }
            applyDetailView.orderModel = orderModel
            self.navigationController?.pushViewController(applyDetailView, animated: true)
        }
        
    }

}
