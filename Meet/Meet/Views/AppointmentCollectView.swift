//
//  AppointmentCollectView.swift
//  Meet
//
//  Created by Zhang on 8/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class AppointmentCollectView: InterestCollectView {

    override func collectionView(_ collectionView: UICollectionView!, cellForItemAt indexPath: IndexPath!) -> UICollectionViewCell! {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifierAppointMent, for: indexPath) as! AppointmentCell
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 2.0
        cell.backgroundColor = UIColor.init(hexString: AppointMentBackGroundColor)
        cell.titleLable.frame = CGRect(x: 0, y: 0, width: self.cellWidth(self.interstArray[indexPath.row] as! String), height: 26)
        cell.fillCellWidthFeed(self.interstArray[indexPath.row] as! String)
        return cell
    }
    
    override func cellWidth(_ itemString: String!) -> CGFloat {
        var cellWidth:CGFloat = 0
        cellWidth = itemString.stringWidth(itemString, font: OrderAppointThemeTypeFont!, height: 8)
        return cellWidth + 26;
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth((self.interstArray as NSArray).object(at: (indexPath as NSIndexPath).row) as! String), height: 26)

    }
    
    //定义每个UICollectionView 的大小
}
