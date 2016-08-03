//
//  WaitMeetViewController.swift
//  Meet
//
//  Created by Zhang on 7/20/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class WaitMeetViewController: BaseOrderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomBtn.setTitle("确认双方已约见", forState: .Normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:父类方法重写
    override func bottomPress(sender: UIButton) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderCancelTableViewCell", forIndexPath: indexPath) as! OrderCancelTableViewCell
            cell.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
            cell.selectionStyle = .None
            return cell
        }else{
            return cellIndexPath(self.tableViewArray[indexPath.row], indexPath: indexPath, tableView: tableView)
        }
    }

}
