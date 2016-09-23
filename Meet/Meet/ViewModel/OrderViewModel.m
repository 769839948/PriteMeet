//
//  OrderViewModel.m
//  Meet
//
//  Created by Zhang on 7/13/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "OrderViewModel.h"

@implementation OrderViewModel

- (NSArray *)orderPageControllerTitle
{
    return @[@"待确认",@"待支付",@"待见面",@"历史约见"];
}

- (void)applyMeetOrder:(ApplyMeetModel *)model successBlock:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:RequestApplyAppointment];
    NSDictionary *parameters = @{@"host": model.host,
                                 @"guest": model.guest,
                                 @"appointment_desc": model.appointment_desc,
                                 @"appointment_theme": model.appointment_theme};
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }else{
            failBlock(@{@"error":responseObject[@"content"][@"msg"]});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络出错"});
    }];
}

- (void)orderDetail:(NSString *)order_id
       successBlock:(Success)successBlock
          fialBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@/%@/?cur_user=%@",RequestApiOrder,order_id,[UserInfo sharedInstance].uid]];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }else{
            failBlock(@{@"error":@"请求出错"});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
    }];
}

- (void)payOrder:(NSString *)order_id successBlock:(Success)successBlock failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/api/get_pay_url/?out_trade_no=%@",order_id]];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"pay_url"]);
        }else{
            failBlock(@{@"error":@"请求错误"});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
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
            successBlock(responseObject[@"content"]);
        }else {
            failBlock(@{@"error":@"服务器错误"});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
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
        }else{
            failBlock(@{@"error":@"服务器错误"});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
    }];
}
/**
 *  ORDER_STATUS_BACKEND_CHOICE = [
 ('1', u'待host确认'), ('2', u'guest已取消'), ('3', u'host已拒绝'), ('4', u'待guest付款'),
 ('5', u'待支付平台确认'), ('6', u'待双方见面'), ('7', u'guest约见后取消'), ('8', u'guest取消已退款'),
 ('9', u'host约见后取消'), ('10', u'host取消已退款'), ('11', u'约见已完成')，('12', u'接收后 host 取消'), ('13', u'接收后 host 取消')
 ]
 *
 *  @param order_id     <#order_id description#>
 *  @param status       <#status description#>
 *  @param successBlock <#successBlock description#>
 *  @param failBlock    <#failBlock description#>
 */


- (void)switchOrderStatus:(NSString *)order_id
                   status:(NSString *)status
               rejectType:(NSString *)rejectType
             rejectReason:(NSString *)reason
             succeccBlock:(Success)successBlock
                failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@",RequestSwitchAppointMent]];
    NSString *orderId = [order_id stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *parameters = @{@"status":status,
                                 @"uuid":orderId,
                                 @"reject_type":rejectType,
                                 @"reject_reason":reason
                                 };
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"服务器错误"});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
    }];
}

- (void)orderCancelRejectReson:(Success)successBlock
                     failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@",RequestRejectReson]];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"reason"]);
        }else{
            failBlock(@{@"error":@"服务器错误"});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
    }];
}

- (void)orderNumberOrder:(NSString *)curentId
            successBlock:(Success)successBlock
               failBlock:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@?cur_user=%@",RequestNumberOrder,curentId]];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"count_info"]);
        }else{
            failBlock(@{@"error":@"服务器错误"});
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"网络错误"});
    }];
}

@end
