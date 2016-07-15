//
//  ServiceViewModel.h
//  Meet
//
//  Created by Zhang on 7/7/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"

@interface ServiceViewModel : BaseRequestViewModel

- (void)requestService:(Success)successBlock failBlock:(Fail)failBlock;

@end
