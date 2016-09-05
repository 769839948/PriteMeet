//
//  PhotoBrowser+Main.swift
//  PhotoBrowser
//
//  Created by 成林 on 15/7/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit


extension PhotoBrowser{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**  准备  */
        collectionViewPrepare()
        
        /**  控制器准备  */
        vcPrepare()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        view.backgroundColor = UIColor.blackColor()

    }
    
    /**  控制器准备  */
    func vcPrepare(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoBrowser.singleTapAction), name: CFPBSingleTapNofi, object: nil)
    
        if showType != PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap {
            
            self.setUpCustomNavigationBar()
            
//            dismissBtn = UIButton(frame: CGRectMake(0, 0, 40, 40))
//            dismissBtn.setBackgroundImage(UIImage(named: "pic.bundle/cancel"), forState: UIControlState.Normal)
//            dismissBtn.addTarget(self, action: #selector(PhotoBrowser.dismissPrepare), forControlEvents: UIControlEvents.TouchUpInside)
//            self.view.addSubview(dismissBtn)
//        
//            //保存按钮
//            saveBtn = UIButton()
//            saveBtn.setBackgroundImage(UIImage(named: "pic.bundle/save"), forState: UIControlState.Normal)
//            saveBtn.addTarget(self, action: #selector(PhotoBrowser.saveAction), forControlEvents: UIControlEvents.TouchUpInside)
//            self.view.addSubview(saveBtn)
//            saveBtn.make_rightTop_WH(top: 0, right: 0, rightWidth: 40, topHeight: 40)
        }
    }
    
    func setUpCustomNavigationBar(){
        navigaitonBar = UIView()
        navigaitonBar.backgroundColor = UIColor.whiteColor()
        let line = UILabel()
        line.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        navigaitonBar.addSubview(line)
        
        let backButton = UIButton(type: .Custom)
        backButton.setImage(UIImage.init(named: "navigationbar_back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(PhotoBrowser.dismissPrepare), forControlEvents: .TouchUpInside)
        navigaitonBar.addSubview(backButton)
        
        let deleteButton = UIButton(type: .Custom)
        deleteButton.setImage(UIImage.init(named: "navigation_delete"), forState: .Normal)
        deleteButton.addTarget(self, action: #selector(PhotoBrowser.deleteImage), forControlEvents: .TouchUpInside)
        navigaitonBar.addSubview(deleteButton)

        let photoImage = UIImageView()
        let imageArray = avatar.componentsSeparatedByString("?")
        photoImage.sd_setImageWithURL(NSURL.init(string: imageArray[0].stringByAppendingString(AvatarImageSize)), placeholderImage: UIImage.init(color: UIColor.init(hexString: "e7e7e7"), size: CGSizeMake(24, 24)), options: .RetryFailed)
        photoImage.layer.cornerRadius = 12.0
        photoImage.layer.masksToBounds = true
        navigaitonBar.addSubview(photoImage)
        
        let positionLabel = UILabel()
        let positionString = "\(realName) \(jobName)"
        let attributedString = NSMutableAttributedString(string: positionString)
        attributedString.addAttributes([NSFontAttributeName:AppointRealNameLabelFont!], range: NSRange.init(location: 0, length: realName.length))
        attributedString.addAttributes([NSFontAttributeName:AppointPositionLabelFont!], range: NSRange.init(location: realName.length + 1, length: jobName.length))
        attributedString.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: HomeDetailViewNameColor)], range: NSRange.init(location: 0, length: positionString.length))
        positionLabel.attributedText = attributedString
        positionLabel.textAlignment = .Center        
        navigaitonBar.addSubview(positionLabel)
        
        let stringWidth = positionString.stringWidth(positionString, font: AppointRealNameLabelFont!, height: 20.0) > ScreenWidth - 200 ? ScreenWidth - 200 : positionString.stringWidth(positionString, font: AppointRealNameLabelFont!, height: 20.0)
        self.view.addSubview(navigaitonBar)
        navigaitonBar.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.height.equalTo(64)
        }
        backButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(navigaitonBar.snp_bottom).offset(-3)
            make.left.equalTo(navigaitonBar.snp_left).offset(0)
            make.size.equalTo(CGSizeMake(40, 40))
            
        }
        
        deleteButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(navigaitonBar.snp_bottom).offset(-3)
            make.right.equalTo(navigaitonBar.snp_right).offset(-10)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        
        positionLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(navigaitonBar.snp_centerX).offset(20)
            make.bottom.equalTo(navigaitonBar.snp_bottom).offset(-14)
            make.width.equalTo(stringWidth + 10)
        }
        
        photoImage.snp_makeConstraints { (make) in
            make.bottom.equalTo(navigaitonBar.snp_bottom).offset(-10)
            make.right.equalTo(positionLabel.snp_left).offset(-12)
            make.size.equalTo(CGSizeMake(24, 24))
        }
    
    }
    
    /** 保存 */
    func saveAction(){
        
        if photoArchiverArr.contains(page) {showHUD("已经保存", autoDismiss: 2); return}
        
        let itemCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: page, inSection: 0)) as! ItemCell
        
        if itemCell.imageV.image == nil {showHUD("图片未下载", autoDismiss: 2); return}
        
        if !itemCell.hasHDImage {showHUD("图片未下载", autoDismiss: 2); return}
        
        showHUD("保存中", autoDismiss: -1)
    
        UIImageWriteToSavedPhotosAlbum(itemCell.imageV.image!, self, #selector(PhotoBrowser.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        self.view.userInteractionEnabled = false
    }

    /** come on */
    func image(image: UIImage, didFinishSavingWithError: NSError, contextInfo:UnsafePointer<Void>){
     
        self.view.userInteractionEnabled = true
        
        if (didFinishSavingWithError as NSError?) == nil {
            showHUD("保存失败", autoDismiss: 2)
        }
        else{
            showHUD("保存成功", autoDismiss: 2)
            
            //记录
            photoArchiverArr.append(page)
        }
    }
    
    func deleteImage() {
        
        let alertControl = UIAlertController(title: "确定删除此照片吗？", message: "", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Default) { (cancelAction) in
            
        }
        let confirmAction = UIAlertAction(title: "删除", style: .Destructive) { (doneAction) in
            if self.deletePhoto != nil && self.photoModels.count > 0{
                var deleteSucess:DeleteSuccess!
                deleteSucess = { sucess -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        if sucess {
                            self.photoModels.removeAtIndex(self.page)
                            self.pagecontrol.numberOfPages = self.photoModels.count
                            self.collectionView.reloadData()
                        }else{
                            self.showHUD("删除失败", autoDismiss: 2)
                            
                        }
                    })
                }
                if self.photoModels.count > 0 {
                    self.deletePhoto(index: self.page,deleteSucess: deleteSucess)
                }
            }
        }
        alertControl.addAction(cancelAction)
        alertControl.addAction(confirmAction)
        self.presentViewController(alertControl, animated: true) { 
            
        }
        
    }
    
    /**  单击事件  */
    func singleTapAction(){
        
        if showType != PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap {

            if navigaitonBar.hidden{
                navigaitonBar.hidden = false
                UIApplication.sharedApplication().statusBarHidden = false
                collectionView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
            }else{
                navigaitonBar.hidden = true
                UIApplication.sharedApplication().statusBarHidden = true
                collectionView.backgroundColor = UIColor.blackColor()
            }
            //取出cell
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: page, inSection: 0)) as! ItemCell
            cell.toggleDisplayBottomBar(isHiddenBar)
            cell.bottomContentView.hidden = true
        }else{
            
            dismissPrepare()
        }
        
        
    }
    
    
    func dismissAction(isZoomType: Bool){
        
        UIApplication.sharedApplication().statusBarHidden = isStatusBarHidden
        
        if vc.navigationController != nil {vc.navigationController?.navigationBarHidden = isNavBarHidden}
        if vc.tabBarController != nil {vc.tabBarController?.tabBar.hidden = isTabBarHidden}
        
        if showType == ShowType.Push || showType == ShowType.Modal {return}
        
        /** 关闭动画 */
        zoomOutWithAnim(page)
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: CFPBShowKey)
        NSNotificationCenter.defaultCenter().postNotificationName(PhotoBrowserDidDismissNoti, object: self)
    }
    
    
    func dismissPrepare(){
        
        if showType == .Push{
            
            self.navigationController?.popViewControllerAnimated(true)
            
            dismissAction(false)
            
        }else if showType == .Modal{
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            dismissAction(false)
            
        } else if showType == ShowType.ZoomAndDismissWithSingleTap{
            
            dismissAction(true)
            
        }else{
            
            dismissAction(true)
        }
    }
    
    func show(inVC vc: UIViewController,index: Int){
        assert(showType != nil, "Error: You Must Set showType!")
        assert(photoType != nil, "Error: You Must Set photoType!")
        assert(photoModels != nil, "Error: You Must Set DataModels!")
        assert(index <= photoModels.count - 1, "Error: Index is Out of DataModels' Boundary!")
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: CFPBShowKey)
        
        isStatusBarHidden = UIApplication.sharedApplication().statusBarHidden
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        //记录index
        showIndex = index
        
        //记录
        self.vc = vc
        
        let navVC = vc.navigationController
        
        if vc.navigationController != nil { isNavBarHidden = vc.navigationController?.navigationBarHidden}
        if vc.tabBarController != nil { isTabBarHidden = vc.tabBarController?.tabBar.hidden}
        
        navVC?.navigationBarHidden = true
        vc.tabBarController?.tabBar.hidden = true
        
        if showType == .Push{//push
            vc.hidesBottomBarWhenPushed = true
            
            /** pagecontrol准备 */
            pagecontrolPrepare()
            pagecontrol.currentPage = index
            
            vc.navigationController?.pushViewController(self, animated: true)
            
        }else if showType == .Modal{
            
            vc.presentViewController(self, animated: true, completion: nil)
            
        }else{
            
            //添加子控制器
            vc.view.addSubview(self.view)
            
            //添加约束
            self.view.make_4Inset(UIEdgeInsetsZero)
            
            vc.addChildViewController(self)
            
            /** 展示动画 */
            zoomInWithAnim(index)
            
            if showType == PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap && hideMsgForZoomAndDismissWithSingleTap {
            
                /** pagecontrol准备 */
                pagecontrolPrepare()
                pagecontrol.currentPage = index
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(PhotoBrowserDidShowNoti, object: self)
    
    }
    
    
}