//
//  WeChatResgisterViewController.h
//  Meet
//
//  Created by jiahui on 16/5/6.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^needReloadMeView)(BOOL isFisrtLogin);

@interface WeChatResgisterViewController : UIViewController

@property (nonatomic, strong) needReloadMeView reloadMeViewBlock;
@property (nonatomic, strong) NSString *string;

@end
