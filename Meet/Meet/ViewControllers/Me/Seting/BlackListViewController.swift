//
//  ReportListViewController.swift
//  Meet
//
//  Created by Zhang on 7/22/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class BlackListViewController: UIViewController {

    var collectionView:UICollectionView!
    
    let viewModel = UserInfoViewModel()
    
    var blackList =  NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        self.title = "黑名单"
        self.setUpBlackListData()
        self.setNavigationItemBack()
        self.createNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func setUpCollectionView(){
        let followLayout = UICollectionViewFlowLayout()
        followLayout.scrollDirection = .Vertical
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: followLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.init(colorLiteralRed: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        collectionView.registerNib(UINib.init(nibName: "BlackListCollectCell", bundle:nil), forCellWithReuseIdentifier: "BlackListCollectCell")
        self.view.addSubview(collectionView)
        
        collectionView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.top.equalTo(self.view.snp_top).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }

    func setUpBlackListData() {
        self.blackList.removeAllObjects()
        viewModel.getBlackList({ (dic) in
            self.blackList = BlackListModel.mj_objectArrayWithKeyValuesArray(dic)
            self.collectionView.reloadData()
            }) { (dic) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func reportBtnPress(sender:UIButton){
        viewModel.deleteBlackList("\(sender.tag)", success: { (dic) in
            self.setUpBlackListData()
            }) { (dic) in
                
        }
    }

}

extension BlackListViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }

}

extension BlackListViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blackList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdef = "BlackListCollectCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdef, forIndexPath: indexPath) as! BlackListCollectCell
        cell.reportBtn.addTarget(self, action: #selector(BlackListViewController.reportBtnPress(_:)), forControlEvents: .TouchUpInside)
        cell.layer.cornerRadius = 5.0
        cell.setData(blackList[indexPath.row] as! BlackListModel)
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
}

extension BlackListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.size.width - 27)/2, 223)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
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


