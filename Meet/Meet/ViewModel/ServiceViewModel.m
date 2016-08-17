//
//  ServiceViewModel.m
//  Meet
//
//  Created by Zhang on 7/7/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "ServiceViewModel.h"

@implementation ServiceViewModel

- (void)requestService:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestGetService];
    
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"网络错误"});
    }];
}

@end
