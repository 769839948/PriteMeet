//
//  ThemeTools.m
//  Meet
//
//  Created by Zhang on 5/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "ThemeTools.h"

@implementation ThemeTools

static ThemeTools *themetools = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        themetools = [ThemeTools new];
    });
    return themetools;
}


+ (void)appTheme:(AppThemeColor)theme {
    switch (theme) {
        case AppThemeColorCustom:
            [ThemeTools tabBarTintColor:[UIColor blackColor] titleColor:[UIColor lightGrayColor] selectTitleColor:[UIColor blackColor]];
            break;
        case AppThemeColorBlue:
            break;
        case AppThemeColorRed:
            break;
        default:
            break;
    }
}

+ (void)tabBarTintColor:(UIColor *)barTintColor titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectColor {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor} forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor:barTintColor];
     
}

+ (void)navigationBarTintColor:(UIColor *)navigationBarColor titleColor:(UIColor*)titleColor{
    [[UINavigationBar appearance] setBarTintColor:navigationBarColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];
}

@end
