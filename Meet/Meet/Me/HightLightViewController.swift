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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提交", style: .Plain, target: self, action: #selector(HightLightViewController.sublimTitle(_:)))
        self.changeNavigationBarItemColor()
    }

    func changeNavigationTitleColor() -> Bool {
        if titleStr == "" || infoStr == "" || titleStr.length == 0 || infoStr.length == 0  {
            return false
        }else{
            titleHeight = titleStr.heightWithConstrainedWidth(ScreenWidth - 40, font: HightLightTitleFont!) + 75
            return true
        }
    }
    
    func changeNavigationBarItemColor() {
        self.navigationItem.rightBarButtonItem?.tintColor = self.changeNavigationTitleColor() ? UIColor.init(hexString:NavigationBarTintColorCustome) : UIColor.init(hexString:NavigationBarTintDisColorCustom)
    }
    
    func sublimTitle(sender:UIBarButtonItem) {
        if titleStr == "" || infoStr == "" {
            MainThreadAlertShow("请输入资料", view: self.view)
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
            
            titleText.placeholder = "先写一个破冰的标题吧，可以是特殊的经历、话题、故事，例：金融圈最会讲鬼故事的萌妹子"
            if titleStr != "" {
                titleText.text = titleStr
            }
            titleText.tintColor = UIColor.blackColor()
            titleText.delegate = self
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
            infoText.placeholder = "详细的说说关于你的一切，可以从工作经历、生活、兴趣爱好等方面简单扼要的介绍你自己，3-4条概括性描述即可"
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
        if titleHeight != 192 {
            titleHeight = 192
            self.tableView.reloadData()
        }
        textView.becomeFirstResponder()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if textView.tag == 1 {
            titleStr = textView.text
        }else{
            infoStr = textView.text
        }
        self.changeNavigationBarItemColor()
        return true
    }
}
