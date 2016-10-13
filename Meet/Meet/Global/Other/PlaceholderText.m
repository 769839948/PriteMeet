//
//  PlaceholderText.m
//  Meet
//
//  Created by Zhang on 8/18/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "PlaceholderText.h"

@implementation PlaceholderText

static PlaceholderText *placeholderText = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        placeholderText = [[PlaceholderText alloc] init];
    });
    return placeholderText;
}

@end
