//
//  LoginViewModel.m
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

/**
 *  {
 city = Shenzhen;
 country = CN;
 "head_img_url" = "http://wx.qlogo.cn/mmopen/xzvVYaqtSnwnVeFUgm1Mjel3sP3IXh5LOowcso0IxHSibuvXRnyB58WnzBekib5RdicGDKFZ5BeTn3pp4xPwHva5CicQVulWJBQ5/0";
 nickname = DIY;
 openid = o4pNpvxA5YQDVsgjmiQ07ChzMtms;
 privilege =     (
 );
 province = Guangdong;
 sex = 1;
 "union_id" = ozdkNv4HCFLglpMmuwNCOMz4nNmY;
 }
 *
 *  @return
 */

#import "LoginViewModel.h"
#import "AFNetWorking.h"

@implementation LoginViewModel

- (void)postWXUserInfo:(WXUserInfo *)WXUserInfo withCode:(NSString *)code Success:(Success)successBlock Fail:(Fail)failBlock showLoding:(LoadingView)loading
{
    loading(@"资料上传中");
    NSDictionary *parameters = @{@"openid":WXUserInfo.openid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestCheckUser];

    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![[responseObject objectForKey:@"success"] boolValue]) {
            NSDictionary *parameters = @{@"openid":WXUserInfo.openid,@"nickname":WXUserInfo.nickname,@"sex":WXUserInfo.sex,@"head_img_url":WXUserInfo.headimgurl,@"union_id":WXUserInfo.unionid,@"province":WXUserInfo.province,@"city":WXUserInfo.city,@"country":WXUserInfo.country,@"code":@"Z3pavMk"};
            [self.manager POST:RequestCreateUser parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([[responseObject objectForKey:@"success"] boolValue]) {
                    successBlock(responseObject);
                }else{
                    failBlock(@{@"error":@"上传失败"});
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                failBlock(@{@"error":@"网络错误"});
            }];
        }else{
            failBlock(@{@"error":@"oldUser"});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failBlock(@{@"error":@"网络错误"});
    }];
    
}

- (void)checkCode:(NSString *)code
          Success:(Success)successBlock
             Fail:(Fail)failBlock
       showLoding:(LoadingView)loading
{
    loading(@"邀请码检测");
    NSDictionary *parameters = @{@"code":code};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestCheckInvitationCode];
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"fail"});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":error});
    }];
}

- (void)oldUserLogin:(WXUserInfo *)WXUserInfo
             Success:(Success)successBlock
                Fail:(Fail)failBlock
          showLoding:(LoadingView)loading
{
    loading(@"登录中");
    NSDictionary *parameters = @{@"openid":WXUserInfo.openid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestCheckUser];

    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject objectForKey:@"success"]);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject);
        }else{
            failBlock(@{@"state":@"fail"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":error});
    }];
}

- (void)getUserInfo:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading
{
    loading(@"获取个人信息中");
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestGetUserInfo,openId];
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"获取信息失败"});
    }];
}

@end
