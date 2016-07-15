//
//  OrderViewController.swift
//  Meet
//
//  Created by Zhang on 7/14/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segementContol: UISegmentedControl!
    var viewModel:OrderViewModel!
    var orderList = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setOrderData()
        // Do any additional setup after loading the view.
    }

    func setOrderData(){
        viewModel = OrderViewModel()
        viewModel.getOrderList({ (dic) in
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
    
    func setUpTableView() {
        self.tableView.registerNib(UINib.init(nibName: "OrderUserTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderUserTableViewCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension OrderViewController: UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orderList.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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
                label.text = model.status!.front_status

            }
            cell.contentView.addSubview(label)
            return cell
        }
        
    }
}
