//
//  ProfileKeyAndValue.h
//  Meet
//
//  Created by Zhang on 6/7/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ProfileType) {
    Affection,
    Income,
    Height,///职业
    constellation,//教育
};


@interface ProfileKeyAndValue : NSObject

@property (nonatomic, copy) NSDictionary *appDic;

+ (instancetype)shareInstance;


+ (NSString *)dicValue:(NSString *)key;

@end
