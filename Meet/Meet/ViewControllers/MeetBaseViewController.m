//
//  MeetBaseViewController.m
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MeetBaseViewController.h"

@interface MeetBaseViewController ()

@end

@implementation MeetBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"202020"];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithHexString:@"202020"];
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;

}

- (void)leftItemClick:(UINavigationItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (![context isCancelled]) {
            [self popGestureRecognizerDidAction];
        }
    }];
}

- (void)popGestureRecognizerDidAction {
    NSLog(@"subClass do something");
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
