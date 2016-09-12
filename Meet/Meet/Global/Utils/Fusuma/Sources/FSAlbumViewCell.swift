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
        self.selected = false
    }
    
    override var selected : Bool {
        didSet {
            selectImageView.image = selected ? UIImage.init(color: UIColor.init(white: 1, alpha: 0.700), size: CGSizeMake(self.bounds.size.width, self.bounds.size.height)) : UIImage.init(color: UIColor.clearColor(), size: CGSizeMake(self.bounds.size.width, self.bounds.size.height))
        }
    }
}
