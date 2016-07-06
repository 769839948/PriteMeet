//
//  SenderInviteViewController.swift
//  Meet
//
//  Created by Zhang on 7/5/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import MJExtension
import IQKeyboardManager

class SenderInviteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    internal var isNewLogin:Bool = false
    var viewModel:UserInfoViewModel!
    var allItems = NSMutableArray()
    var selectItems = NSMutableArray()
    var textView:UITextView!
    var cell:InviteItemsTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNetData()
        self.title = "管理邀约"
        self.setUpTableView()
        self.setNavigationItemBack()
        self.setNavigationBar()
        IQKeyboardManager.sharedManager().enable = false
        self.setupForDismissKeyboard()
        
        // Do any additional setup after loading the view.
    }

    func loadNetData(){
        viewModel = UserInfoViewModel()
        viewModel.getAllInviteAllItems({ (dic) in
            self.allItems = ((dic as NSDictionary).objectForKey("all_themes")?.copy())! as! NSMutableArray
            self.selectItems = NSMutableArray(array:UserInviteModel.themArray(0) as NSArray)
            self.tableView.reloadData()
            }, fail: { (dic) in
                
            }) { (msg) in
                
        }
    }
    
    func setNavigationBar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "setting_savebt"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SenderInviteViewController.sendreInvite))
    }
    
    func sendreInvite(){
        let arrayItems = NSMutableArray()
        for idx in 0...cell.interestView.selectItems.count - 1 {
            let ret = cell.interestView.selectItems[idx].boolValue
            if ret == true {
                arrayItems.addObject(allItems[idx])
            }
        }
        viewModel.uploadInvite(textView.text, themeArray: arrayItems as [AnyObject], isActive: UserInviteModel.shareInstance().results[0].is_active,success: { (dic) in
            if self.isNewLogin {
                self.dismissViewControllerAnimated(true, completion: { 
                    
                })
            }
            }, fail: { (dic) in
                
            }) { (msg) in
                
        }
    }
    
    func setUpTableView(){
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
    
    func setData(cell:InviteItemsTableViewCell){
        if allItems.count > 0 {
            cell.setData(allItems.copy() as! NSArray, selectItems: selectItems.copy() as! NSArray)
        }
    }
}

extension SenderInviteViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 77
            }else{
                return tableView.fd_heightForCellWithIdentifier("InviteItemsTableViewCell", configuration: { (cell) in
                    self.setData(cell as! InviteItemsTableViewCell)
                })
            }
        }else if (indexPath.section == 1){
            if indexPath.row == 0 {
                return 60
            }else{
                return ScreenHeight - (tableView.fd_heightForCellWithIdentifier("InviteItemsTableViewCell", configuration: { (cell) in
                    self.setData(cell as! InviteItemsTableViewCell)
                })) - 77 - 77 - 66 - 10 - 64
            }
        }else{
            return 77
        }
    }
    
}

extension SenderInviteViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cellId = "InviteTitleTableViewCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! InviteTitleTableViewCell
                cell.setData("设置邀约主题", isSwitch: false, isShowSwitch: false)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else{
                let cellId = "InviteItemsTableViewCell"
                cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! InviteItemsTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                self.setData(cell)
                return cell
            }
        }else if (indexPath.section == 1) {
            if indexPath.row == 0 {
                let cellId = "InviteDetailTitleTableViewCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! InviteDetailTitleTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else{
                let cellId = "TableViewCell"
                let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                textView = UITextView()
                textView.placeholder = "真诚且走心的邀约说明，有利于打动对方主动约见哦，同时您也可以说说希望认识些什么类型的朋友"
                let result = UserInviteModel.shareInstance().results[0]
                if result.introduction != "" {
                    textView.text = result.introduction
                }
                textView.tintColor = UIColor.blackColor()
                textView.font = UIFont.init(name: "PingFangSC-Light", size: 14.0)
                cell?.contentView.addSubview(textView)
                textView.snp_makeConstraints(closure: { (make) in
                    make.top.equalTo((cell?.contentView.snp_top)!).offset(14)
                    make.left.equalTo((cell?.contentView.snp_left)!).offset(20)
                    make.right.equalTo((cell?.contentView.snp_right)!).offset(-20)
                    make.bottom.equalTo((cell?.contentView.snp_bottom)!).offset(-20)
                })
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
            }
        }else{
            let cellId = "InviteTitleTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! InviteTitleTableViewCell
            cell.setData("邀约已开启", isSwitch: (UserInviteModel.shareInstance().results[0] ).is_active,isShowSwitch:true )
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
}

