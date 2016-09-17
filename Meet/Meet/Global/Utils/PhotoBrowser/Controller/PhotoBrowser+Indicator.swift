//
//  PhotoBrowser+Indicator.swift
//  PhotoBrowser
//
//  Created by 冯成林 on 15/8/13.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

extension PhotoBrowser{
    
    /** pagecontrol准备 */
    func pagecontrolPrepare(){
        
        if !hideMsgForZoomAndDismissWithSingleTap {return}
        
        view.addSubview(pagecontrol)
        pagecontrol.make_bottomInsets_bottomHeight(left: 0, bottom: 0, right: 0, bottomHeight: 37)
        pagecontrol.numberOfPages = photoModels.count
        pagecontrol.pageIndicatorTintColor = UIColor.init(white: 0.88, alpha: 0.7)
        pagecontrol.currentPageIndicatorTintColor = UIColor.white
    
        pagecontrol.isEnabled = false
    }
    
    /** pageControl页面变动 */
    func pageControlPageChanged(_ page: Int){
        
        if page<0 || page>=photoModels.count {return}
        
        if showType == PhotoBrowser.ShowType.zoomAndDismissWithSingleTap && hideMsgForZoomAndDismissWithSingleTap{
        
            pagecontrol.currentPage = page
        }else if showType == PhotoBrowser.ShowType.push {
            pagecontrol.currentPage = page
        }
    }
}
