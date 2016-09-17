//
//  LikeManViewController.swift
//  Meet
//
//  Created by Zhang on 8/25/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import MJRefresh

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
        self.view.backgroundColor = UIColor.white
        self.setUpCollectionView()
        self.setUpLikeListData()
        self.talKingDataPageName = "Me-LikeList"
        self.setUpRefreshView()
    }

    func setUpCollectionView(){
        let followLayout = UICollectionViewFlowLayout()
        followLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: followLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.init(colorLiteralRed: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        collectionView.register(UINib.init(nibName: "LikeListCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "LikeListCollectionViewCell")
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.top.equalTo(self.view.snp.top).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }
    
    func setUpRefreshView() {
        self.collectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(LikeManViewController.setUpLikeListData))
    }
    
    func setUpLikeListData() {        
        if !self.hasNext {
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        page = page + 1
        if  page == 1 {
            self.likeList.removeAllObjects()
        }
        
        viewModel.getLikeList("\(page)", successBlock: { (dic) in
            self.hasNext = dic?["has_next"] as! Bool
            self.likeList.addObjects(from: LikeListModel.mj_objectArray(withKeyValuesArray: dic?["liked_list"]) as NSMutableArray as [AnyObject])
            self.collectionView.reloadData()
            self.collectionView.mj_footer.endRefreshing()
            }, fail: { (dic) in
                MainThreadAlertShow(dic?["error"] as! String, view: self.view)
                self.page = self.page - 1
                self.collectionView.mj_footer.endRefreshing()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func reportBtnPress(_ sender:UIButton){
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meetDetailVC = MeetDetailViewController()
        let model = likeList[(indexPath as NSIndexPath).row] as! LikeListModel
        meetDetailVC.user_id = "\(model.uid)"
        self.navigationController?.pushViewController(meetDetailVC, animated: true)

    }
}

extension LikeManViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdef = "LikeListCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdef, for: indexPath) as! LikeListCollectionViewCell
        cell.reportBtn.addTarget(self, action: #selector(LikeManViewController.reportBtnPress(_:)), for: .touchUpInside)
        cell.layer.cornerRadius = 5.0
        cell.setData(likeList[(indexPath as NSIndexPath).row] as! LikeListModel)
        cell.backgroundColor = UIColor.white
        return cell
    }
}

extension LikeManViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 27)/2, height: 223)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    //返回HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: 0, height: 0)
    }
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}


