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
#import "WeiboSDK.h"
#import "WeiboModel.h"
#import "LoginViewModel.h"
#import "JKCountDownButton.h"

@interface WXLoginViewController ()

@property (assign, nonatomic) BOOL isNewUser;
@property (retain, nonatomic) LoginViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginBtn;

@end

@implementation WXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[LoginViewModel alloc] init];
    _isNewUser = YES;
    if (![WXApi isWXAppInstalled]) {
        _weChatLoginBtn.hidden = YES;
    }else{
        _weChatLoginBtn.hidden = NO;
    }
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

- (IBAction)getCode:(JKCountDownButton *)sender
{
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startCountDownWithSecond:60];
    
    [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
        return title;
    }];
    [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return @"点击重新获取";
        
    }];
}

- (IBAction)loginWithMobilePhone:(UIButton *)sender
{
    [self sendAuthRequest];
    //////判断是否真实存在用户
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginState:) name:@"NewUserLoginWihtWechat" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UerLoginStateWeibo:) name:@"UserLoginWihtWeibo" object:nil];
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = WeiboRedirectUrl;
//    request.scope = @"all";
//    [WeiboSDK sendRequest:request];
}

- (IBAction)loginWeiboAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UerLoginStateWeibo:) name:@"UserLoginWihtWeibo" object:nil];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WeiboRedirectUrl;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)UerLoginStateWeibo:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLoginWihtWeibo" object:nil];
    NSNumber *state = [notification object];
    if (state && [WeiboModel shareInstance].usid != nil) {
        [WeiboModel shareInstance].iconURL = @"";
        [WeiboModel shareInstance].userName = @"网页微博";
        [self loginUser:[WeiboModel shareInstance].usid withUssr:nil withWeiboInfo:[WeiboModel shareInstance]];
    } else {
        [[UITools shareInstance] showMessageToView:self.view message:@"请求出错" autoHide:YES];
    }
    
}

- (void)loginUser:(NSString *)uid withUssr:(WXUserInfo *)info withWeiboInfo:(WeiboModel *)weibo
{
    if (info == nil) {
        [WXUserInfo shareInstance].openid = weibo.usid;
        [WXUserInfo shareInstance].unionid = @"";
        [WXUserInfo shareInstance].country = @"";
        [WXUserInfo shareInstance].headimgurl = weibo.iconURL;
        [WXUserInfo shareInstance].city = @"";
        [WXUserInfo shareInstance].nickname = weibo.userName;
        [WXUserInfo shareInstance].sex = @1;
        [WXUserInfo shareInstance].province = @"";
    }
    [WXUserInfo shareInstance].openid = uid;
    __weak typeof(self) weakSelf = self;
    [_viewModel postWXUserInfo:[WXUserInfo shareInstance] withCode:self.code Success:^(NSDictionary *object) {
        [_viewModel getUserInfo:uid success:^(NSDictionary *object) {
            /////获取到 [UserInfo shareInstance]的idKye 以后保存需要
            [UserInfo sharedInstance].uid = uid;
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
            [_viewModel getUserInfo:uid success:^(NSDictionary *object) {
                [UserInfo sharedInstance].uid = uid;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewUserLoginWihtWechat" object:nil];
    NSNumber *state = [notification object];
    if (state.intValue && [WXUserInfo shareInstance].openid != nil) {
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
        [[UITools shareInstance] showMessageToView:self.view message:@"请安装WeChat" autoHide:YES];
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
