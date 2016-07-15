//
//  OrderViewModel.m
//  Meet
//
//  Created by Zhang on 7/13/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "OrderViewModel.h"

@implementation OrderViewModel

- (void)aliPayOrder:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:RequestApplyAppointment];
    NSDictionary *parameters = @{@"host": @"318",
                                 @"guest": @"321",
                                 @"appointment_desc": @"appointment_desc",
                                 @"appointment_theme": @"1"};
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject objectForKey:@"pay_url"]);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"order"]);
        }else{
            
        }
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)payOrder:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:RequestPayUrl];
    NSDictionary *parameters = @{@"":@""};
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject objectForKey:@"pay_url"]);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"payinfo"]);
        }else{
            
        }
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getOrderList:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@?cur_user=321",RequestUserAppoitment]];
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"":@""});
    }];
}

@end
