//
//  UIViewController+NavigationBar.swift
//  Meet
//
//  Created by Zhang on 7/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setNavigationItemBack(){
        let leftImage = UIImage.init(named: "navigationbar_back")
        let spacBarButton = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil);
        self.navigationItem.leftBarButtonItems = [spacBarButton,UIBarButtonItem(image: leftImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.backBtnPress(_:)))]
    }
    
    func backBtnPress(sender:UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setNavigationItemTinteColor() {
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:UIFont.systemFontOfSize(18.0)]
    }
}