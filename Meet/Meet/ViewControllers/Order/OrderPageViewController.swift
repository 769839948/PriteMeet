//
//  OrderPageViewController.swift
//  Meet
//
//  Created by Zhang on 7/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

let kCollectionLayoutEdging:CGFloat = 25
let kCellSpacing:CGFloat = 10

typealias ReloadOrderNumber = () ->Void

enum LoadType {
    case Present
    case Push
}

class OrderPageViewController: TYTabButtonPagerController {

    let viewModel:OrderViewModel = OrderViewModel()
    let orderConfimViewController = OrderConfirmViewController()
    let orderPayViewController = OrderPayViewController()
    let orderMeetViewController = OrderMeetViewController()
    let orderAllViewController = OrderAllViewController()
    var pageViewControllers:NSArray!
    
    var numberArray:NSMutableArray = NSMutableArray(array: ["0","0","0","0"])
    
    var loadType:LoadType!
    
    var reloadOrderNumber:ReloadOrderNumber!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的约见"
        pageViewControllers = [orderConfimViewController,orderPayViewController,orderMeetViewController,orderAllViewController]
        self.setUpPageViewControllerStyle()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrderPageViewController.reloadOtherCollectView(_:)), name: ReloadOrderCollectionView, object: nil)
        if loadType == .Present {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(OrderPageViewController.leftBtnPress(_:)))
        }else{
             self.setNavigationItemBack()
        }
        self.talKingDataPageName = "Order-Order-Page"
        self.navigationItemWhiteColorAndNotLine()
        // Do any additional setup after loading the view.
    }
    
    func disMisstView(sendre:UINavigationItem) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItemWhiteColorAndNotLine()
        self.removeBottomLine()
        self.reloadPageNumber()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpPageViewControllerStyle(){
        var stringSize:CGFloat = 0
        for string in viewModel.orderPageControllerTitle() as NSArray {
            let str = string as! String
            let width = str.stringWidth(str, font: LoginCodeLabelFont!, height: 28)
            stringSize = stringSize + width
        }
        self.adjustStatusBarHeight = true
        let count = (viewModel.orderPageControllerTitle() as NSArray).count - 1
        let cellEdging = (ScreenWidth - kCollectionLayoutEdging * 2 - stringSize - CGFloat(count) * kCellSpacing)/8
        self.collectionLayoutEdging = kCollectionLayoutEdging
        self.pagerBarColor = UIColor.redColor()
        self.cellSpacing = kCellSpacing
        self.cellEdging = cellEdging
        self.progressHeight = 0.5
        self.progressEdging = 0
        self.contentTopEdging = 49
        self.collectionViewBar.scrollEnabled = false
        self.normalTextFont = LoginCodeLabelFont
        self.selectedTextFont = LoginCodeLabelFont
        self.normalTextColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        self.selectedTextColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        self.selectedTextFont = LoginCodeSelectLabelFont
    }

    
    func leftBtnPress(sender:UIBarButtonItem) {
        if self.reloadOrderNumber != nil {
            self.reloadOrderNumber()
            self.navigationController?.dismissViewControllerAnimated(true, completion: {
                
            })
        }
        
    }
    
    func reloadPageNumber(){
        let orderViewModel = OrderViewModel()
        orderViewModel.orderNumberOrder(UserInfo.sharedInstance().uid, successBlock: { (dic) in
            let countDic = dic as NSDictionary
            self.numberArray.removeAllObjects()
            self.numberArray.addObject("\(countDic["1"]!)")
            self.numberArray.addObject("\(countDic["4"]!)")
            self.numberArray.addObject("\(countDic["6"]!)")
            self.numberArray.addObject("0")
            dispatch_async(dispatch_get_main_queue(), { 
                self.reloadNumberOfPageIndex(self.numberArray as [AnyObject])
            })
        }) { (dic) in
            
        }
    }
    
    func reloadOtherCollectView(notification:NSNotification) {
//        if notification.object as! String == "2" || notification.object as! String == "3"{
//            orderConfimViewController.reloaCollectViewData()
//            orderAllViewController.reloaCollectViewData()
//        }else if notification.object as! String == "4" || notification.object as! String == "1" || notification.object as! String == "6"{
//            orderConfimViewController.reloaCollectViewData()
//            orderPayViewController.reloaCollectViewData()
//            orderMeetViewController.reloaCollectViewData()
//            orderAllViewController.reloaCollectViewData()
//        }else if notification.object as! String == "11" {
//            orderMeetViewController.reloaCollectViewData()
//            orderAllViewController.reloaCollectViewData()
//        }else if notification.object as! String == "13" || notification.object as! String == "12"{
//            orderPayViewController.reloaCollectViewData()
//            orderAllViewController.reloaCollectViewData()
//        }else if notification.object as! String == "7" || notification.object as! String == "9"{
//            orderMeetViewController.reloaCollectViewData()
//            orderAllViewController.reloaCollectViewData()
//        }else {
            orderConfimViewController.reloaCollectViewData()
            orderMeetViewController.reloaCollectViewData()
            orderPayViewController.reloaCollectViewData()
            orderAllViewController.reloaCollectViewData()
//        }
    }
    
    
    func reloadNumberOfMeet(indexController:NSInteger){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setBarStyle(barStyle: TYPagerBarStyle) {
        super.setBarStyle(barStyle)
    }
    
    // MARK: - TYTabButtonDelegate
    override func pagerController(pagerController: TYTabPagerController!, configreCell cell: UICollectionViewCell!, forItemTitle title: String!, atIndexPath indexPath: NSIndexPath!) {
        super.pagerController(pagerController, configreCell: cell, forItemTitle: title, atIndexPath: indexPath)
    }
    
    override func pagerController(pagerController: TYTabPagerController!, didSelectAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    override func pagerController(pagerController: TYTabPagerController!, didScrollToTabPageIndex index: Int) {
        
    }
    
     // MARK: - TYTabButtonDataSource
    override func numberOfControllersInPagerController() -> Int {
        return 4
    }
    
    override func pagerController(pagerController: TYPagerController!, titleForIndex index: Int) -> String! {
        return  (viewModel.orderPageControllerTitle() as NSArray).objectAtIndex(index) as! String
        
    }
    
    override func pagerController(pagerController: TYPagerController!, controllerForIndex index: Int) -> UIViewController! {
        let controller = pageViewControllers[index] as! BaseOrderPageViewController
        controller.allMeetOrder = { allNumber, statues in
            var page:NSInteger = 0
            if statues == "1" {
                page = 0
                self.setNumberOfControllerBar(allNumber, controller: page)
            }else if statues == "4" {
                page = 1
                self.setNumberOfControllerBar(allNumber, controller: page)
            }else if statues == "6" {
                page = 2
                self.setNumberOfControllerBar(allNumber, controller: page)
            }
        }
        return controller
    }
    
    override func pagerController(pagerController: TYPagerController!, numberForIndex index: Int) -> String! {
        return numberArray[index] as! String
    }
}
