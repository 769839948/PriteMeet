//
//  UIView+DottedLineView.h
//  Meet
//
//  Created by Zhang on 8/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DottedLineView)

+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
