//
//  BaseOrderPageViewController.swift
//  Meet
//
//  Created by Zhang on 7/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


typealias AllMeetOrder = (allNumber:String, statues:String) -> Void

class BaseOrderPageViewController: UIViewController {

    let viewModel = OrderViewModel()
    var orderList:[OrderModel] = []
    var sortOrderList:NSMutableArray = NSMutableArray()
    var orderState:String = "1"
    var collectionView:UICollectionView!
    var guest:String = ""
    var allMeetOrder:AllMeetOrder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        self.view.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        self.setUpLineView()
        self.fd_prefersNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    func setUpLineView() {
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        self.view.addSubview(lineLabel)
        lineLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.collectionView.snp_top).offset(0.5)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.height.equalTo(0.5)
        }
    }
    
    func setOrderData(state:String, guest:String){
        self.sortOrderList.removeAllObjects()
        self.orderList.removeAll()
        self.guest = guest
        viewModel.getOrderList(state, withGuest: guest, successBlock: { (dic) in
            if ((dic["receive_order_list"] as! NSArray).count != 0){
                let receive_Order_List = OrderModel.mj_objectArrayWithKeyValuesArray(dic["receive_order_list"])
                self.sortOrderList.addObjectsFromArray(receive_Order_List as [AnyObject])
                
            }
            if ((dic["apply_order_list"] as! NSArray).count != 0){
                let apply_Order_List = OrderModel.mj_objectArrayWithKeyValuesArray(dic["apply_order_list"])
                self.sortOrderList.addObjectsFromArray(apply_Order_List as [AnyObject])
            }
            NSUserDefaults.standardUserDefaults().setObject(dic["customer_service_number"], forKey: "customer_service_number")
            for model in self.sortOrderList {
                let orderModel = OrderModel.mj_objectWithKeyValues(model)
                self.orderList.append(orderModel)
            }
            self.orderList.sortInPlace({ $0.order_id > $1.order_id })
            if self.allMeetOrder != nil {
                self.allMeetOrder(allNumber: "\(self.orderList.count)", statues: state)
            }
            if self.collectionView != nil {
                self.collectionView.reloadData()
            }
        }) { (dic) in
            MainThreadAlertShow(dic["error"] as! String, view: self.view)
        }
    }
    
    func reloadCollectView() {
        
    }
    
    func setUpCollectionView(){
        let followLayout = UICollectionViewFlowLayout()
        followLayout.scrollDirection = .Vertical
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: followLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        collectionView.backgroundColor = UIColor.init(colorLiteralRed: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        collectionView.registerNib(UINib.init(nibName: "OrderCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "OrderCollectionViewCell")
        self.view.addSubview(collectionView)
        
        collectionView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.top.equalTo(self.view.snp_top).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reportBtnPress(sender:UIButton){
//        self.collectionView(self.collectionView, didSelectItemAtIndexPath: <#T##NSIndexPath#>)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BaseOrderPageViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

extension BaseOrderPageViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdef = "OrderCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdef, forIndexPath: indexPath) as! OrderCollectionViewCell
        cell.reportBtn.userInteractionEnabled = false
        cell.layer.cornerRadius = 5.0
        cell.setOrderModel(orderList[indexPath.row])
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
}

extension BaseOrderPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.size.width - 27)/2, 223)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7
    }
    
    //返回HeadView的宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: 0, height: 0)
    }
    //返回cell 上下左右的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}

extension BaseOrderPageViewController : DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func  emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    
}

extension BaseOrderPageViewController : DZNEmptyDataSetSource {
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        var string = ""
        if orderState == "1" {
            string = "暂时没有待确认的约见\n快去发现并约见志趣相投的人吧"
        }else if orderState == "4"{
            string = "暂时没有待支付的约见\n快去发现并约见志趣相投的人吧"
        }else if orderState == "6" {
            string = "暂时没有需要见面的人\n快去发现并约见志趣相投的人吧"
        }else{
            string = "还没有约见记录\n快去发现并约见志趣相投的人吧"
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .ByWordWrapping
        paragraph.alignment = .Center
        paragraph.lineSpacing = 5.0
        let attributes = [NSFontAttributeName:UIFont.systemFontOfSize(14.0),NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:UIColor.init(hexString: EmptyDataTitleColor)]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "order_empty")
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -20
    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return 28
    }
}
