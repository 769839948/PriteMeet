//
//  ReportViewController.swift
//  Meet
//
//  Created by Zhang on 7/22/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit


typealias PopNavigationController = () -> Void

class ReportViewController: UIViewController {

    var tableView:UITableView!
    var reportArray:NSMutableArray!
    var selectIndexPaths:NSMutableArray!
    let viewModel = UserInfoViewModel()
    var otherModel:OrderModel!
    var uid = ""
    var myClouse:PopNavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "投诉原因"
        reportArray = NSMutableArray(array: ["色情低俗","广告骚扰","政治敏感","欺诈骗钱","违法（暴力恐怖、违禁品等）","侵权（抄袭、盗用等）"], copyItems: true)
        selectIndexPaths = NSMutableArray(array: [false,false,false,false,false,false], copyItems: true)
        self.setNavigationItemBack()
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "提交", style: .Plain, target: self, action: #selector(ReportViewController.reportBtnPress(_:)))
        self.navigationController?.navigationBar.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
        self.setUpTableView()
        // Do any additional setup after loading the view.
    }

    func setUpTableView(){
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.hideExcessLine(tableView)
        self.tableView.separatorStyle = .None
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }
    
    func reportBtnPress(sender:UIBarButtonItem) {
        var reportString = ""
        for index in 0...reportArray.count - 1 {
            if self.selectIndexPaths[index] as! Bool  {
                reportString = reportString.stringByAppendingString((ProfileKeyAndValue.shareInstance().appDic as NSDictionary).objectForKey("report")?.objectForKey(reportArray[index] as! String) as! String)
                reportString = reportString.stringByAppendingString(",")
            }
        }
        viewModel.makeReport(uid, report: reportString, succes: { (dic) in
            if self.myClouse != nil{
                self.myClouse()
            }
            self.navigationController?.popViewControllerAnimated(true)
            }) { (dic) in
            UITools.showMessageToView(self.view, message: "投诉失败", autoHide: true)
        }
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

extension ReportViewController : UITableViewDelegate {
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  selectIndexPaths[indexPath.row] as! Bool{
            selectIndexPaths[indexPath.row] = false
        }else{
            selectIndexPaths[indexPath.row] = true
        }
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: .Automatic)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}

extension ReportViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdf = "ReportTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdf)
        if  cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellIdf)
        }
        let checkImage = UIImageView()
        checkImage.image = UIImage.init(named: "report_select")
        checkImage.frame = CGRectMake(ScreenWidth - 45, 15, 19, 19)
        cell?.contentView.addSubview(checkImage)
        if selectIndexPaths[indexPath.row] as! Bool {
            checkImage.hidden = false
            cell?.textLabel?.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        }else{
            checkImage.hidden = true
            cell?.textLabel?.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        }
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        cell?.contentView.addSubview(lineLabel)
        lineLabel.snp_makeConstraints { (make) in
            make.left.equalTo((cell?.contentView.snp_left)!).offset(20)
            make.right.equalTo((cell?.contentView.snp_right)!).offset(-20)
            make.bottom.equalTo((cell?.contentView.snp_bottom)!).offset(0)
            make.height.equalTo(0.5)
        }
        cell?.textLabel?.text = reportArray[indexPath.row] as? String
        cell?.textLabel?.font = UIFont.init(name: "PingFangSC-Light", size: 14.0)
        cell?.selectionStyle = .None
        return cell!
    }
}
