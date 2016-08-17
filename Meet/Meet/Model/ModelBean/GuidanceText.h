//
//  GuidanceText.h
//  Meet
//
//  Created by Zhang on 7/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

typedef NS_ENUM(NSInteger, GuidanceType) {
    Male = 00,
    FeMale = 01
};


@interface GuidanceText : NSObject

@property (nonatomic, assign) GuidanceType type;

@property (nonatomic, copy) NSString *inviteGuidance;


+ (instancetype)shareInstance;

- (BOOL)synchronize:(NSDictionary *)dic;

@end
