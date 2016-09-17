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
import FDFullscreenPopGesture

typealias BlackListClouse = () -> Void



class SenderInviteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    internal var isNewLogin:Bool = false
    var viewModel:UserInfoViewModel!
    var allItems = NSMutableArray()
    var plachString = ""
    var selectItems = NSMutableArray()
    var textView:UITextView!
    var cell:InviteItemsTableViewCell!
    
    var isDetailViewLogin:Bool = false
    var detailViewActionSheetSelect:NSInteger = 0
    var user_id:String! = ""
    
    var blackListClouse:BlackListClouse!
    
    var isHomeListLogin:Bool = false
    
    var isApplyMeetLogin:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNetData()
        self.title = "设置邀约"
        self.setUpTableView()
        self.setNavigationItemBack()
        self.setNavigationBar()
        IQKeyboardManager.shared().isEnabled = false
        self.setupForDismissKeyboard()
        self.talKingDataPageName = "Me-Invite"
    }

    func loadNetData(){
        viewModel = UserInfoViewModel()
        viewModel.getAllInviteAllItems({ (dic) in
            self.allItems = NSMutableArray.init(array: dic?["all_themes"] as! NSArray)
            self.plachString = dic?["default_document"] as! String
            if UserInviteModel.isFake() {
                for _ in 0...self.allItems.count - 1 {
                    self.selectItems.add("false")

                }
            }else{
                self.selectItems = NSMutableArray(array:UserInviteModel.themArray(0) as NSArray)
            }
            self.tableView.reloadData()
            self.changeNavigationBarItemColor()
            }, fail: { (dic) in
                
            }) { (msg) in
                
        }
    }
    
    func checkNavigationItemEnable() -> Bool {
        if  cell != nil && cell.interestView != nil && cell.interestView.selectItems.count >= 1 {
            for idx in 0...cell.interestView.selectItems.count - 1 {
                let ret = cell.interestView.selectItems[idx]
                if ret as! String == "true" && textView.text.length != 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func setNavigationBar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(SenderInviteViewController.sendreInvite))
        self.changeNavigationBarItemColor()
    }
    
    func changeNavigationBarItemColor() {
        self.navigationItem.rightBarButtonItem?.tintColor = self.checkNavigationItemEnable() ? UIColor.init(hexString:NavigationBarTintColorCustome) : UIColor.init(hexString:NavigationBarTintDisColorCustom)
    }
    
    func sendreInvite(){
        let arrayItems = NSMutableArray()
        for idx in 0...cell.interestView.selectItems.count - 1 {
            let ret = cell.interestView.selectItems[idx]
            if ret as! String == "true" {
                arrayItems.add(allItems[idx])
            }
        }
        
        if arrayItems.count == 0 {
            UITools.showMessage(to: self.view, message: "邀约说明是必填内容哦", autoHide: true)
            return
        }
        if textView.text == "" {
            UITools.showMessage(to: self.view, message: "邀约说明是必填内容哦", autoHide: true)
            return
        }
        
        var ret:Bool = true
        if !isNewLogin {
            if !UserInviteModel.shareInstance().results[0].is_fake {
                ret = UserInviteModel.shareInstance().results[0].is_active
            }
        }
        viewModel.uploadInvite(textView.text, themeArray: arrayItems as [AnyObject], isActive: ret,success: { (dic) in
            if self.isDetailViewLogin {
                if self.detailViewActionSheetSelect == 1 {
                    let reportVC = ReportViewController()
                    reportVC.uid = self.user_id
                    reportVC.myClouse = { _ in
                        UITools.showMessage(to: self.view, message: "投诉成功", autoHide: true)
                    }
                    self.navigationController?.pushViewController(reportVC, animated: true)
                }else{
                    let viewControllers:NSArray = (self.navigationController?.viewControllers)! as NSArray
                    _ = self.navigationController?.popToViewController(viewControllers.object(at: 1) as! UIViewController, animated: true)
                }
            }else if self.isHomeListLogin{
                 _ = self.navigationController?.popToRootViewController(animated: true)
            }else if self.isNewLogin {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }else if self.isApplyMeetLogin {
                let viewControllers:NSArray = (self.navigationController?.viewControllers)! as NSArray
                _ = self.navigationController?.popToViewController(viewControllers.object(at: 2) as! UIViewController, animated: true)
            }else{
                if !UserInviteModel.shareInstance().results[0].is_active {
                    UserInviteModel.shareInstance().results[0].is_active = true
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
            }, fail: { (dic) in
                
        }) { (msg) in
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpTableView(){
        self.tableView.register(InviteItemsTableViewCell.self, forCellReuseIdentifier: "InviteItemsTableViewCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(_ cell:InviteItemsTableViewCell){
        if allItems.count > 0 {
            cell.setData(allItems.copy() as! NSArray, selectItems: selectItems.copy() as! NSArray)
        }
    }
    
    func setUpAlertContol(){
        let aletControl = UIAlertController.init(title: "确定关闭邀约？", message: "邀约关闭后，您将不会出现在首页了哦。", preferredStyle: UIAlertControllerStyle.alert)
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (canCel) in
            (UserInviteModel.shareInstance().results[0]).is_active = true
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: UITableViewRowAnimation.automatic)
        })
        let doneAction = UIAlertAction.init(title: "关闭", style: UIAlertActionStyle.default, handler: { (canCel) in
            (UserInviteModel.shareInstance().results[0]).is_active = false
            self.sendreInvite()
        })
        aletControl.addAction(cancleAction)
        aletControl.addAction(doneAction)
        self.present(aletControl, animated: true) { 
            
        }
    }
}

extension SenderInviteViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        if isNewLogin || UserInviteModel.shareInstance().results[0].is_fake {
            return 2
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                return 77
            }else{
                return tableView.fd_heightForCell(withIdentifier: "InviteItemsTableViewCell", configuration: { (cell) in
                    self.setData(cell as! InviteItemsTableViewCell)
                })
            }
        }else if ((indexPath as NSIndexPath).section == 1){
            if (indexPath as NSIndexPath).row == 0 {
                return 60
            }else{
                return ScreenHeight - (tableView.fd_heightForCell(withIdentifier: "InviteItemsTableViewCell", configuration: { (cell) in
                    self.setData(cell as! InviteItemsTableViewCell)
                })) - 77 - 77 - 66 - 10 - 64
            }
        }else{
            return 77
        }
    }
}

extension SenderInviteViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                let cellId = "InviteTitleTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! InviteTitleTableViewCell
                cell.setData("设置邀约主题", isSwitch: false, isShowSwitch: false)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }else{
                let cellId = "InviteItemsTableViewCell"
                cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! InviteItemsTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.clourse = { selectItem in
                    self.changeNavigationBarItemColor()
                    if !self.isNewLogin {
                        if !UserInviteModel.shareInstance().results[0].is_active && !UserInviteModel.shareInstance().results[0].is_fake {
                            UserInviteModel.shareInstance().results[0].is_active = true
                            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: UITableViewRowAnimation.automatic)
                        }
                    }
                }
                self.setData(cell)
                return cell
            }
        }else if ((indexPath as NSIndexPath).section == 1) {
            if (indexPath as NSIndexPath).row == 0 {
                let cellId = "InviteDetailTitleTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! InviteDetailTitleTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none

                return cell
            }else{
                let cellId = "TableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
                textView = UITextView()
                
                textView.placeholder = self.plachString
                if isNewLogin || UserInviteModel.isFake() {
                    
                }else{
                    let result = UserInviteModel.shareInstance().results[0]
                    if result.introduction != "" {
                        textView.text = result.introduction
                    }
                }
                
                textView.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
                textView.delegate = self
                textView.placeholderColor = UIColor.init(hexString: PlaceholderTextViewColor)
                IQKeyboardManager.shared().isEnabled = true
                textView.font = LoginCodeLabelFont
                cell?.contentView.addSubview(textView)
                textView.snp.makeConstraints({ (make) in
                    make.top.equalTo((cell?.contentView.snp.top)!).offset(0)
                    make.left.equalTo((cell?.contentView.snp.left)!).offset(15)
                    make.right.equalTo((cell?.contentView.snp.right)!).offset(-15)
                    make.bottom.equalTo((cell?.contentView.snp.bottom)!).offset(-20)
                })
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                return cell!
            }
        }else{
            let cellId = "InviteTitleTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! InviteTitleTableViewCell
            cell.setData("邀约已开启", isSwitch: (UserInviteModel.shareInstance().results[0]).is_active,isShowSwitch:true )
            cell.myCourse = { _ in
                self.setUpAlertContol()
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
}
extension SenderInviteViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !isNewLogin {
            if !UserInviteModel.shareInstance().results[0].is_active && !UserInviteModel.shareInstance().results[0].is_fake {
                UserInviteModel.shareInstance().results[0].is_active = true
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: UITableViewRowAnimation.automatic)
            }
        }
        self.changeNavigationBarItemColor()
    }
}
