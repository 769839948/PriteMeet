//
//  SetingViewController.h
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MeetBaseViewController.h"

typedef void (^Logout)();

@interface SetingViewController : MeetBaseViewController

@property (nonatomic, strong) Logout logoutBlock;


@end
