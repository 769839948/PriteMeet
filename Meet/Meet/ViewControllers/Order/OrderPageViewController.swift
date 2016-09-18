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
    case present
    case push
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
        NotificationCenter.default.addObserver(self, selector: #selector(OrderPageViewController.reloadOtherCollectView(_:)), name: NSNotification.Name(rawValue: ReloadOrderCollectionView), object: nil)
        if loadType == .present {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(OrderPageViewController.leftBtnPress(_:)))
        }else{
             self.setNavigationItemBack()
        }
        self.talKingDataPageName = "Order-Order-Page"
        self.navigationItemWhiteColorAndNotLine()
        // Do any additional setup after loading the view.
    }
    
    func disMisstView(_ sendre:UINavigationItem) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        _ = (viewModel.orderPageControllerTitle() as NSArray).count
        let cellEdging = ((ScreenWidth - kCollectionLayoutEdging * 2 - stringSize - CGFloat(4) * kCellSpacing) / CGFloat(8))
        self.collectionLayoutEdging = kCollectionLayoutEdging
        self.pagerBarColor = UIColor.red
        self.cellSpacing = kCellSpacing
        self.cellEdging = cellEdging
        self.progressHeight = 0.5
        self.progressEdging = 0
        self.contentTopEdging = 49
        self.collectionViewBar.isScrollEnabled = false
        self.normalTextFont = LoginCodeLabelFont
        self.selectedTextFont = LoginCodeLabelFont
        self.normalTextColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        self.selectedTextColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        self.selectedTextFont = LoginCodeSelectLabelFont
    }

    
    func leftBtnPress(_ sender:UIBarButtonItem) {
        if self.reloadOrderNumber != nil {
            self.reloadOrderNumber()
            self.navigationController?.dismiss(animated: true, completion: {
                
            })
        }
        
    }
    
    func reloadPageNumber(){
        let orderViewModel = OrderViewModel()
        orderViewModel.orderNumberOrder(UserInfo.sharedInstance().uid, successBlock: { (dic) in
            self.numberArray.removeAllObjects()
            self.numberArray.add("\(dic?["1"]!)")
            self.numberArray.add("\(dic?["4"]!)")
            self.numberArray.add("\(dic?["6"]!)")
            self.numberArray.add("0")
            DispatchQueue.main.async(execute: { 
                self.reloadNumber(ofPageIndex: self.numberArray as [AnyObject])
            })
        }) { (dic) in
            
        }
    }
    
    func reloadOtherCollectView(_ notification:Notification) {
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
    
    
    func reloadNumberOfMeet(_ indexController:NSInteger){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setBarStyle(_ barStyle: TYPagerBarStyle) {
        super.setBarStyle(barStyle)
    }
    
    // MARK: - TYTabButtonDelegate
    override func pagerController(_ pagerController: TYTabPagerController!, configreCell cell: UICollectionViewCell!, forItemTitle title: String!, at indexPath: IndexPath!) {
        super.pagerController(pagerController, configreCell: cell, forItemTitle: title, at: indexPath)
    }
    
    override func pagerController(_ pagerController: TYTabPagerController!, didSelectAt indexPath: IndexPath!) {
        
    }
    
    override func pagerController(_ pagerController: TYTabPagerController!, didScrollToTabPageIndex index: Int) {
        
    }
    
     // MARK: - TYTabButtonDataSource
    override func numberOfControllersInPagerController() -> Int {
        return 4
    }
    
    override func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        return  (viewModel.orderPageControllerTitle() as NSArray).object(at: index) as! String
        
    }
    
    override func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController! {
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
    
    override func pagerController(_ pagerController: TYPagerController!, numberFor index: Int) -> String! {
        return numberArray[index] as! String
    }
}
