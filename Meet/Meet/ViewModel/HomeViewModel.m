//
//  HomeViewModel.m
//  Meet
//
//  Created by Zhang on 6/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "HomeViewModel.h"
#import "WXUserInfo.h"
#import "ProfileKeyAndValue.h"

@implementation HomeViewModel

- (NSArray *)meetDetailImageArray
{
    return @[@"meetdetail_aboutus",@"meetdetail_newmeet",@"meetdetail_wantmeet"];
}

- (NSArray *)meetDetailtitleArray
{
    return @[@"关于我们的那些事",@"最新邀约",@"更多想见的人"];
}

- (NSArray *)baseInfoTitle
{
    return @[@"真实姓名",@"性别",@"年龄",@"工作城市",@"职业"];
}

- (NSArray *)sectionTitle
{
    return @[@"",@"",@""];
}

- (void)getHomeList:(NSString *)page
           latitude:(double)latitude
          longitude:(double)longitude
       successBlock:(Success)successBlock
          failBlock:(Fail)failBlock
        loadingView:(LoadingView)loadViewBlock
{
    NSString *url = @"";
    if ([UserInfo isLoggedIn]) {
        url = [RequestBaseUrl stringByAppendingFormat:@"%@?page=%@&cur_user=%@&longitude=%@&latitude=%@",RequestGetHomeList,page,[UserInfo sharedInstance].uid,[NSString stringWithFormat:@"%f",longitude],[NSString stringWithFormat:@"%f",latitude]];
    }else{
        url = [RequestBaseUrl stringByAppendingFormat:@"%@?page=%@&longitude=%@&latitude=%@",RequestGetHomeList,page,[NSString stringWithFormat:@"%f",longitude],[NSString stringWithFormat:@"%f",latitude]];
    }
    
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock([responseObject objectForKey:@"results"]);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)getHomeFilterList:(NSString *)page
                 latitude:(double)latitude
                longitude:(double)longitude
                   filter:(NSString *)filterName
             successBlock:(Success)successBlock
                failBlock:(Fail)failBlock
              loadingView:(LoadingView)loadViewBlock
{
    NSString *url = @"";
    if ([UserInfo isLoggedIn]) {
        url = [RequestBaseUrl stringByAppendingFormat:@"%@?page=%@&cur_user=%@&filter=%@&longitude=%@&latitude=%@",RequestGetFilterUserList,page,[UserInfo sharedInstance].uid,filterName,[NSString stringWithFormat:@"%f",longitude],[NSString stringWithFormat:@"%f",latitude]];
    }else{
        url = [RequestBaseUrl stringByAppendingFormat:@"%@?page=%@&filter=%@&longitude=%@&latitude=%@",RequestGetFilterUserList,page,filterName,[NSString stringWithFormat:@"%f",longitude],[NSString stringWithFormat:@"%f",latitude]];
    }
    
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"data"]);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)getOtherUserInfo:(NSString *)userId
            successBlock:(Success)successBlock
               failBlock:(Fail)failBlock
             loadingView:(LoadingView)loadViewBlock
{
    NSString *url = @"";
    if ([UserInfo isLoggedIn]) {
       url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@?cur_user=%@",RequestGetOtherInfo,userId,[UserInfo sharedInstance].uid];
    }else{
        url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestGetOtherInfo,userId];

    }
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"data"]);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}



- (void)getOtherUserInfoProfile:(NSString *)userId
                   successBlock:(Success)successBlock
                      failBlock:(Fail)failBlock
                    loadingView:(LoadingView)loadViewBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestGetOtherInfoProfile,userId];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock([responseObject objectForKey:@"data"]);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)getDicMap:(Success)successBlock
        failBlock:(Fail)failBlock
{
   
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestGetDicMap];
    
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        successBlock(responseObject[@"content"][@"data"]);
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
    }];
}

- (void)senderLocation:(double)latitude
             longitude:(double)longitude
{
    
    NSString *url = [RequestBaseUrl stringByAppendingFormat:RequestSenderLocation];
    NSDictionary *parmeters = @{@"uid":[UserInfo sharedInstance].uid, @"latitude":[NSString stringWithFormat:@"%f",latitude],@"longitude":[NSString stringWithFormat:@"%f",longitude]};
    [self postWithURLString:url parameters:parmeters success:^(NSDictionary *responseObject) {
        
    } failure:^(NSDictionary *responseObject) {
        
    }];
}


- (void)senderIpAddress:(Success)successblock
                   fail:(Fail)failBlock
{
    NSString *url = @"http://api.cellocation.com/cell/?mcc=460&mnc=1&lac=4301&ci=20986&output=json";
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([UserInfo isLoggedIn]) {
            [self senderLocation:[responseObject[@"lat"] doubleValue] longitude:[responseObject[@"lon"] doubleValue]];
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
    }];

}

@end
