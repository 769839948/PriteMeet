//
//  ApplyMeetViewController.swift
//  Meet
//
//  Created by Zhang on 7/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class ApplyMeetViewController: UIViewController {

    var tableView:UITableView!
    var viewModel:OrderViewModel!
    var flowPath:UIView!
    var host:String = ""
    var allItems = NSMutableArray()
    var plachString = ""
    var selectItems = NSMutableArray()
    var textView:UITextView!
    var cell:InviteItemsTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邀约申请"
        self.setNavigationItemBack()
        self.setUpTableView()
        // Do any additional setup after loading the view.
    }

    func setUpTableView(){
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.registerClass(InviteItemsTableViewCell.self, forCellReuseIdentifier: "InviteItemsTableViewCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
        self.tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendreInvite(){
        viewModel = OrderViewModel()
        var appointment_theme = ""
        
        for idx in 0...cell.interestView.selectItems.count - 1 {
            let ret = cell.interestView.selectItems[idx]
            if ret as! String == "true" {
                appointment_theme = appointment_theme.stringByAppendingString(((ProfileKeyAndValue.shareInstance().appDic as NSDictionary).objectForKey("invitation")?.objectForKey("\(allItems[idx])"))! as! String)
                appointment_theme = appointment_theme.stringByAppendingString(",")

            }
        }
        let applyModel = ApplyMeetModel()
        applyModel.appointment_desc = textView.text;
        applyModel.appointment_theme = appointment_theme
        applyModel.host = self.host
        applyModel.guest = UserInfo.sharedInstance().uid
        viewModel.applyMeetOrder(applyModel, successBlock: { (dic) in
            
            let orderStoryBoard = UIStoryboard(name: "Order", bundle: NSBundle.mainBundle())
            let applyComfim = orderStoryBoard.instantiateViewControllerWithIdentifier("ApplyConfimViewController") as!  ApplyConfimViewController
            self.navigationController?.pushViewController(applyComfim, animated: true)
            }) { (dic) in
                
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
    func setData(cell:InviteItemsTableViewCell){
        if allItems.count > 0 {
            cell.setData(allItems.copy() as! NSArray, selectItems: selectItems.copy() as! NSArray)
        }
    }

}

extension ApplyMeetViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 3 {
            return 1
        }
        return 2;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return tableView.fd_heightForCellWithIdentifier("InviteItemsTableViewCell", configuration: { (cell) in
                self.setData(cell as! InviteItemsTableViewCell)
            })
        }
        if indexPath.section == 2 && indexPath.row == 1 {
            return 100
        }
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 {
            self.sendreInvite()
        }
    }
}

extension ApplyMeetViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cellId = "CellIndef"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                cell?.textLabel?.text = "邀约主题"
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
            }else{
                let cellId = "InviteItemsTableViewCell"
                cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! InviteItemsTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                self.setData(cell)
                return cell
            }
        }else if (indexPath.section == 2) {
            if indexPath.row == 0 {
                let cellId = "CellIndef"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                cell?.textLabel?.text = "邀约说明"
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
            }else{
                let cellId = "TableViewCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                textView = UITextView()
                textView.placeholder = self.plachString
                textView.tintColor = UIColor.blackColor()
                textView.font = ApplyControllerTextFont
                cell?.contentView.addSubview(textView)
                textView.snp_makeConstraints(closure: { (make) in
                    make.top.equalTo((cell?.contentView.snp_top)!).offset(0)
                    make.left.equalTo((cell?.contentView.snp_left)!).offset(15)
                    make.right.equalTo((cell?.contentView.snp_right)!).offset(-15)
                    make.bottom.equalTo((cell?.contentView.snp_bottom)!).offset(-20)
                })
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
            }
        }else if (indexPath.section == 3){
            let cellId = "CellIndef"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            }
            cell?.textLabel?.text = "提交申请"
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }else{
            let cellId = "CellIndef"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            }
            cell?.textLabel?.text = "邀约流程"
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
    }
}
