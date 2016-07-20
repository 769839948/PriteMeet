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
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject);
        }else{
            
        }
    } failure:^(NSDictionary *responseObject) {
        
    }];
}

- (void)payOrder:(NSString *)order_id successBlock:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/api/get_pay_url/?out_trade_no=%@",order_id]];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"pay_url"]);
        }else{
            
        }
    } failure:^(NSDictionary *responseObject) {
        
    }];
}

- (void)getOrderList:(NSString *)orderState
           withGuest:(NSString *)guest
        successBlock:(Success)successBlock
           failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@?cur_user=%@&status=%@",RequestUserAppoitment,guest,orderState]];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        
    }];
}

- (void)orderStatusOperation:(NSString *)order_id
                     withHos:(NSString *)host
                successBlock:(Success)successBlock
                   failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@",RequestAcceptAppointMent]];
    NSDictionary *parameters = @{@"host":host,
                                 @"uuid":order_id
                                 };
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        
    }];
}

@end
