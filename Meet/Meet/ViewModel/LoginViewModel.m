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

- (void)postWXUserInfo:(WXUserInfo *)WXUserInfo Success:(Success)successBlock Fail:(Fail)failBlock showLoding:(LoadingView)loading
{
    loading(@"加载中");
    NSDictionary *parameters = @{@"openid":WXUserInfo.openid};
    [self.manager POST:RequestCheckUser parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSDictionary *parameters = @{@"openid":WXUserInfo.openid,@"nickname":WXUserInfo.nickname,@"sex":WXUserInfo.sex,@"head_img_url":WXUserInfo.headimgurl,@"union_id":WXUserInfo.unionid,@"province":WXUserInfo.province,@"city":WXUserInfo.city,@"country":WXUserInfo.country};
            [self.manager POST:RequestCreateUser parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([[responseObject objectForKey:@"success"] boolValue]) {
                    successBlock(responseObject);
                }else{
                    failBlock(@{@"error":@"fail"});
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failBlock(@{@"error":error});
            }];
        }else{
            failBlock(@{@"error":@"fail"});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":error});
    }];
    
}

- (void)checkCode:(NSString *)code
          Success:(Success)successBlock
             Fail:(Fail)failBlock
       showLoding:(LoadingView)loading
{
    NSDictionary *parameters = @{@"code":code};
    [self.manager POST:RequestCheckInvitationCode parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
    loading(@"加载中");
    NSDictionary *parameters = @{@"openid":WXUserInfo.openid};
    [self.manager POST:RequestCheckUser parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject objectForKey:@"success"]);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(@{@"state":@"success"});
        }else{
            failBlock(@{@"state":@"fail"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":error});
    }];
}

@end
