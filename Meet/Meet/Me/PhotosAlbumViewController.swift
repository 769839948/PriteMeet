//
//  PhotosAlbumViewController.swift
//  PhotoAlbum
//
//  Created by Zhang on 8/27/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import Photos

@objc public protocol PhotosAlbumViewControllerDelegate : class {
    func albumImageSelected(image: UIImage)
    optional func albumImageDismissedWithImage(image: UIImage)
    func albumImageVideoCompleted(withFileURL fileURL: NSURL)
    func albumImageCameraRollUnauthorized()
    optional func albumImageClosed()
}


class PhotosAlbumViewController: UIViewController {

    var tableView:UITableView!
    var listArray:NSMutableArray = NSMutableArray()
    
    internal weak var delegate: PhotosAlbumViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.setUpTableView()
        self.navigationItemWithLineAndWihteColor()
        self.title = "选择相册"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(PhotosAlbumViewController.dismissView))
        // Do any additional setup after loading the view.
    }
    
    func dismissView() {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

    func configTableView() {
        let manager = TZImageManager()
        manager.getAllAlbums(false, allowPickingImage: true) { (model) in
            self.listArray.addObjectsFromArray(model)
        }
    }
    
    func setUpTableView() {
        if tableView == nil {
            tableView = UITableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64), style: .Plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 90
            tableView.separatorStyle = .None
            tableView.registerClass(TZAlbumCell.self, forCellReuseIdentifier: "PhotosAlbum")
            self.view.addSubview(tableView)
        }else{
           tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PhotosAlbumViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.images = (self.listArray[indexPath.row] as! TZAlbumModel).result as! PHFetchResult
        
        self.navigationController?.pushViewController(fusuma, animated: true)
    }
}

extension PhotosAlbumViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdef = "PhotosAlbum"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdef,forIndexPath: indexPath) as! TZAlbumCell
        let model = self.listArray[indexPath.row] as! TZAlbumModel
        cell.model = model
        cell.selectionStyle = .None
        return cell
    }
}



extension PhotosAlbumViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(changeInstance: PHChange) {
        
    }
}


extension PhotosAlbumViewController : FusumaDelegate {
    func fusumaImageSelected(image: UIImage) {
        self.delegate?.albumImageSelected(image)
    }
    func fusumaDismissedWithImage(image: UIImage) {
        self.delegate?.albumImageDismissedWithImage!(image)
    }
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        self.delegate?.albumImageVideoCompleted(withFileURL: fileURL)
    }
    func fusumaCameraRollUnauthorized() {
        self.delegate?.albumImageCameraRollUnauthorized()
    }
    
    func fusumaClosed() {
        self.delegate?.albumImageClosed!()
    }
}
