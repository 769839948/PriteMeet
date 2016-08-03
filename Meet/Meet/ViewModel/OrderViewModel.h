//
//  OrderViewModel.h
//  Meet
//
//  Created by Zhang on 7/13/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"
#import "ApplyMeetModel.h"

@interface OrderViewModel : BaseRequestViewModel

- (NSArray *)orderPageControllerTitle;

/**
 *  申请邀约
 *
 *  @param model        邀约模型
*/
- (void)applyMeetOrder:(ApplyMeetModel *)model
          successBlock:(Success)successBlock
             failBlock:(Fail)failBlock;

/**
 *  获取邀约列表
 *
 *  @param orderState   订单状态
 *  @param guest        guest用户
 */
- (void)getOrderList:(NSString *)orderState
           withGuest:(NSString *)guest
        successBlock:(Success)successBlock
           failBlock:(Fail)failBlock;

- (void)orderStatusOperation:(NSString *)order_id
                     withHos:(NSString *)host
                successBlock:(Success)successBlock
                   failBlock:(Fail)failBlock;

- (void)payOrder:(NSString *)order_id
    successBlock:(Success)successBlock
       failBlock:(Fail)failBlock;

/**
 *  订单状态改变
 *
 *  @param order_id     订单号
 *  @param status       订单状态
 *  @param successBlock successBlock description
 *  @param failBlcok    failBlcok description
 */
- (void)switchOrderStatus:(NSString *)order_id
                   status:(NSString *)status
             succeccBlock:(Success)successBlock
                failBlock:(Fail)failBlcok;
@end
