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
#import "ThemeTools.h"
#import "UIImage+PureColor.h"

//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>

@interface WeChatResgisterViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITextField *checkField;
}

@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
@property (nonatomic, strong) LoginViewModel *viewModel;

@end

@implementation WeChatResgisterViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 0.5)]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[LoginViewModel alloc] init];
    _nextStep.enabled = NO;
    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self setUpTextField];
}

- (void)setUpTextField
{
    checkField.delegate = self;
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F6F6F6"] size:CGSizeMake(20, 56)]];
    checkField.leftView = leftImg;
    checkField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 0.5)]];

    //    [ThemeTools navigationBarTintColor:[UIColor blackColor] titleColor:[UIColor blackColor]];
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
    [self performSegueWithIdentifier:@"pushToWXLogin" sender:self];
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
        [self sendAuthRequest];
}

#pragma mark - NSNotificationCenter
- (void)oldUerLoginState:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OldUserLoginWihtWechat" object:nil];
     NSNumber *state = [notification object];
    if (state) {
        __weak typeof(self) weakSelf = self;
        [_viewModel oldUserLogin:[WXUserInfo shareInstance] Success:^(NSDictionary *object) {
            
            [_viewModel getUserInfo:[WXUserInfo shareInstance].openid success:^(NSDictionary *object) {
                /////获取到 [UserInfo shareInstance]的idKye 以后保存需要
                [UserInfo synchronizeWithDic:object];
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [UserInfo sharedInstance].isFirstLogin = YES;
                    if (weakSelf.reloadMeViewBlock) {
                        weakSelf.reloadMeViewBlock(YES);
                    }
                }];
            } fail:^(NSDictionary *object) {
            } loadingString:^(NSString *str) {
                
            }];
            
        } Fail:^(NSDictionary *object) {
            [EMAlertView showAlertWithTitle:@"账号不存在" message:@"Meet暂未开放注册，请获得邀请码后再重新登录" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                
            } cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
        } showLoding:^(NSString *str) {

        }];
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


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0 || (range.location == 0 && [string isEqualToString:@""])) {
        if (![string isEqualToString:@""]) {
            [_nextStep setBackgroundColor:[UIColor blackColor]];
            _nextStep.enabled = YES;
        }else{
            [_nextStep setBackgroundColor:[UIColor clearColor]];
            _nextStep.enabled = NO;
        }
    }else if (textField.text.length > 0 || string.length > 0) {
        [_nextStep setBackgroundColor:[UIColor blackColor]];
        _nextStep.enabled = YES;
    }
    return YES;
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
