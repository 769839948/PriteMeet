//
//  LoadingView.swift
//  Meet
//
//  Created by Zhang on 11/10/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class GlobalLoadingView: UIView {
    
    var activity:UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.frame.size = CGSize.init(width: 34, height: 34)
        activity.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight/2)
        self.addSubview(activity)
        activity.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showLoadingView(){
        let view = GlobalLoadingView.init(frame: .zero)
        view.tag = 9999
        KeyWindown?.addSubview(view)
    }
    
    class func dismissLoadingView(){
        let subArray = KeyWindown!.subviews
        for subView in subArray {
            if subView.tag == 9999 {
                subView.removeFromSuperview()
            }
        }
    }

}
