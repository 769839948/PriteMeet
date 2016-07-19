//
//  BaseUserInfoViewController.m
//  Meet
//
//  Created by Zhang on 6/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseUserInfoViewController.h"
#import "LabelAndTextFieldCell.h"
#import "UISheetView.h"
#import "UserInfoViewModel.h"
#import "WXUserInfo.h"
#import "Meet-Swift.h"
#import "UIImage+Alpha.h"
#import "NSString+StringType.h"

@interface BaseUserInfoViewController ()


@end

@implementation BaseUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNewUser"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"";
    self.isBaseView = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setUpView];
    [self setNavigationItemBar];

}

- (void)setNavigationItemBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"me_profile_save"] style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navigationbar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:HomeDetailViewNameColor]];
}


- (void)leftItemClick:(UIBarButtonItem *)sender
{
    [EMAlertView showAlertWithTitle:@"注意" message:@"资料未完善，确定退出编辑吗？" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

- (void)setUpView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_image1"]];
    imageView.frame = CGRectMake(-10, 170, 70, 110);
    [self.tableView addSubview:imageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIImage *alphaImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, 64)];
    [alphaImage imageByApplyingAlpha:0.5];
    [self.navigationController.navigationBar setBackgroundImage:alphaImage
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 0.5)]];
}

- (void)nextStep:(UIBarButtonItem *)sender
{
//    UIStoryboard  *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
//    SenderInviteViewController *senderInviteVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"SenderInviteViewController"];
//    senderInviteVC.isNewLogin = YES;
//    [self.navigationController pushViewController:senderInviteVC animated:YES];
    __weak typeof(self) weakSelf = self;
    [self mappingUserInfoWithDicValues];
    
    if ([self chectBaseInfo]) {
        [self.viewModel updateUserInfo:[UserInfo sharedInstance] withStateArray:[self.stateArray copy] success:^(NSDictionary *object) {
//            [[UITools shareInstance] showMessageToView:self.view message:@"保存成功" autoHide:YES];
            UIImage *image = self.dicValues[self.titleContentArray[0]];
            if ([UserInfo saveCacheImage:image withName:@"headImage.jpg"]) {
                NSLog(@"保存成功");
            }
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNewUser"];
            [EMAlertView showAlertWithTitle:@"设置您的邀约" message:@"邀约设置后，有助于他人了解您的约见说明，从而更精准的吸引志趣相投的朋友。" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                switch (buttonIndex) {
                    case 0:
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                        }];
                        break;
                    default:
                    {
                        UIStoryboard  *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
                        SenderInviteViewController *senderInviteVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"SenderInviteViewController"];
                        senderInviteVC.isNewLogin = YES;
                        [self.navigationController pushViewController:senderInviteVC animated:YES];
                    }
                        break;
                }
            } cancelButtonTitle:nil otherButtonTitles:@"逛逛再说",@"设置邀约",nil];

        } fail:^(NSDictionary *object) {
            [[UITools shareInstance] showMessageToView:self.view message:@"保存失败" autoHide:YES];
        } loadingString:^(NSString *str) {
        }];
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  0.000001;
    }else{
        return 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
