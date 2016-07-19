//
//  ConfirmedViewController.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class ConfirmedViewController: BaseOrderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        cellIndexPath("OrderProfileTableViewCell", indexPath: indexPath, tableView: tableView)
        if indexPath.section == 4 {
            let cellIdf = "DefaultCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdf)
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdf)
            }
            return cell!
        }else{
            return cellIndexPath(tableViewArray[indexPath.section], indexPath: indexPath, tableView: tableView)
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


