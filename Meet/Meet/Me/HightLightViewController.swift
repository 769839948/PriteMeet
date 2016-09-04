//
//  HightLightViewController.swift
//  Meet
//
//  Created by Zhang on 9/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class HightLightViewController: UIViewController {

    var titleText:UITextView!
    var infoText:UITextView!
    
    var titleStr:String = ""
    var infoStr:String = ""
    var tableView:UITableView!
    

    let viewModel = UserInfoViewModel()
    
    var titleHeight:CGFloat = 192.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItemBack()
        self.title = "编辑个人简介"
        self.setUpNavigationItem()
        self.setupForDismissKeyboard()
        self.setUpTableView()
        self.talKingDataPageName = "Me-HightLight"
        // Do any additional setup after loading the view.
    }
    
    func setUpNavigationItem() {
        let str = (titleStr != "" && infoStr == "") ? "提交":"保存"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: str, style: .Plain, target: self, action: #selector(HightLightViewController.sublimTitle(_:)))
        self.changeNavigationBarItemColor()
    }

    func changeNavigationTitleColor() -> Bool {
        
        titleHeight = ((PlaceholderText.shareInstance().appDic as NSDictionary).objectForKey("1000007") as! String).heightWithConstrainedWidth(ScreenWidth - 40, font: HightLightTitleFont!) + 75
        if titleStr == "" || infoStr == "" || titleStr.length == 0 || infoStr.length == 0  {
            return false
        }else{
            return true
        }
    }
    
    func changeNavigationBarItemColor() {
        self.navigationItem.rightBarButtonItem?.tintColor = self.changeNavigationTitleColor() ? UIColor.init(hexString:NavigationBarTintColorCustome) : UIColor.init(hexString:NavigationBarTintDisColorCustom)
    }
    
    func sublimTitle(sender:UIBarButtonItem) {
        if titleStr == "" {
            MainThreadAlertShow("您未填写破冰话题哦", view: self.view)
        }else if infoStr == "" {
            MainThreadAlertShow("您未填写详细个人介绍哦", view: self.view)
        }else{
            viewModel.addStar(infoStr, experience: titleStr, success: { (dic) in
                UserExtenModel.shareInstance().highlight = self.infoStr
                UserExtenModel.shareInstance().experience = self.titleStr
                self.navigationController?.popViewControllerAnimated(true)
                }, fail: { (dic) in
                    MainThreadAlertShow("添加失败", view: self.view)
                }, loadingString: { (msg) in
                    
            })
        }
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.keyboardDismissMode = .OnDrag
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HightLightViewController: UITableViewDelegate {
    
}

extension HightLightViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return titleHeight
        default:
            return 220
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cellIndef = "titleCellIndf"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIndef)
            if cell == nil {
                cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellIndef)
            }
            
            titleText = UITextView()
            
            titleText.placeholder = (PlaceholderText.shareInstance().appDic as NSDictionary).objectForKey("1000007") as! String
            if titleStr != "" {
                titleText.text = titleStr
            }
            titleText.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            titleText.delegate = self
            titleText.tag = 1
            titleText.returnKeyType = .Done
            titleText.placeholderColor = UIColor.init(hexString: MeViewProfileContentLabelColorLight)
            titleText.font = HightLightTitleFont
            cell?.contentView.addSubview(titleText)
            titleText.snp_makeConstraints(closure: { (make) in
                make.top.equalTo((cell?.contentView.snp_top)!).offset(30)
                make.left.equalTo((cell?.contentView.snp_left)!).offset(15)
                make.right.equalTo((cell?.contentView.snp_right)!).offset(-15)
                make.bottom.equalTo((cell?.contentView.snp_bottom)!).offset(-30)
            })

            cell?.selectionStyle = .None
            let line = UILabel()
            line.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
            cell?.contentView.addSubview(line)
            line.snp_makeConstraints(closure: { (make) in
                make.height.equalTo(0.5)
                make.left.equalTo((cell?.contentView.snp_left)!).offset(15)
                make.right.equalTo((cell?.contentView.snp_right)!).offset(-15)
                make.bottom.equalTo((cell?.contentView.snp_bottom)!).offset(0)

            })
            return cell!
        default:
            let cellIndef = "infoCellIndf"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIndef)
            if cell == nil {
                cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellIndef)
            }
            
            infoText = UITextView()
            infoText.placeholder = (PlaceholderText.shareInstance().appDic as NSDictionary).objectForKey("1000008") as! String
            if infoText != "" {
                infoText.text = infoStr
            }
            
            infoText.font = HightLightInfoFont
            infoText.delegate = self
            infoText.tag = 2
            infoText.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
            infoText.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
            infoText.placeholderColor = UIColor.init(hexString: MeViewProfileContentLabelColorLight)
            cell?.contentView.addSubview(infoText)
            infoText.snp_makeConstraints(closure: { (make) in
                make.top.equalTo((cell?.contentView.snp_top)!).offset(30.5)
                make.left.equalTo((cell?.contentView.snp_left)!).offset(15)
                make.right.equalTo((cell?.contentView.snp_right)!).offset(-15)
                make.bottom.equalTo((cell?.contentView.snp_bottom)!).offset(-20)
            })
            cell?.selectionStyle = .None

            return cell!
        }
    }
}

extension HightLightViewController : UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if titleStr == "" && textView.tag == 1 {
            textView.text = "我是\(UserInfo.sharedInstance().real_name)"
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && textView.tag == 1 {
            textView.resignFirstResponder()
            return false
        }
        
        if textView.tag == 1 {
            titleStr = textView.text
            if text == "" && titleStr.length == 1 {
                titleStr = ""
            }else if titleStr.length == 0{
                titleStr = ""
            }
        }else{
            infoStr = textView.text
            if text == "" && infoStr.length == 1 {
                infoStr = ""
            }else if titleStr.length == 0{
                infoStr = ""
            }
        }
        self.changeNavigationBarItemColor()
        return true
    }
}
