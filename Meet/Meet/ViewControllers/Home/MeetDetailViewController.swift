//
//  MeetDetailViewController.swift
//  Demo
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
 
class MeetDetailViewController: UIViewController {

    var tableView:UITableView!
    let sectionInfoTableViewCell = "SectionInfoTableViewCell"
    let newMeetInfoTableViewCell = "NewMeetInfoTableViewCell"
    let wantMeetTableViewCell = "WantMeetTableViewCell"
    let aboutUsInfoTableViewCell = "AboutUsInfoTableViewCell"
    let photoTableViewCell = "PhotoTableViewCell"
    let meetInfoTableViewCell = "MeetInfoTableViewCell"
    
    override func viewDidLoad() {
//        self.navigationController?.navigationBar.translucent = false;
//        self.navigationController?.navigationBar.hidden = false;
        self.showNavBarAnimated(true)
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpNavigationBar()
        // Do any additional setup after loading the view.
    }

    func setUpTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64), style: .Grouped)
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(PhotoTableViewCell.self, forCellReuseIdentifier: photoTableViewCell)
        self.tableView.registerClass(MeetInfoTableViewCell.self, forCellReuseIdentifier: meetInfoTableViewCell)
        self.tableView.registerClass(AboutUsInfoTableViewCell.self, forCellReuseIdentifier: aboutUsInfoTableViewCell)
        self.tableView.registerClass(SectionInfoTableViewCell.self, forCellReuseIdentifier: sectionInfoTableViewCell)
        self.tableView.registerClass(NewMeetInfoTableViewCell.self, forCellReuseIdentifier: newMeetInfoTableViewCell)
        self.tableView.registerClass(WantMeetTableViewCell.self, forCellReuseIdentifier: wantMeetTableViewCell)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.view.addSubview(self.tableView)
        
        
    }
    
    func setUpNavigationBar(){
//        UITools.customNavigationBackButtonForController(self, action: #selector(MeetDetailViewController.leftItemClick(_:)), normalImage: UIImage(named: "navigationbar_back"), selectImage: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeetDetailViewController.leftItemClick(_:)))
        self.navigaitonItemColor(UIColor.init(hexString: "202020"))
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.init(hexString: "202020")
//        let uploadItem = UIBarButtonItem(image: UIImage(named: "navigationbar_upload"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeetDetailViewController.rigthItemClick(_:)))
        let uploadBt = UIButton(type: UIButtonType.Custom)
        uploadBt.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        uploadBt.setImage(UIImage(named: "navigationbar_upload"), forState: UIControlState.Normal)
        uploadBt.frame = CGRectMake(0, 0, 40, 40);
        let uploadItem = UIBarButtonItem(customView: uploadBt)
        
        let colloctBt = UIButton(type: UIButtonType.Custom)
        colloctBt.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        colloctBt.setImage(UIImage(named: "navigationbar_collect"), forState: UIControlState.Normal)
        colloctBt.frame = CGRectMake(0, 0, 60, 40);
        colloctBt.titleLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 14.0)
        colloctBt.setTitle(" 668", forState: UIControlState.Normal)
        let colloctItem = UIBarButtonItem(customView: colloctBt)
        self.navigationItem.rightBarButtonItems = [uploadItem,colloctItem]
    }
    
    func leftItemClick(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rigthItemClick(sender:UIBarButtonItem){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aboutUsHeight(stringArray:NSArray) -> CGFloat {
        var height:CGFloat = 10.0
        for item in stringArray {
            _ = item as! String
            height = height + item.heightWithFont(UIFont.init(name: "PingFangTC-Light", size: 14.0), constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 38) + 10
        }
        
        return height
    }
    
    func meetHeight(meetString:String, instrestArray:NSArray) -> CGFloat
    {
        var instresTitleString = "  ";
        for string in instrestArray {
            instresTitleString = instresTitleString.stringByAppendingString(string as! String)
            instresTitleString = instresTitleString.stringByAppendingString("    ")
        }
        
        let instrestHeight = instresTitleString.heightWithFont(UIFont.init(name: "PingFangTC-Light", size: 21.0), constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 40) + 10 
        let titleHeight = meetString.heightWithFont(UIFont.init(name: "PingFangTC-Light", size: 14.0), constrainedToWidth: UIScreen.mainScreen().bounds.size.width - 38)
        return titleHeight + instrestHeight + 60
    }

}

extension MeetDetailViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension MeetDetailViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        case 2:
            return 2
        case 3:
            return 5
        default:
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return (UIScreen.mainScreen().bounds.size.width - 20)*236/255
            case 1:
                return 195
            case 2:
                
                return 77
            default:
                return 49
            }
        case 1:
            switch indexPath.row {
            case 0:
                return 49
            default:
                return 210;
//                return self.aboutUsHeight(["毕业于中央戏剧学院表演系，是一名制片人，也是隐舍 THESECRET 的掌门人。","最不像表演系的表演系学生，这点从入学开始就逐渐暴露，同学和老师评价我是表演系里最会导演的，导演系里最会制片的，制片专业里长得最好看。","喜欢戏剧，喜欢电影，喜欢旅行，做过制片人，地产，投资，酒吧。"]) + 30 + 20
            }
        case 2:
            switch indexPath.row {
            case 0:
                return 49
            default:
                
                return 223
            }
        default:
            switch indexPath.row {
            case 0:
                return 49
            default:
                return 123
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return (UIScreen.mainScreen().bounds.size.width - 20)*236/255
            case 1:
                return 195
            case 2:
                
                return 104
            default:
                return 49
            }
        case 1:
            switch indexPath.row {
            case 0:
                return 49
            default:
                
                return self.aboutUsHeight(["毕业于中央戏剧学院表演系，是一名制片人，也是隐舍 THESECRET 的掌门人。","最不像表演系的表演系学生，这点从入学开始就逐渐暴露，同学和老师评价我是表演系里最会导演的，导演系里最会制片的，制片专业里长得最好看。","喜欢戏剧，喜欢电影，喜欢旅行，做过制片人，地产，投资，酒吧。"]) + 30
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                return 49
            default:
                
                return self.meetHeight("欢迎来到隐舍 THESECRET。这里没有酒单， 放眼望去，你看到的是与弗里达相关的一切，迷人而神秘的夜色。走进这扇门，你将开始一段奇遇。在这里，我将根据你的喜好、心情，调制专属于你的鸡尾酒，为你带来最奇妙的美好体验。", instrestArray: ["周边旅行","谈天说地","聊天","创业咨询","品酒","定制理财"])
            }
        default:
            switch indexPath.row {
            case 0:
                return 49
            default:
                return 123
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier(photoTableViewCell, forIndexPath: indexPath) as! PhotoTableViewCell
                    cell.configCell()
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCellWithIdentifier(meetInfoTableViewCell, forIndexPath: indexPath) as! MeetInfoTableViewCell
                    cell.configCell("尤雅", position: "隐舍THESECRET 掌门人", meetNumber: "上海 浦东新区   和你相隔 28200", interestCollectArray: ["美食顾问","Cocktail","谈判专家","顾问"])
                    return cell
                case 2:
                    let identifier = "CompayTableViewCell"
                    var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
                    if cell == nil{
                        cell = CompayTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
                    }
                    return cell!
                default:
                    let identifier = "MoreTableViewCell"
                    var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
                    if cell == nil{
                        cell = AllInfoTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
                    }
                    return cell!
                }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                    cell.configCell("meetdetail_aboutus", titleString: "关于我们的那些事")
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(aboutUsInfoTableViewCell, forIndexPath: indexPath) as! AboutUsInfoTableViewCell
                cell.configCell(["毕业于中央戏剧学院表演系，是一名制片人，也是隐舍 THESECRET 的掌门人。","最不像表演系的表演系学生，这点从入学开始就逐渐暴露，同学和老师评价我是表演系里最会导演的，导演系里最会制片的，制片专业里长得最好看。","喜欢戏剧，喜欢电影，喜欢旅行，做过制片人，地产，投资，酒吧。"])
                return cell
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                cell.configCell("meetdetail_newmeet", titleString: "最新邀约")
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(newMeetInfoTableViewCell, forIndexPath: indexPath) as! NewMeetInfoTableViewCell
                cell.configCell("欢迎来到隐舍 THESECRET。这里没有酒单， 放眼望去，你看到的是与弗里达相关的一切，迷人而神秘的夜色。走进这扇门，你将开始一段奇遇。在这里，我将根据你的喜好、心情，调制专属于你的鸡尾酒，为你带来最奇妙的美好体验。", array: ["周边旅行","谈天说地","聊天","创业咨询","品酒","定制理财"])
                return cell
            }
        default:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(sectionInfoTableViewCell, forIndexPath: indexPath) as! SectionInfoTableViewCell
                cell.configCell("meetdetail_wantmeet", titleString: "更多想见的人")
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(wantMeetTableViewCell, forIndexPath: indexPath) as! WantMeetTableViewCell
                cell.textLabel?.text = "更多想见的人"
                return cell
            }
        }
        
    }
}


