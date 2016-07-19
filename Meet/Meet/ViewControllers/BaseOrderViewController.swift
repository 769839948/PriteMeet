//
//  BaseOrderViewController.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class BaseOrderViewController: UIViewController {

    var tableView:UITableView!
    var orderModel:OrderModel!
    let tableViewArray = ["OrderFlowTableViewCell","OrderProfileTableViewCell","AppointMentTableViewCell","MeetOrderInfoTableViewCell"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView() {
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib.init(nibName: "OrderFlowTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFlowTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "OrderProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderProfileTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "AppointMentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointMentTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "MeetOrderInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "MeetOrderInfoTableViewCell")
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cellIndexPath(cellIdf:String, indexPath:NSIndexPath, tableView:UITableView) -> UITableViewCell  {
//        let cellClass = NSClassFromString(cellIdf)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdf, forIndexPath: indexPath)
        switch indexPath.section {
        case 1:
            let returnCell = cell as! OrderFlowTableViewCell
            return returnCell
        case 2:
            return cell as! OrderProfileTableViewCell
        case 3:
            return cell as! AppointMentTableViewCell
        default:
            return cell as! MeetOrderInfoTableViewCell
            
        }
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

extension BaseOrderViewController : UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 100;
        }
        if indexPath.section == 2 {
            return 150;
        }
        if indexPath.section == 3 {
            return 100;
        }
        return 50
    }
}

extension BaseOrderViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellIndexPath(tableViewArray[indexPath.section], indexPath: indexPath, tableView: tableView)
//        if indexPath.section == 1 {
//            let cellIdf = "OrderProfileTableViewCell"
//            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdf, forIndexPath: indexPath) as! OrderProfileTableViewCell
//            return cell
//            
//        }else if indexPath.section == 2{
//            let cellIdf = "AppointMentTableViewCell"
//            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdf, forIndexPath: indexPath) as! AppointMentTableViewCell
//            return cell
//        }else if indexPath.section == 3 {
//            let cellIdf = "MeetOrderInfoTableViewCell"
//            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdf, forIndexPath: indexPath) as! MeetOrderInfoTableViewCell
//            return cell
//        }else{
//            let cellIdf = "DefaultCell"
//            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdf)
//            if cell == nil {
//                cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdf)
//            }
//            return cell!
//        }
    }
}
