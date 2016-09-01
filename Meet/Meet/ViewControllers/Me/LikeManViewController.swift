//
//  LikeManViewController.swift
//  Meet
//
//  Created by Zhang on 8/25/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class LikeManViewController: UIViewController {

    var collectionView:UICollectionView!
    
    let viewModel = UserInfoViewModel()
    
    var likeList =  NSMutableArray()
    
    var hasNext:Bool = true
    
    var page:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItemBack()
        self.title = "想见的人"
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpCollectionView()
        self.setUpLikeListData()
        self.talKingDataPageName = "Me-LikeList"
    }

    func setUpCollectionView(){
        let followLayout = UICollectionViewFlowLayout()
        followLayout.scrollDirection = .Vertical
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: followLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.init(colorLiteralRed: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        collectionView.registerNib(UINib.init(nibName: "LikeListCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "LikeListCollectionViewCell")
        self.view.addSubview(collectionView)
        
        collectionView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.top.equalTo(self.view.snp_top).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }
    
    func setUpLikeListData() {
        self.likeList.removeAllObjects()
        page = page + 1
        viewModel.getLikeList("\(page)", successBlock: { (dic) in
            self.hasNext = dic["has_next"] as! Bool
            self.likeList = LikeListModel.mj_objectArrayWithKeyValuesArray(dic["liked_list"])
            self.collectionView.reloadData()
            }, fail: { (dic) in
                MainThreadAlertShow(dic["error"] as! String, view: self.view)
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func reportBtnPress(sender:UIButton){
        viewModel.deleteLikeUser("\(sender.tag)", successBlock: { (dic) in
            self.setUpLikeListData()
            }) { (dic) in
                
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LikeManViewController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let meetDetailVC = MeetDetailViewController()
        let model = likeList[indexPath.row] as! LikeListModel
        meetDetailVC.user_id = "\(model.uid)"
        self.navigationController?.pushViewController(meetDetailVC, animated: true)

    }
}

extension LikeManViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdef = "LikeListCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdef, forIndexPath: indexPath) as! LikeListCollectionViewCell
        cell.reportBtn.addTarget(self, action: #selector(LikeManViewController.reportBtnPress(_:)), forControlEvents: .TouchUpInside)
        cell.layer.cornerRadius = 5.0
        cell.setData(likeList[indexPath.row] as! LikeListModel)
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
}

extension LikeManViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.size.width - 27)/2, 223)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7
    }
    
    //返回HeadView的宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: 0, height: 0)
    }
    //返回cell 上下左右的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}


