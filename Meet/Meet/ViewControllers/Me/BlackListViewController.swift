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
        self.talKingDataPageName = "Me-BlackList"
        // Do any additional setup after loading the view.
    }
    
    func setUpCollectionView(){
        let followLayout = UICollectionViewFlowLayout()
        followLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: followLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.init(colorLiteralRed: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        collectionView.register(UINib.init(nibName: "BlackListCollectCell", bundle:nil), forCellWithReuseIdentifier: "BlackListCollectCell")
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.top.equalTo(self.view.snp.top).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }

    func setUpBlackListData() {
        self.blackList.removeAllObjects()
        viewModel.getBlackList({ (dic) in
            self.blackList = BlackListModel.mj_objectArray(withKeyValuesArray: dic?["black_list"])
            self.collectionView.reloadData()
            }) { (dic) in
            MainThreadAlertShow(dic?["error"] as! String, view: self.view)
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
    
    func reportBtnPress(_ sender:UIButton){
        viewModel.deleteBlackList("\(sender.tag)", success: { (dic) in
            self.setUpBlackListData()
            }) { (dic) in
                
        }
    }

}

extension BlackListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

extension BlackListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blackList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdef = "BlackListCollectCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdef, for: indexPath) as! BlackListCollectCell
        cell.reportBtn.addTarget(self, action: #selector(BlackListViewController.reportBtnPress(_:)), for: .touchUpInside)
        cell.layer.cornerRadius = 5.0
        cell.setData(blackList[(indexPath as NSIndexPath).row] as! BlackListModel)
        cell.backgroundColor = UIColor.white
        return cell
    }
}

extension BlackListViewController: UICollectionViewDelegateFlowLayout {
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


