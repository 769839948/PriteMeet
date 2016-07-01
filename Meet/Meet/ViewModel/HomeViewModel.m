//
//  HomeViewModel.m
//  Meet
//
//  Created by Zhang on 6/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "HomeViewModel.h"
#import "WXUserInfo.h"

@implementation HomeViewModel

- (NSArray *)meetDetailImageArray
{
    return @[@"meetdetail_aboutus",@"meetdetail_newmeet",@"meetdetail_wantmeet"];
}

- (NSArray *)meetDetailtitleArray
{
    return @[@"关于我们的那些事",@"最新邀约",@"更多想见的人"];
}

//http://127.0.0.1:8080/api/user/list/?cur_user=1&longitude=116.376421&latitude=39.982417
- (void)getHomeList:(NSString *)page latitude:(double)latitude  longitude:(double)longitude successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock
{
    NSString *url = @"";
    if ([UserInfo isLoggedIn]) {
        url = [RequestBaseUrl stringByAppendingFormat:@"%@?page=%@&cur_user=%@&longitude=%@&latitude=%@",RequestGetHomeList,page,[WXUserInfo shareInstance].openid,[NSString stringWithFormat:@"%f",longitude],[NSString stringWithFormat:@"%f",latitude]];
    }else{
        url = [RequestBaseUrl stringByAppendingFormat:@"%@?page=%@&longitude=%@&latitude=%@",RequestGetHomeList,page,[NSString stringWithFormat:@"%f",longitude],[NSString stringWithFormat:@"%f",latitude]];
    }
    
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock([responseObject objectForKey:@"results"]);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"":@""});
    }];
}

- (void)getOtherUserInfo:(NSString *)userId successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@?cur_user=%@",RequestGetOtherInfo,userId,[WXUserInfo shareInstance].openid];
    
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock([responseObject objectForKey:@"data"]);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"":@""});
    }];
}


- (void)senderLocation:(double)latitude longitude:(double)longitude
{
    
    NSString *url = [RequestBaseUrl stringByAppendingFormat:RequestSenderLocation];
    NSDictionary *parmeters = @{@"uid":[WXUserInfo shareInstance].openid, @"latitude":[NSString stringWithFormat:@"%f",latitude],@"longitude":[NSString stringWithFormat:@"%f",longitude]};
    [self.manager POST:url parameters:parmeters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)senderIpAddress:(Success)successblock fail:(Fail)failBlock
{
    NSString *url = @"http://api.cellocation.com/cell/?mcc=460&mnc=1&lac=4301&ci=20986&output=json";
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successblock(responseObject);
        if ([UserInfo isLoggedIn]) {
            [self senderLocation:[responseObject[@"lat"] doubleValue] longitude:[responseObject[@"lon"] doubleValue]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failBlock(@{@"error":@"error"});
    }];
}




@end
