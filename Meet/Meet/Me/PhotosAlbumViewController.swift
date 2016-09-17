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
    func albumImageSelected(_ image: UIImage)
    @objc optional func albumImageDismissedWithImage(_ image: UIImage)
    func albumImageVideoCompleted(withFileURL fileURL: URL)
    func albumImageCameraRollUnauthorized()
    @objc optional func albumImageClosed()
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(PhotosAlbumViewController.dismissView))
        // Do any additional setup after loading the view.
    }
    
    func dismissView() {
        self.dismiss(animated: true) { 
            
        }
    }

    func configTableView() {
        let manager = TZImageManager()
        manager.getAllAlbums(false, allowPickingImage: true) { (model) in
            self.listArray.addObjects(from: model!)
        }
    }
    
    func setUpTableView() {
        if tableView == nil {
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64), style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 90
            tableView.separatorStyle = .none
            tableView.register(TZAlbumCell.self, forCellReuseIdentifier: "PhotosAlbum")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.images = (self.listArray[(indexPath as NSIndexPath).row] as! TZAlbumModel).result as! PHFetchResult
        
        self.navigationController?.pushViewController(fusuma, animated: true)
    }
}

extension PhotosAlbumViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdef = "PhotosAlbum"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdef,for: indexPath) as! TZAlbumCell
        let model = self.listArray[(indexPath as NSIndexPath).row] as! TZAlbumModel
        cell.model = model
        cell.selectionStyle = .none
        return cell
    }
}



extension PhotosAlbumViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
}


extension PhotosAlbumViewController : FusumaDelegate {
    func fusumaImageSelected(_ image: UIImage) {
        self.delegate?.albumImageSelected(image)
    }
    func fusumaDismissedWithImage(_ image: UIImage) {
        self.delegate?.albumImageDismissedWithImage!(image)
    }
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        self.delegate?.albumImageVideoCompleted(withFileURL: fileURL)
    }
    func fusumaCameraRollUnauthorized() {
        self.delegate?.albumImageCameraRollUnauthorized()
    }
    
    func fusumaClosed() {
        self.delegate?.albumImageClosed!()
    }
}
