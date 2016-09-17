//
//  FSAlbumViewCell.swift
//  Fusuma
//
//  Created by Yuta Akizuki on 2015/11/14.
//  Copyright © 2015年 ytakzk. All rights reserved.
//

import UIKit
import Photos

final class FSAlbumViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageView:UIImageView!
    var image: UIImage? {
        
        didSet {
            self.imageView.image = image            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSelected = false
    }
    
    override var isSelected : Bool {
        didSet {
            selectImageView.image = isSelected ? UIImage.init(color: UIColor.init(white: 1, alpha: 0.700), size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height)) : UIImage.init(color: UIColor.clear, size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        }
    }
}
