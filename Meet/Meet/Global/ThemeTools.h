//
//  ThemeTools.h
//  Meet
//
//  Created by Zhang on 5/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum _AppThemeColor{
    AppThemeColorCustom,
    AppThemeColorBlue,
    AppThemeColorRed,
} AppThemeColor;

@interface ThemeTools : NSObject



+ (instancetype)shareInstance;

+ (void)appTheme:(AppThemeColor)theme;

+ (void)tabBarTintColor:(UIColor *)barTintColor titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectColor;
+ (void)navigationBarTintColor:(UIColor *)navigationBarColor titleColor:(UIColor*)titleColor;

@end
