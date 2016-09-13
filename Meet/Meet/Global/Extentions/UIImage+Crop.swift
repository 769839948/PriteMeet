//
//  UIImage+Crop.swift
//  Meet
//
//  Created by Zhang on 9/13/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

