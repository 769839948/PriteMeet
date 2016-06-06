//
//  WXLoginViewController.m
//  Meet
//
//  Created by jiahui on 16/5/21.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WXLoginViewController.h"

#import "MyProfileViewController.h"
#import "BaseUserInfoViewController.h"
#import "WXApi.h"

#import "WXApiObject.h"
#import "UserInfoDao.h"
#import "UserInfo.h"
#import "LoginViewModel.h"

@interface WXLoginViewController ()

@property (assign, nonatomic) BOOL isNewUser;
@property (retain, nonatomic) LoginViewModel *viewModel;

@end

@implementation WXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(cancelAction:) normalTitle:@"取消" selectedTitle:nil];
    _viewModel = [[LoginViewModel alloc] init];
    _isNewUser = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)loginButtonAction:(id)sender {
    if (_isNewUser) {
        [self sendAuthRequest];
        //////判断是否真实存在用户
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginState:) name:@"NewUserLoginWihtWechat" object:nil];
        //        loading View start
    }
}

#pragma mark - notification
- (void)loginState:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewUserLoginWihtWechat" object:nil];
    NSNumber *state = [notification object];
    if (state.intValue) {
        __weak typeof(self) weakSelf = self;
        [_viewModel postWXUserInfo:[WXUserInfo shareInstance] withCode:self.code Success:^(NSDictionary *object) {
            [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:YES];
            [[UserInfo shareInstance] mappingValuesFormWXUserInfo:[WXUserInfo shareInstance]];
            [AppData shareInstance].isLogin = YES;
            [[UserInfoDao shareInstance] insertBean:[UserInfo shareInstance]];
            [[UserInfoDao shareInstance] selectUserInfoWithUserId:[WXUserInfo shareInstance].unionid];/////获取到 [UserInfo shareInstance]的idKye 以后保存需要
            UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
            BaseUserInfoViewController *baseUserInfo = [meStoryBoard instantiateViewControllerWithIdentifier:@"BaseInfoViewController"];
//            myProfileVC.isFristLogin = YES;
            [weakSelf.navigationController pushViewController:baseUserInfo animated:YES];
        } Fail:^(NSDictionary *object) {
            [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:YES];
            if ([[object objectForKey:@"error"] isEqualToString:@"oldUser"]) {
                [[UserInfo shareInstance] mappingValuesFormWXUserInfo:[WXUserInfo shareInstance]];
                [AppData shareInstance].isLogin = YES;
                [[UserInfoDao shareInstance] insertBean:[UserInfo shareInstance]];
                [[UserInfoDao shareInstance] selectUserInfoWithUserId:[WXUserInfo shareInstance].unionid];/////获取到 [UserInfo shareInstance]的idKye 以后保存需要
                UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
                BaseUserInfoViewController *baseUserInfo = [meStoryBoard instantiateViewControllerWithIdentifier:@"BaseInfoViewController"];
                //            myProfileVC.isFristLogin = YES;
                [weakSelf.navigationController pushViewController:baseUserInfo animated:YES];
                //这里是在调试中
//                MyProfileViewController *myProfileVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
//                myProfileVC.isFristLogin = YES;
//                [weakSelf.navigationController pushViewController:myProfileVC animated:YES];
            }
        } showLoding:^(NSString *str) {
            [self performSelectorOnMainThread:@selector(showHudInView:hint:) withObject:weakSelf.view withObject:str waitUntilDone:YES];
        }];
        
    }
}

#pragma mark - sender to WeChat
-(void)sendAuthRequest {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = [AppData random_uuid];
    [AppData shareInstance].wxRandomState = req.state;
    //第三方向微信终端发送一个SendAuthReq消息结构
    if (![WXApi sendReq:req]) {
        [[UITools shareInstance] showMessageToView:self.view message:@"请安装WeChart" autoHide:YES];
        NSLog(@"未安装WeChart");
    };
}

- (void)dealloc {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
