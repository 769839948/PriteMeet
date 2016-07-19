//
//  OrderViewModel.m
//  Meet
//
//  Created by Zhang on 7/13/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "OrderViewModel.h"

@implementation OrderViewModel

- (void)applyMeetOrder:(ApplyMeetModel *)model successBlock:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:RequestApplyAppointment];
    NSDictionary *parameters = @{@"host": model.host,
                                 @"guest": model.guest,
                                 @"appointment_desc": model.appointment_desc,
                                 @"appointment_theme": model.appointment_theme};
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject objectForKey:@"pay_url"]);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"order_id"]);
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)payOrder:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:@"/api/get_pay_url/?out_trade_no=20160719101423l0qrpxofygjrk95tch"];
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"pay_url"]);
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getOrderList:(NSString *)orderState withGuest:(NSString *)guest successBlock:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@?cur_user=%@&status=%@",RequestUserAppoitment,guest,orderState]];
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
