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
#import "WXUserInfo.h"
#import "UserInfo.h"
#import "ProfileKeyAndValue.h"

@implementation LoginViewModel

- (void)postWXUserInfo:(WXUserInfo *)WXUserInfo
              withCode:(NSString *)code
               Success:(Success)successBlock
                  Fail:(Fail)failBlock
            showLoding:(LoadingView)loading
{
    NSDictionary *parameters = @{@"openid":WXUserInfo.openid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestCheckUser];

    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if (![[responseObject objectForKey:@"success"] boolValue]) {
            NSString *url = [RequestBaseUrl stringByAppendingString:RequestCheckCodeBindUser];
            NSDictionary *parameters = @{@"code":code};
            [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    NSDictionary *parameters = @{@"openid":WXUserInfo.openid,@"nickname":WXUserInfo.nickname,@"gender":[NSString stringWithFormat:@"%@",WXUserInfo.sex],@"head_img_url":[[NSUserDefaults standardUserDefaults] objectForKey:@"ApplyCodeAvatar"],@"province":WXUserInfo.province,@"city":WXUserInfo.city,@"country":WXUserInfo.country,@"union_id":WXUserInfo.unionid,@"code":code};
                    [UserInfo sharedInstance].avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplyCodeAvatar"];
                    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestCreateUser];
                    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
                        if ([[responseObject objectForKey:@"success"] boolValue]) {
                            [UserInfo sharedInstance].uid = WXUserInfo.openid;
                            [UserInfo sharedInstance].avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplyCodeAvatar"];
                            failBlock(@{@"error":@"oldUser"});
                        }else{
                            failBlock(@{@"error":@"上传失败"});
                        }
                    } failure:^(NSDictionary *responseObject) {
                        failBlock(@{@"error":@"网络错误"});
                    }];
                }else{
                    NSDictionary *parameters = @{@"openid":WXUserInfo.openid,@"nickname":WXUserInfo.nickname,@"gender":[NSString stringWithFormat:@"%@",WXUserInfo.sex],@"head_img_url":@"",@"province":WXUserInfo.province,@"city":WXUserInfo.city,@"country":WXUserInfo.country,@"union_id":WXUserInfo.unionid,@"code":code};
                    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestCreateUser];
                    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
                        if ([[responseObject objectForKey:@"success"] boolValue]) {
                            [UserInfo synchronizeWithWXUserInfo:WXUserInfo];
                            successBlock(responseObject);
                        }else{
                            failBlock(@{@"error":@"上传失败"});
                        }
                    } failure:^(NSDictionary *responseObject) {
                        failBlock(@{@"error":@"网络错误"});
                    }];
                }
            } failure:^(NSDictionary *responseObject) {
                failBlock(@{@"error":@"网络错误"});
            }];
        }else{
            failBlock(@{@"error":@"oldUser"});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
    }];
}

- (void)checkCode:(NSString *)code
          Success:(Success)successBlock
             Fail:(Fail)failBlock
       showLoding:(LoadingView)loading
{
    NSDictionary *parameters = @{@"code":code};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestCheckInvitationCode];
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":responseObject});
    }];
}

- (void)oldUserLogin:(NSString *)uid
             Success:(Success)successBlock
                Fail:(Fail)failBlock
          showLoding:(LoadingView)loading
{
    NSDictionary *parameters = @{@"openid":uid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestCheckUser];

    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)getUserInfo:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestGetUserInfo,openId];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"data"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}


- (void)applyCode:(UserInfo *)userInfo
        workArray:(NSArray *)workExps
         eduArray:(NSArray *)eduExps
          Success:(Success)successBlock
             Fail:(Fail)failBlock
       showLoding:(LoadingView)loading
{
    NSMutableArray *workExpArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < workExps.count; i ++) {
        NSArray *array = [workExps[i] componentsSeparatedByString:@"-"];
        NSDictionary *parameters = @{ @"company_name": array[0], @"profession":array[1]};
        [workExpArray addObject:parameters];
    }
    
    NSMutableArray *eduExpArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < eduExps.count; i ++) {
        NSArray *array = [eduExps[i] componentsSeparatedByString:@"-"];
        NSDictionary *parameters = @{ @"graduated": array[0], @"major":array[1],@"education":[[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"education"] objectForKey:array[2]]};
        [eduExpArray addObject:parameters];
    }
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestApplyCode];
    if (userInfo.real_name == nil) {
        userInfo.real_name = @"";
    }
    if (userInfo.job_label == nil) {
        userInfo.job_label = @"";
    }
    NSDictionary *parameters = @{@"avatar":[[NSUserDefaults standardUserDefaults] objectForKey:@"ApplyCodeAvatar"], @"real_name": userInfo.real_name, @"gender":[NSString stringWithFormat:@"%ld",(long)userInfo.gender],@"mobile_num": userInfo.mobile_num, @"birthday": userInfo.birthday, @"weixin_num": userInfo.weixin_num,@"location":userInfo.location,@"hometown":userInfo.hometown,@"affection":[NSString stringWithFormat:@"%ld",(long)userInfo.affection],@"height":[NSString stringWithFormat:@"%ld",(long)userInfo.height],@"income":[NSString stringWithFormat:@"%ld",(long)userInfo.income],@"constellation":[NSString stringWithFormat:@"%ld",(long)userInfo.constellation],@"industry":[NSString stringWithFormat:@"%ld",(long)userInfo.industry],@"job_label":userInfo.job_label,@"work_experience":workExpArray,@"edu_experience":eduExpArray};
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"uid"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

@end
