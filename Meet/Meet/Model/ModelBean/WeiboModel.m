//
//  WeiboModel.m
//  Meet
//
//  Created by Zhang on 7/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "WeiboModel.h"

@implementation WeiboModel

+ (instancetype)shareInstance {
    static WeiboModel *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[WeiboModel  alloc] init];
    });
    return shareInstance;
}

@end
