//
//  HomeViewModel.m
//  Meet
//
//  Created by Zhang on 6/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (NSArray *)meetDetailImageArray
{
    return @[@"meetdetail_aboutus",@"meetdetail_newmeet",@"meetdetail_wantmeet"];
}

- (NSArray *)meetDetailtitleArray
{
    return @[@"关于我们的那些事",@"最新邀约",@"更多想见的人"];
}

- (void)getHomeList:(NSString *)page successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@?page=%@",RequestGetHomeList,page];
    
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

- (void)getOtherUserInfo:(NSString *)userId successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@?user_id=%@",RequestGetOtherInfo,userId];
    
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

@end