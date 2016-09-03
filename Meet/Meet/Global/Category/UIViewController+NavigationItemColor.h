//
//  UIViewController+NavigationItemColor.h
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationItemColor)

@property (nonatomic, strong) UILabel *navigationBarlineLabel;

@property (nonatomic, strong) UIView *navigationBarView;

- (void)navigaitonItemColor:(UIColor *)itemColor;

- (void)navigationItemWithLineAndWihteColor;

- (void)navigationItemCleanColorWithNotLine;

- (void)navigationItemWhiteColorAndNotLine;

- (void)createNavigationBar;

- (void)createCustomNavigationBar;

- (void)addLineNavigationBottom;

- (void)removeNavigatioinBar;

- (void)removeBottomLine;

@end
