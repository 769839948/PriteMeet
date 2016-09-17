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
        
        self.setUpTableView()
        self.setUpNavigationItem()
        
        self.talKingDataPageName = "Home-Detail-Report"
        // Do any additional setup after loading the view.
    }

    func setUpTableView(){
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.hideExcessLine(tableView)
        self.tableView.separatorStyle = .none
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }
    
    func setUpNavigationItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navigationbar_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(ReportViewController.leftItemPress))
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(ReportViewController.reportBtnPress(_:)))
        self.navigationController?.navigationBar.tintColor = UIColor.init(hexString: HomeDetailViewNameColor)
    }
    
    func leftItemPress(){
        let viewControllers:NSArray = (self.navigationController?.viewControllers)! as NSArray
        _ = self.navigationController?.popToViewController(viewControllers.object(at: 1) as! UIViewController, animated: true)
    }
    
    func reportBtnPress(_ sender:UIBarButtonItem) {

        var reportString = ""
        for index in 0...reportArray.count - 1 {
            if self.selectIndexPaths[index] as! Bool  {
                reportString = reportString + (((ProfileKeyAndValue.shareInstance().appDic as NSDictionary).object(forKey: "report") as AnyObject).object(forKey: reportArray[index] as! String) as! String)
                reportString = reportString + ","
            }
        }
        viewModel.makeReport(uid, report: reportString, succes: { (dic) in
            if self.myClouse != nil{
                self.myClouse()
            }
            self.leftItemPress()
            }) { (dic) in
            UITools.showMessage(to: self.view, message: "投诉失败", autoHide: true)
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
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  selectIndexPaths[(indexPath as NSIndexPath).row] as! Bool{
            selectIndexPaths[(indexPath as NSIndexPath).row] = false
        }else{
            for index in 0...selectIndexPaths.count - 1 {
                if index == (indexPath as NSIndexPath).row {
                    selectIndexPaths[index] = true
                }else{
                    selectIndexPaths[index] = false
                }
            }
            
        }
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ReportViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdf = "ReportTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdf)
        if  cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdf)
        }else{
            while cell?.contentView.subviews.last != nil {
                cell?.contentView.subviews.last?.removeFromSuperview()
            }
        }
        let checkImage = UIImageView()
        checkImage.image = UIImage.init(named: "report_select")
        checkImage.frame = CGRect(x: ScreenWidth - 45, y: 15, width: 19, height: 19)
        cell?.contentView.addSubview(checkImage)
        if selectIndexPaths[(indexPath as NSIndexPath).row] as! Bool {
            checkImage.isHidden = false
            cell?.textLabel?.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        }else{
            checkImage.isHidden = true
            cell?.textLabel?.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        }
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        cell?.contentView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo((cell?.contentView.snp.left)!).offset(20)
            make.right.equalTo((cell?.contentView.snp.right)!).offset(-20)
            make.bottom.equalTo((cell?.contentView.snp.bottom)!).offset(0)
            make.height.equalTo(0.5)
        }
        cell?.textLabel?.text = reportArray[(indexPath as NSIndexPath).row] as? String
        cell?.textLabel?.font = LoginCodeLabelFont
        cell?.selectionStyle = .none
        return cell!
    }
}
