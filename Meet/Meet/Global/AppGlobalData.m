//
//  AppGlobalData.m
//  Meet
//
//  Created by Zhang on 23/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "AppGlobalData.h"

@implementation AppGlobalData

static AppGlobalData *appGlobalData=nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appGlobalData = [[AppGlobalData alloc] init];
    });
    return appGlobalData;
}


@end
