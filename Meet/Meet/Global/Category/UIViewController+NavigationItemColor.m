//
//  UIViewController+NavigationItemColor.m
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UIViewController+NavigationItemColor.h"

@implementation UIViewController (NavigationItemColor)

- (void)navigaitonItemColor:(UIColor *)itemColor
{
    [self.navigationItem.leftBarButtonItem setTintColor:itemColor];
    [self.navigationItem.rightBarButtonItem setTintColor:itemColor];
}

@end
