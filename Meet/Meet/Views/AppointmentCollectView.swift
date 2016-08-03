//
//  AppointmentCollectView.swift
//  Meet
//
//  Created by Zhang on 8/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class AppointmentCollectView: InterestCollectView {

    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = self.dequeueReusableCellWithReuseIdentifier(reuseIdentifierAppointMent, forIndexPath: indexPath) as! AppointmentCell
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 2.0
        cell.backgroundColor = UIColor.init(hexString: AppointMentBackGroundColor)
        cell.titleLable.frame = CGRectMake(0, 0, self.cellWidth(self.interstArray[indexPath.row] as! String), 26)
        cell.fillCellWidthFeed(self.interstArray[indexPath.row] as! String)
        return cell
    }
    
    override func cellWidth(itemString: String!) -> CGFloat {
        var cellWidth:CGFloat = 0
        cellWidth = itemString.stringWidth(itemString, font: OrderAppointThemeTypeFont!, height: 8)
        return cellWidth + 26;
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(cellWidth((self.interstArray as NSArray).objectAtIndex(indexPath.row) as! String), 26)

    }
    
    //定义每个UICollectionView 的大小
}
