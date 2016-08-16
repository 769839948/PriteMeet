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
class OrderPageViewController: TYTabButtonPagerController {

    let viewModel:OrderViewModel = OrderViewModel()
    let orderConfimViewController = OrderConfirmViewController()
    let orderPayViewController = OrderPayViewController()
    let orderMeetViewController = OrderMeetViewController()
    let orderAllViewController = OrderAllViewController()
    var pageViewControllers:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.title = "我的约见"
        pageViewControllers = [orderConfimViewController,orderPayViewController,orderMeetViewController,orderAllViewController]
        self.navigationItemWhiteColorAndNotLine()
        self.setUpNavigationItem()
        self.setUpPageViewControllerStyle()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrderPageViewController.reloadOtherCollectView(_:)), name: ReloadOrderCollectionView, object: nil)
        // Do any additional setup after loading the view.
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
        self.progressHeight = 28
        self.progressEdging = 0
        self.contentTopEdging = 49
        self.collectionViewBar.scrollEnabled = false
        self.normalTextFont = LoginCodeLabelFont
        self.selectedTextFont = LoginCodeLabelFont
        self.normalTextColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        self.selectedTextColor = UIColor.init(hexString: HomeViewDetailAboutBtnColor)
    }
    
    func setUpNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(OrderPageViewController.leftBtnPress(_:)))
    }
    
    func leftBtnPress(sender:UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { 
            
        })
    }
    
    func reloadOtherCollectView(notification:NSNotification) {
        if notification.object as! String != "1" {
            orderPayViewController.reloaCollectViewData()
            orderMeetViewController.reloaCollectViewData()
            orderAllViewController.reloaCollectViewData()
        }else if notification.object as! String != "4" {
            orderConfimViewController.reloaCollectViewData()
            orderMeetViewController.reloaCollectViewData()
            orderAllViewController.reloaCollectViewData()
        }else if notification.object as! String != "6" {
            orderPayViewController.reloaCollectViewData()
            orderConfimViewController.reloaCollectViewData()
            orderAllViewController.reloaCollectViewData()
        }else{
            orderPayViewController.reloaCollectViewData()
            orderMeetViewController.reloaCollectViewData()
            orderConfimViewController.reloaCollectViewData()
        }
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
        return pageViewControllers[index] as! UIViewController
    }
    
    override func pagerController(pagerController: TYPagerController!, numberForIndex index: Int) -> String! {
        return "6"
    }
}
