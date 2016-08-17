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
typedef void (^HomeListLoginBlock)();
typedef void (^ApplyMeetLoginBlock)();

@interface BaseUserInfoViewController : MyProfileViewController

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) BOOL isDetailViewLogin;

@property (nonatomic, assign) BOOL isHomeListViewLogin;

@property (nonatomic, assign) BOOL isApplyMeetViewLogin;

@property (nonatomic, strong) BlackListBlock blackListBlock;

@property (nonatomic, strong) HomeListLoginBlock homeListBlock;

@property (nonatomic, strong) ApplyMeetLoginBlock applyMeeBlock;

@property (nonatomic, assign) NSInteger detailViweActionSheetSelect;

@end
