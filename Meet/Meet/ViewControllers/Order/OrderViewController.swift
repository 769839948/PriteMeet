//
//  OrderViewController.swift
//  Meet
//
//  Created by Zhang on 7/14/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

//1  （2，3）待确认
//4  （5，）待付款
//6 （）待见面
class OrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segementContol: UISegmentedControl!
    let viewModel = OrderViewModel()
    var orderList = NSMutableArray()
    var orderState:String = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpSegmentedControl()
        self.setOrderData(orderState, guest: UserInfo.sharedInstance().uid)
        // Do any additional setup after loading the view.
    }

    func setOrderData(state:String, guest:String){
        self.orderList.removeAllObjects()
        viewModel.getOrderList(state, withGuest: guest, successBlock: { (dic) in
            if ((dic["receive_order_list"] as! NSArray).count != 0){
                let receive_Order_List = OrderModel.mj_objectArrayWithKeyValuesArray(dic["receive_order_list"])
                self.orderList.addObjectsFromArray(receive_Order_List as [AnyObject])
                
            }
            if ((dic["apply_order_list"] as! NSArray).count != 0){
                let apply_Order_List = OrderModel.mj_objectArrayWithKeyValuesArray(dic["apply_order_list"])
                self.orderList.addObjectsFromArray(apply_Order_List as [AnyObject])
            }
            self.tableView.reloadData()
            }) { (dic) in
                
        }
    }
    
    func setUpSegmentedControl(){
        self.segementContol.addTarget(self, action: #selector(OrderViewController.segementChangeValue(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func setUpTableView() {
        self.tableView.registerNib(UINib.init(nibName: "OrderUserTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderUserTableViewCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segementChangeValue(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex  {
        case 0:
            orderState = "1"
        case 1:
            orderState = "4"
        case 2:
            orderState = "6"
        default:
            orderState = ""
        }
        self.setOrderData(orderState, guest: UserInfo.sharedInstance().uid)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "PushAppiontMentDetail" {
//            let applyDetailView = segue.destinationViewController as! AppointmentDetailViewController
//            let section = (sender as! NSIndexPath).section
//            applyDetailView.orderModel = (orderList[section] as! OrderModel)
//        }
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}

extension OrderViewController: UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orderList.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(orderList[indexPath.section] as! OrderModel)
        let orderModel = orderList[indexPath.section] as! OrderModel
        let status:String = (orderModel.status?.status_code)!
        switch status{
        case "1","2","3":
            let applyDetailView = ConfirmedViewController()
            applyDetailView.orderModel = (orderList[indexPath.section] as! OrderModel)
            self.navigationController?.pushViewController(applyDetailView, animated: true)
        case "4","5","6":
            let applyDetailView = WaitPayViewController()
            applyDetailView.orderModel = (orderList[indexPath.section] as! OrderModel)
            self.navigationController?.pushViewController(applyDetailView, animated: true)
        default:
            let applyDetailView = WaitMeetViewController()
            applyDetailView.orderModel = (orderList[indexPath.section] as! OrderModel)
            self.navigationController?.pushViewController(applyDetailView, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        }else{
            return 50
        }
    }
}

extension OrderViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellIndef = "OrderUserTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIndef, forIndexPath: indexPath) as! OrderUserTableViewCell
            cell.setData(orderList[indexPath.section] as! OrderModel)
            return cell
        }else{
            let cellIndef = "DefaultTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIndef, forIndexPath: indexPath)
            let label = UILabel.init(frame: cell.bounds)
            label.textAlignment = NSTextAlignment.Center
            if orderList.count > 0 {
                let model = (orderList[indexPath.section] as! OrderModel)
                cell.textLabel?.text = model.status!.order_status

            }
            cell.contentView.addSubview(label)
            return cell
        }
        
    }
}
