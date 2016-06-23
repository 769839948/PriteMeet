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

@interface BaseUserInfoViewController ()


@end

@implementation BaseUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
}

- (void)nextStep:(UIBarButtonItem *)sender
{
//    if (self.selectRow == 2 && !self.chooseView.hidden) {////Sex Item alert
//        [self sexItemModify];
//        return ;
//    }
    __weak typeof(self) weakSelf = self;
    [self mappingUserInfoWithDicValues];
    
    UserInfo *uer = [UserInfo sharedInstance];
    if ([self chectBaseInfo]) {
        [self.viewModel updateUserInfo:[UserInfo sharedInstance] withStateArray:[self.stateArray copy] success:^(NSDictionary *object) {
            [[UITools shareInstance] showMessageToView:self.view message:@"保存成功" autoHide:YES];
            UIImage *image = self.dicValues[self.titleContentArray[0]];
            if ([UserInfo saveCacheImage:image withName:@"headImage.jpg"]) {
                NSLog(@"保存成功");
            }
            UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
            SetInvitationViewController *invitationView = [meStoryBoard instantiateViewControllerWithIdentifier:@"SetInvitationViewController"];
            [weakSelf.navigationController pushViewController:invitationView animated:YES];
        } fail:^(NSDictionary *object) {
            [[UITools shareInstance] showMessageToView:self.view message:@"保存失败" autoHide:YES];
        } loadingString:^(NSString *str) {
        }];
    }
}

- (Boolean)chectBaseInfo
{
    BOOL ret = NO;
    NSLog(@"%@",[UserInfo sharedInstance].real_name);
    if ([[UserInfo sharedInstance].avatar isEqualToString:@""]) {
        [EMAlertView showAlertWithTitle:nil message:@"头像为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if([[UserInfo sharedInstance].real_name isEqualToString:@""]){
        [EMAlertView showAlertWithTitle:nil message:@"真实姓名为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if([[UserInfo sharedInstance].birthday isEqualToString:@""]){
        [EMAlertView showAlertWithTitle:nil message:@"生日为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if([[UserInfo sharedInstance].country isEqualToString:@"0,0"]){
        [EMAlertView showAlertWithTitle:nil message:@"工作生活城市为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if([[UserInfo sharedInstance].mobile_num isEqualToString:@""]){
        [EMAlertView showAlertWithTitle:nil message:@"手机号为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else{
        ret = YES;
    }
    return ret;
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
