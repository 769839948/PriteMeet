//
//  UserProtocolViewController.h
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MeetBaseViewController.h"

typedef void(^LoginViewShow)();

@interface UserProtocolViewController : MeetBaseViewController

@property (nonatomic, strong) LoginViewShow block;

@end
