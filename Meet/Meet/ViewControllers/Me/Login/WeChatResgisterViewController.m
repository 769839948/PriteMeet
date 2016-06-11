//
//  WeChatResgisterViewController.m
//  Meet
//
//  Created by jiahui on 16/5/6.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WeChatResgisterViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXAccessModel.h"
#import "WXUserInfo.h"
#import "LoginViewModel.h"
#import "WXLoginViewController.h"

//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>

@interface WeChatResgisterViewController ()<UIGestureRecognizerDelegate>
{
    __weak IBOutlet UITextField *checkField;
}

@property (nonatomic, strong) LoginViewModel *viewModel;

@end

@implementation WeChatResgisterViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[LoginViewModel alloc] init];
    checkField.text = @"lJeNj60";
    // Do any additional setup after loading the view.
    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
//    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)checkCodeButtonAction:(id)sender {
    #warning check code and into WeChat Longin
//    [self performSegueWithIdentifier:@"pushToWXLogin" sender:self];
    if ([self isEmpty]) {
        [EMAlertView showAlertWithTitle:nil message:@"请输入邀请码" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
    }else{
        __weak typeof(self) weakSelf = self;
        [_viewModel checkCode:checkField.text Success:^(NSDictionary *object) {
            [weakSelf performSegueWithIdentifier:@"pushToWXLogin" sender:self];
        } Fail:^(NSDictionary *object) {
            NSDictionary *msgDic = [object objectForKey:@"msg"];
            [EMAlertView showAlertWithTitle:[msgDic objectForKey:@"title"] message:[msgDic objectForKey:@"content"] completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                
            } cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
        } showLoding:^(NSString *str) {
        }];
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToWXLogin"]) {
        WXLoginViewController *wxLoginView = segue.destinationViewController; //获取目的试图控制器对象，跟原来一样，在.m文件中要引入头文件
        wxLoginView.code = checkField.text;
    }
}

- (IBAction)useWeChatLogin:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oldUerLoginState:) name:@"OldUserLoginWihtWechat" object:nil];
//    if (![WXAccessModel shareInstance].isLostAccess_token) {
//        [SHARE_APPDELEGATE wechatLoginByRequestForUserInfo];
//        return ;
//    }
//    if (![WXAccessModel shareInstance].isLostRefresh_token) {
//        [SHARE_APPDELEGATE weChatRefreshAccess_Token];
//        return ;
//    }
        [self sendAuthRequest];
}

#pragma mark - NSNotificationCenter
- (void)oldUerLoginState:(NSNotification *)notification {
    ////可按提示添加内容
//    return ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OldUserLoginWihtWechat" object:nil];
     NSNumber *state = [notification object];
    if (state) {
        __weak typeof(self) weakSelf = self;
        [_viewModel oldUserLogin:[WXUserInfo shareInstance] Success:^(NSDictionary *object) {
            
            [_viewModel getUserInfo:[WXUserInfo shareInstance].openid success:^(NSDictionary *object) {
                /////获取到 [UserInfo shareInstance]的idKye 以后保存需要
                [UserInfo synchronizeWithDic:object];
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [AppData shareInstance].isLogin = YES;
                    
                }];
            } fail:^(NSDictionary *object) {
            } loadingString:^(NSString *str) {
                
            }];
            /////重新获取到 [UserInfo shareInstance]主要是为了得到idKye
            
        } Fail:^(NSDictionary *object) {
//            [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:YES];
            [EMAlertView showAlertWithTitle:@"账号不存在" message:@"Meet暂未开放注册，请获得邀请码后再重新登录" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                
            } cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
        } showLoding:^(NSString *str) {

        }];
//        NSString *unionid = [WXUserInfo shareInstance].unionid;
//        ////判断是不是真的是老用户，此微信号是否真的注册过！！
//        if (unionid) {/////是老用户，退出登陆页面 isLogin YES
//#warning  是老用户 从网获取用户信息 并保存本地 退出登陆页面
//            
//            
        
    } else {
        [[UITools shareInstance] showMessageToView:self.view message:@"请求出错" autoHide:YES];
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.class isSubclassOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        //         NSLog(@"Home interactivePopGestureRecognizer");
        return YES;
    }
    return YES;
}

- (void)dealloc {
    
}

- (BOOL)isEmpty
{
    
    BOOL ret = NO;
    if (checkField.text.length == 0) {
    
        ret = YES;
    }
    return ret;
}

@end
