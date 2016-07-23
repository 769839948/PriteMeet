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
//#import "UMSocialSnsPlatformManager.h"
//#import "UMSocialAccountManager.h"
#import "WeiboModel.h"
#import "WeiboSDK.h"
#import "PSWView.h"
#import "UIViewController+DismissKeyboard.h"
#import "ApplyCodeViewController.h"
#import "IQKeyboardManager.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>

@interface WeChatResgisterViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,DelegatePSW>

@property(nonatomic,strong)PSWView *checkLabel;


@property (nonatomic, copy) NSString *checkCode;

@property (weak, nonatomic) IBOutlet UIView *checkCodeView;

@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
@property (nonatomic, strong) LoginViewModel *viewModel;

@end

@implementation WeChatResgisterViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[LoginViewModel alloc] init];
    _nextStep.enabled = NO;
    _checkCode = @"";
    [IQKeyboardManager sharedManager].enable = NO;
    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self addLineNavigationBottom];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithHexString:HomeDetailViewNameColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:HomeDetailViewNameColor]];
    [self setUpCheckLabel];
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationItemCleanColorWithNotLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpCheckLabel
{
    /**
     * label样式
     */
    self.checkLabel = [[PSWView alloc]initWithFrame:CGRectMake(0, 0, _checkCodeView.frame.size.width, _checkCodeView.frame.size.height) labelNum:4 showPSW:YES];
    [_checkCodeView addSubview:self.checkLabel];
    __weak typeof(self) weakSelf = self;
    self.checkLabel.block = ^(NSInteger tag){
        NSLog(@"%ld",(long)tag);
        if (tag == 3) {
            [weakSelf performSegueWithIdentifier:@"pushToWXLogin" sender:weakSelf];
        }
//        switch (tag) {
//                if (tag == 3) {
//                    [weakSelf performSegueWithIdentifier:@"pushToWXLogin" sender:weakSelf];
//                }
//                /**
//                 *  新浪微博，微信登陆暂时去除
//                 */
////            case 1:
////                [weakSelf loginWeibo];
////                break;
////                
////            default:
////                [weakSelf useWeChatLogin];
////                break;
//        }
    };
    [self.checkLabel labelTouch:nil];
    self.checkLabel.delegate = self;
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    if (ScreenHeight < 667){
        [self.view endEditing:YES];
    }
}


- (void)loginWeibo
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UerLoginStateWeibo:) name:@"UserLoginWihtWeibo" object:nil];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WeiboRedirectUrl;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)loginWithOldUser:(NSString *)uid
{
    __weak typeof(self) weakSelf = self;
    [_viewModel oldUserLogin:uid Success:^(NSDictionary *object) {
        
        [_viewModel getUserInfo:uid success:^(NSDictionary *object) {
            //获取到 [UserInfo shareInstance]的idKye 以后保存需要
            [UserInfo sharedInstance].uid = uid;
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
}

- (IBAction)checkCodeButtonAction:(id)sender {
    #warning check code and into WeChat Longin
//    [self performSegueWithIdentifier:@"pushToWXLogin" sender:self];
    if ([self isEmpty]) {
        [EMAlertView showAlertWithTitle:nil message:@"请输入邀请码" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
    }else{
        __weak typeof(self) weakSelf = self;
        [_viewModel checkCode:_checkCode Success:^(NSDictionary *object) {
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
        wxLoginView.code = _checkCode;
    }
    
    if ([segue.identifier isEqualToString:@"pushApplyController"]) {
        ApplyCodeViewController *applyCode = segue.destinationViewController; //获取目的试图控制器对象，跟原来一样，在.m文件中要引入头文件
        __weak typeof(self) weakSelf = self;
        applyCode.block = ^(){
            [[UITools shareInstance] showMessageToView:weakSelf.view message:@"申请成功，请耐心等待审核结果^_^" autoHide:YES];
        };
    }
}

- (void)UerLoginStateWeibo:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLoginWihtWeibo" object:nil];
    NSNumber *state = [notification object];
    if (state && [WeiboModel shareInstance].usid != nil) {
        [self loginWithOldUser:[WeiboModel shareInstance].usid];
    } else {
        [[UITools shareInstance] showMessageToView:self.view message:@"请求出错" autoHide:YES];
    }

}

- (void)useWeChatLogin {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oldUerLoginState:) name:@"OldUserLoginWihtWechat" object:nil];
    [self sendAuthRequest];
}

-(void)pwdNum:(NSString *)pwdNum{
    _checkCode = pwdNum;
    if (pwdNum.length == 4) {
        _nextStep.enabled = YES;
        _nextStep.backgroundColor = [UIColor colorWithHexString:ApplyCodeNextBtnColorEn];
    }else{
        _nextStep.enabled = NO;
        _nextStep.backgroundColor = [UIColor colorWithHexString:ApplyCodeNextBtnColorDis];

    }
}

#pragma mark - NSNotificationCenter
- (void)oldUerLoginState:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OldUserLoginWihtWechat" object:nil];
     NSNumber *state = [notification object];
    if (state && [WXUserInfo shareInstance].openid != nil) {
        [self loginWithOldUser:[WXUserInfo shareInstance].openid];
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
        [[UITools shareInstance] showMessageToView:self.view message:@"请安装WeChat" autoHide:YES];
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
    if (_checkCode.length == 0) {
    
        ret = YES;
    }
    return ret;
}

@end
