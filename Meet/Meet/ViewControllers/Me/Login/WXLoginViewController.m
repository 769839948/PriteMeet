//
//  WXLoginViewController.m
//  Meet
//
//  Created by jiahui on 16/5/21.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WXLoginViewController.h"
#import "AppData.h"
#import "MyProfileViewController.h"
#import "BaseUserInfoViewController.h"
#import "WXApi.h"
#import "UserProtocolViewController.h"
#import "WXApiObject.h"
#import "UserInfo.h"
#import "WeiboModel.h"
#import "LoginViewModel.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"

@interface WXLoginViewController ()

@property (assign, nonatomic) BOOL isNewUser;
@property (retain, nonatomic) LoginViewModel *viewModel;

@end

@implementation WXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[LoginViewModel alloc] init];
    _isNewUser = YES;
//    [self navigationItemCleanColorWithNotLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationItemCleanColorWithNotLine];
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)loginWeiboAction:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            [WeiboModel shareInstance].unionId = snsAccount.unionId;
            [WeiboModel shareInstance].userName = snsAccount.userName;
            [WeiboModel shareInstance].usid = snsAccount.usid;
            //            [WeiboModel shareInstance].accessToken = snsAccount.accessToken;
            [WeiboModel shareInstance].iconURL = snsAccount.iconURL;
            [weakSelf loginUser:snsAccount.usid withUssr:nil withWeiboInfo:[WeiboModel shareInstance]];
            
        }});
}


- (void)loginUser:(NSString *)uid withUssr:(WXUserInfo *)info withWeiboInfo:(WeiboModel *)weibo
{
    if (info == nil) {
        [WXUserInfo shareInstance].openid = weibo.usid;
        [WXUserInfo shareInstance].unionid = weibo.unionId;
        [WXUserInfo shareInstance].country = @"";
        [WXUserInfo shareInstance].headimgurl = weibo.iconURL;
        [WXUserInfo shareInstance].city = @"";
        [WXUserInfo shareInstance].nickname = weibo.userName;
        [WXUserInfo shareInstance].sex = @1;
        [WXUserInfo shareInstance].province = @"";
    }
    __weak typeof(self) weakSelf = self;
    [_viewModel postWXUserInfo:[WXUserInfo shareInstance] withCode:self.code Success:^(NSDictionary *object) {
        [_viewModel getUserInfo:uid success:^(NSDictionary *object) {
            /////获取到 [UserInfo shareInstance]的idKye 以后保存需要
            [UserInfo synchronizeWithDic:object];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNewUser"];
            UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
            BaseUserInfoViewController *baseUserInfo = [meStoryBoard instantiateViewControllerWithIdentifier:@"BaseInfoViewController"];
            [weakSelf.navigationController pushViewController:baseUserInfo animated:YES];
        } fail:^(NSDictionary *object) {
        } loadingString:^(NSString *str) {
            
        }];
        
    } Fail:^(NSDictionary *object) {
        if ([[object objectForKey:@"error"] isEqualToString:@"oldUser"]) {
            [_viewModel getUserInfo:[WXUserInfo shareInstance].openid success:^(NSDictionary *object) {
                [UserInfo synchronizeWithDic:object];
                [self dismissViewControllerAnimated:YES completion:^{
                    [UserInfo sharedInstance].isFirstLogin = YES;
                    
                }];
            } fail:^(NSDictionary *object) {
            } loadingString:^(NSString *str) {
                
            }];
            /////获取到 [UserInfo shareInstance]的idKye 以后保存需要
            //这里是在调试中
        }
    } showLoding:^(NSString *str) {
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

- (IBAction)userProtocol:(id)sender
{
    UIStoryboard *settingStory = [UIStoryboard storyboardWithName:@"Seting" bundle:nil];
    UserProtocolViewController *userProtocol = [settingStory instantiateViewControllerWithIdentifier:@"UserProtocolViewController"];
    [userProtocol setUpNavigationBar];
    [self.navigationController pushViewController:userProtocol animated:YES];
}

#pragma mark - notification
- (void)loginState:(NSNotification *)notification {
//    UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
//    BaseUserInfoViewController *baseUserInfo = [meStoryBoard instantiateViewControllerWithIdentifier:@"BaseInfoViewController"];
//    [self.navigationController pushViewController:baseUserInfo animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewUserLoginWihtWechat" object:nil];
    NSNumber *state = [notification object];
    if (state.intValue) {
        [self loginUser:[WXUserInfo shareInstance].openid withUssr:[WXUserInfo shareInstance] withWeiboInfo:nil];
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
