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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.backBtnPress(_:)))
    }
    
    func backBtnPress(sender:UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
}