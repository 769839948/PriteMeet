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

- (void)applyMeetOrder:(ApplyMeetModel *)model successBlock:(Success)successBlock failBlock:(Fail)failBlock;

- (void)getOrderList:(NSString *)orderState withGuest:(NSString *)guest successBlock:(Success)successBlock failBlock:(Fail)failBlock;

- (void)payOrder:(Success)successBlock failBlock:(Fail)failBlock;

@end
