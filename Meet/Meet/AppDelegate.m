//
//  AppDelegate.m
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "WXApi.h"
#import "TalkingData.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "MBProgressHUD.h"
#import "AFNetWorking.h"
#import "NetWorkObject.h"
#import "WeiboSDK.h"
#import "WeiboModel.h"

#import "FristHomeViewController.h"
#import "UserInfo.h"
#import "WXAccessModel.h"
#import "WXUserInfo.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "ThemeTools.h"
#import "IQKeyboardManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Meet-Swift.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<WXApiDelegate,NSURLConnectionDelegate,WeiboSDKDelegate> {
    NSURLConnection *_connection;
    NSURLConnection *_connectionLoadUserInfo;
    
    MBProgressHUD *loadingHUD;
    
    SplashView *_splashView;
}



@end

@implementation AppDelegate

/////nothing just test
///what 's app
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ThemeTools appTheme:AppThemeColorCustom];
    [Fabric with:@[[Crashlytics class]]];////////
    [self logUser];
    [WXApi registerApp:@"wx49c4b6f590f83469"];

    [self setUpUMeng];
    
    if ([UserInfo sharedInstance].wechat_union_id == nil) {
        [UserInfo logout];
    }
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [self setIQkeyboardManager];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FristHomeViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"FristHomeViewController"];
    self.window.rootViewController = [[ScrollingNavigationController alloc] initWithRootViewController:controller];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"

    
    [self.window makeKeyAndVisible];
    [self addSplashView];

    return YES;
}

- (void)setUpUMeng
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WeiboApiKey];
}

- (void)addSplashView
{
    _splashView = [[SplashView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [_splashView startAnimation];
    [self.window addSubview:_splashView];

    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeSplashView) userInfo:nil repeats:NO];

}

- (void)removeSplashView
{
    [_splashView removeSplashView];
}

- (void) logUser {

    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"user@fabric.io"];
    [CrashlyticsKit setUserName:@"Test User"];
}

- (void)setIQkeyboardManager
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].toolbarTintColor = [UIColor colorWithHexString:IQKeyboardManagerTinColor];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = NO;
    [IQKeyboardManager sharedManager].placeholderFont = IQKeyboardManagerFont;
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else if ([url.host isEqualToString:@"response"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    if([url.host isEqualToString:@"response"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic========%@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPayStatues object:nil];
            }
        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

-(MainViewController *)getRootViewController {
    MainViewController *rootVC = (MainViewController *) self.window.rootViewController;
    return rootVC;
}

#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        [WeiboModel shareInstance].usid = [NSString stringWithFormat:@"weibo_%@",[(WBAuthorizeResponse *)response userID]];
        [WeiboModel shareInstance].userName = response.userInfo[@"userName"];
        [WeiboModel shareInstance].unionId = response.userInfo[@"unionId"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginWihtWeibo" object:[NSNumber numberWithInt:0]];
    }
}


#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req {
    
}

-(void) onResp:(BaseResp*)resp {
    if (resp.errCode != 0) {////确认
        return ;
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {////登陆
        SendAuthResp *response = (SendAuthResp *)resp;
        if ([response.state isEqualToString:[AppData shareInstance].wxRandomState]) {
        NSString *code = response.code;
        NSDictionary *parameters = @{@"appid":[AppData shareInstance].wxAppID,@"secret":[AppData shareInstance].wxAppSecret,@"grant_type":@"authorization_code",@"code":code};
            [NetWorkObject GET:WX_access_tokenURL_str
                parameters:parameters
                  progress:^(NSProgress *downloadProgress) {
            }
                   success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                       WXAccessModel *model = [[WXAccessModel shareInstance] initWithDictionary:responseObject];
                       model.saveDate = [AppData curretnDate];
                       ////save
                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                       [dic setObject:model.saveDate forKey:@"saveDate"];
                       [[NSUserDefaults standardUserDefaults] setObject:dic forKey:keyAccessModelSave];
                       [self wechatLoginByRequestForUserInfo];
                       [loadingHUD hide:YES];
            }
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                       [loadingHUD hide:YES];
                      
                NSLog(@"AF error :%@",error.localizedFailureReason);
            }];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:WeiXinPayStatues object:nil];
                break;
                
            default:
            {
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            }
                break;
        }
    }
}

/////tock 未超时时直接使用本地tock
- (void)wechatLoginByRequestForUserInfo {
    [NetWorkObject GET:GETUser_info_FromWX_URLStr parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *WXuserInfo) {
        
        [[WXUserInfo shareInstance] initWithDictionary:WXuserInfo];
        [WXUserInfo initWithDic:WXuserInfo];
//        [[UITools shareInstance] showMessageToView:self.window message:@"登录成功" autoHide:YES];
         NSLog(@"请求微信用户信息成功！");
        [[NSUserDefaults standardUserDefaults] setObject:WXuserInfo forKey:keyWXUserInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewUserLoginWihtWechat" object:[NSNumber numberWithInt:1]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OldUserLoginWihtWechat" object:[NSNumber numberWithInt:1]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//         [[UITools shareInstance] showMessageToView:self.window message:@"登录失败" autoHide:YES];
         NSLog(@"请求微信用户信息失败！");
         NSLog(@"error :%@",error.localizedFailureReason);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewUserLoginWihtWechat" object:[NSNumber numberWithInt:0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OldUserLoginWihtWechat" object:[NSNumber numberWithInt:0]];
    }];
}

//// 刷新 tock
- (void)weChatRefreshAccess_Token {
    [NetWorkObject GET:WXRefresh_access_tokenURL_str([WXAccessModel shareInstance].refresh_token) parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        WXAccessModel *model = [[WXAccessModel shareInstance] initWithDictionary:responseObject];
        model.saveDate = [AppData curretnDate];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        [dic setObject:model.saveDate forKey:@"saveDate"];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:keyAccessModelSave];
        NSLog(@"刷新Token成功！");
        [self wechatLoginByRequestForUserInfo];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"刷新Token失败！");
        NSLog(@"error :%@",error.localizedFailureReason);
    }];
}


@end
