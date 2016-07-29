//
//  BaseUserInfoViewController.h
//  Meet
//
//  Created by Zhang on 6/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileViewController.h"

typedef void (^BlackListBlock)();

@interface BaseUserInfoViewController : MyProfileViewController

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) BOOL isDetailViewLogin;

@property (nonatomic, strong) BlackListBlock blackListBlock;

@property (nonatomic, assign) NSInteger detailViweActionSheetSelect;

@end
