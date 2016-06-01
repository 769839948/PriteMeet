//
//  NSString+StringSize.h
//  Kaoban
//
//  Created by Jane on 8/25/15.
//  Copyright (c) 2015 kaoban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (StringSize)

- (float) heightWithFont:(UIFont *) font maxSize:(CGSize) maxSize andLinebreakMode:(NSLineBreakMode) linebreakMode;


+ (CGFloat) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

+ (float) widthForString:(NSString *)value fontSize:(float)fontSize;

@end
