//
//  WeiboModel.h
//  Meet
//
//  Created by Zhang on 7/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboModel : NSObject

+ (instancetype)shareInstance;

@property (copy, nonatomic) NSString *unionId;//////用户维一标识
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *usid;
@property (copy, nonatomic) NSArray *accessToken;
@property (copy, nonatomic) NSString *iconURL;

@end
