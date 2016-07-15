//
//  OrderViewModel.h
//  Meet
//
//  Created by Zhang on 7/13/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"

@interface OrderViewModel : BaseRequestViewModel

- (void)aliPayOrder:(Success)successBlock failBlock:(Fail)failBlock;

- (void)getOrderList:(Success)successBlock failBlock:(Fail)failBlock;

- (void)payOrder:(Success)successBlock failBlock:(Fail)failBlock;

@end
