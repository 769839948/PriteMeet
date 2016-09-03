//
//  UIViewController+NavigationItemColor.m
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UIViewController+NavigationItemColor.h"
#import <objc/runtime.h>

static const void *NavigationBarlineLabel = &NavigationBarlineLabel;
static const void *NavigationBarView = &NavigationBarView;

@implementation UIViewController (NavigationItemColor)
@dynamic navigationBarlineLabel,navigationBarView;

- (NSString *)navigationBarlineLabel {
    return objc_getAssociatedObject(self, NavigationBarlineLabel);
}

- (void)setNavigationBarlineLabel:(UILabel *)navigationBarlineLabel{
    objc_setAssociatedObject(self, NavigationBarlineLabel, navigationBarlineLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)navigaitonItemColor:(UIColor *)itemColor
{
    [self.navigationItem.leftBarButtonItem setTintColor:itemColor];
    [self.navigationItem.rightBarButtonItem setTintColor:itemColor];
}

- (NSString *)navigationBarView {
    return objc_getAssociatedObject(self, NavigationBarlineLabel);
}

- (void)setNavigationBarView:(UIView *)navigationBarView{
    objc_setAssociatedObject(self, NavigationBarlineLabel, navigationBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)navigationItemWithLineAndWihteColor
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 0.5)]];
    self.navigationBarlineLabel = [self.navigationController.navigationBar viewWithTag:10000000];
    self.navigationBarlineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
}



- (void)navigationItemCleanColorWithNotLine
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 64)]  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 0.5)]];
    self.navigationBarlineLabel = [self.navigationController.navigationBar viewWithTag:10000000];
    self.navigationBarlineLabel.backgroundColor = [UIColor clearColor];
}

- (void)navigationItemWhiteColorAndNotLine
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 0.5)]];
    self.navigationBarlineLabel = [self.navigationController.navigationBar viewWithTag:10000000];
    self.navigationBarlineLabel.backgroundColor = [UIColor clearColor];

}

- (void)addLineNavigationBottom
{
    if ([self.navigationController.navigationBar viewWithTag:10000000] == nil) {
        self.navigationBarlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.5, ScreenWidth, 0.5)];
        self.navigationBarlineLabel.tag = 10000000;
        self.navigationBarlineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
        [self.navigationController.navigationBar addSubview:self.navigationBarlineLabel];
    }else{
        self.navigationBarlineLabel = [self.navigationController.navigationBar viewWithTag:10000000];
        self.navigationBarlineLabel.hidden = NO;
        self.navigationBarlineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
    }
}

- (void)removeBottomLine
{
    self.navigationBarlineLabel = [self.navigationController.navigationBar viewWithTag:10000000];
    self.navigationBarlineLabel.hidden = YES;
    self.navigationBarlineLabel.backgroundColor = [UIColor redColor];
}

- (void)createNavigationBar
{
    if (self.navigationController.navigationBar.translucent){
        self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 63.5)];
        self.navigationBarView.backgroundColor = [UIColor whiteColor];
        self.navigationBarView.tag = 1000;
        [self.view addSubview:self.navigationBarView];
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:HomeDetailViewNameColor]];
    }
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)createCustomNavigationBar
{
    CGRect frame = self.navigationController.navigationBar.frame;
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, frame.size.width, frame.size.height + 21);
}

- (void)removeNavigatioinBar
{
    self.navigationBarView = [self.view viewWithTag:1000];
    [self.navigationBarView removeFromSuperview];
}

@end
