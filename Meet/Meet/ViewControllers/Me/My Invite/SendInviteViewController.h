//
//  SendInviteViewController.h
//  Meet
//
//  Created by jiahui on 16/5/14.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RefreshInviteBlock)();


@interface SendInviteViewController : UIViewController

@property (strong, nonatomic) RefreshInviteBlock block;

@property (assign, nonatomic) BOOL isNewLogin;


@end
