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
        
        self.edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = UIColor.black

    }
    
    /**  控制器准备  */
    func vcPrepare(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoBrowser.singleTapAction), name: NSNotification.Name(rawValue: CFPBSingleTapNofi), object: nil)
    
        if showType != PhotoBrowser.ShowType.zoomAndDismissWithSingleTap {
            
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
        navigaitonBar.backgroundColor = UIColor.white
        let line = UILabel()
        line.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        navigaitonBar.addSubview(line)
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.init(named: "navigationbar_back"), for: UIControlState())
        backButton.addTarget(self, action: #selector(PhotoBrowser.dismissPrepare), for: .touchUpInside)
        navigaitonBar.addSubview(backButton)
        
        let deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage.init(named: "navigation_delete"), for: UIControlState())
        deleteButton.addTarget(self, action: #selector(PhotoBrowser.deleteImage), for: .touchUpInside)
        navigaitonBar.addSubview(deleteButton)

        let photoImage = UIImageView()
        let imageArray = avatar.components(separatedBy: "?")
        UIImage.image(withUrl: imageArray[0], newImage: CGSize.init(width: 24, height: 24), success:{imageUrl in
            photoImage.sd_setImage(with: URL.init(string: imageArray[0] + imageUrl!), placeholderImage: UIImage.init(color: UIColor.init(hexString: "e7e7e7"), size: CGSize(width: 24, height: 24)), options: .retryFailed)
        })
        
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
        positionLabel.textAlignment = .left
        navigaitonBar.addSubview(positionLabel)
        
        let stringWidth = positionString.stringWidth(positionString, font: AppointRealNameLabelFont!, height: 20.0) > ScreenWidth - 200 ? ScreenWidth - 200 : positionString.stringWidth(positionString, font: AppointRealNameLabelFont!, height: 20.0)
        self.view.addSubview(navigaitonBar)
        navigaitonBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.height.equalTo(64)
        }
        backButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(navigaitonBar.snp.bottom).offset(-3)
            make.left.equalTo(navigaitonBar.snp.left).offset(0)
            make.size.equalTo(CGSize(width: 40, height: 40))
            
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(navigaitonBar.snp.bottom).offset(-3)
            make.right.equalTo(navigaitonBar.snp.right).offset(-10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        positionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(navigaitonBar.snp.centerX).offset(20)
            make.bottom.equalTo(navigaitonBar.snp.bottom).offset(-14)
            make.width.equalTo(stringWidth + 2)
        }
        
        photoImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(navigaitonBar.snp.bottom).offset(-11)
            make.right.equalTo(positionLabel.snp.left).offset(-10)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    
    }
    
    /** 保存 */
    func saveAction(){
        
        if photoArchiverArr.contains(page) {showHUD("已经保存", autoDismiss: 2); return}
        
        let itemCell = collectionView.cellForItem(at: IndexPath(item: page, section: 0)) as! ItemCell
        
        if itemCell.imageV.image == nil {showHUD("图片未下载", autoDismiss: 2); return}
        
        if !itemCell.hasHDImage {showHUD("图片未下载", autoDismiss: 2); return}
        
        showHUD("保存中", autoDismiss: -1)
    
        UIImageWriteToSavedPhotosAlbum(itemCell.imageV.image!, self, #selector(PhotoBrowser.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        self.view.isUserInteractionEnabled = false
    }

    /** come on */
    func image(_ image: UIImage, didFinishSavingWithError: NSError, contextInfo:UnsafeRawPointer){
     
        self.view.isUserInteractionEnabled = true
        
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
        
        let alertControl = UIAlertController(title: "确定删除此照片吗？", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (cancelAction) in
            
        }
        let confirmAction = UIAlertAction(title: "删除", style: .destructive) { (doneAction) in
            if self.deletePhoto != nil && self.photoModels.count > 0{
                var deleteSucess:DeleteSuccess!
                deleteSucess = { sucess -> Void in
                    DispatchQueue.main.async(execute: {
                        if sucess {
                            
                            self.photoModels.remove(at: self.page)
                            self.pagecontrol.numberOfPages = self.photoModels.count
                            if self.photoModels.count == 0 {
                                _ = self.navigationController?.popViewController(animated: true)
                            }else{
                                self.collectionView.reloadData()
                            }
                        }else{
                            self.showHUD("删除失败", autoDismiss: 2)
                            
                        }
                    })
                }
                if self.photoModels.count > 0 {
                    let photoModel = self.photoModels[self.page]
                    self.deletePhoto(self.page,photoModel.titleStr, deleteSucess)
                }
            }
        }
        alertControl.addAction(cancelAction)
        alertControl.addAction(confirmAction)
        self.present(alertControl, animated: true) { 
            
        }
        
    }
    
    /**  单击事件  */
    func singleTapAction(){
        
        if showType != PhotoBrowser.ShowType.zoomAndDismissWithSingleTap {

            if navigaitonBar.isHidden{
                navigaitonBar.isHidden = false
                UIApplication.shared.isStatusBarHidden = false
                collectionView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor)
            }else{
                navigaitonBar.isHidden = true
                UIApplication.shared.isStatusBarHidden = true
                collectionView.backgroundColor = UIColor.black
            }
            //取出cell
            let cell = collectionView.cellForItem(at: IndexPath(item: page, section: 0)) as! ItemCell
            cell.toggleDisplayBottomBar(isHiddenBar)
            cell.bottomContentView.isHidden = true
        }else{
            
            dismissPrepare()
        }
        
        
    }
    
    
    func dismissAction(_ isZoomType: Bool){
        
        UIApplication.shared.isStatusBarHidden = isStatusBarHidden
        
        if vc.navigationController != nil {vc.navigationController?.isNavigationBarHidden = isNavBarHidden}
        if vc.tabBarController != nil {vc.tabBarController?.tabBar.isHidden = isTabBarHidden}
        
        if showType == ShowType.push || showType == ShowType.modal {return}
        
        /** 关闭动画 */
        zoomOutWithAnim(page)
        
        UserDefaults.standard.set(false, forKey: CFPBShowKey)
        NotificationCenter.default.post(name: Notification.Name(rawValue: PhotoBrowserDidDismissNoti), object: self)
    }
    
    
    func dismissPrepare(){
        
        if showType == .push{
            
            self.navigationController?.popViewController(animated: true)
            
            dismissAction(false)
            
        }else if showType == .modal{
            
            self.dismiss(animated: true, completion: nil)
            
            dismissAction(false)
            
        } else if showType == ShowType.zoomAndDismissWithSingleTap{
            
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
        
        UserDefaults.standard.set(true, forKey: CFPBShowKey)
        
        isStatusBarHidden = UIApplication.shared.isStatusBarHidden
        
        UIApplication.shared.isStatusBarHidden = true
        
        //记录index
        showIndex = index
        
        //记录
        self.vc = vc
        
        let navVC = vc.navigationController
        
        if vc.navigationController != nil { isNavBarHidden = vc.navigationController?.isNavigationBarHidden}
        if vc.tabBarController != nil { isTabBarHidden = vc.tabBarController?.tabBar.isHidden}
        
        navVC?.isNavigationBarHidden = true
        vc.tabBarController?.tabBar.isHidden = true
        
        if showType == .push{//push
            vc.hidesBottomBarWhenPushed = true
            
            /** pagecontrol准备 */
            pagecontrolPrepare()
            pagecontrol.currentPage = index
            self.pageControlPageChanged(index)
            self.collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition())
            vc.navigationController?.pushViewController(self, animated: true)
            
        }else if showType == .modal{
            
            vc.present(self, animated: true, completion: nil)
            
        }else{
            
            //添加子控制器
            vc.view.addSubview(self.view)
            
            //添加约束
            self.view.make_4Inset(UIEdgeInsets.zero)
            
            vc.addChildViewController(self)
            
            /** 展示动画 */
            zoomInWithAnim(index)
            
            if showType == PhotoBrowser.ShowType.zoomAndDismissWithSingleTap && hideMsgForZoomAndDismissWithSingleTap {
            
                /** pagecontrol准备 */
                pagecontrolPrepare()
                pagecontrol.currentPage = index
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: PhotoBrowserDidShowNoti), object: self)
    
    }
    
    
}
