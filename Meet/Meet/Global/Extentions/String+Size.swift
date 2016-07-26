//
//  String+Size.swift
//  Meet
//
//  Created by Zhang on 6/16/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    //MARK:获得string内容高度
     var length: Int { return self.characters.count }
    
    func stringHeight(font:UIFont,width:CGFloat)->CGFloat{
                
        let size = CGSizeMake(width,CGFloat.max)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        
        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
        
    }//funcstringHeightWith
    
}//extension end

