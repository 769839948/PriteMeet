//
//  MainViewController.m
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MainViewController.h"
#import "ThemeTools.h"

@interface MainViewController ()

@end
//NSLocalizedString
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ThemeTools tabBarTintColor:[UIColor blackColor] titleColor:[UIColor lightGrayColor] selectTitleColor:[UIColor blackColor]];
    // Do any additional setup after loading the view.
//    self.tabBar.barTintColor = [UIColor whiteColor];
//    self.tabBar.tintColor = TabBarTitleColor;
//    [self setNeedsStatusBarAppearanceUpdate];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
