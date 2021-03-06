//
//  UserInviteModel.h
//  Meet
//
//  Created by Zhang on 6/14/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"

@class Results;
@interface Results : NSObject

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) BOOL is_fake;

@property (nonatomic, assign) BOOL is_active;

@property (nonatomic, strong) NSArray<Theme *> *theme;

@end

@interface UserInviteModel : NSObject

@property (nonatomic, strong) NSArray<Results *> *results;


+ (instancetype)shareInstance;

+ (BOOL)removeInvite;

+ (BOOL)isEmptyDescription;

+ (BOOL)isFake;

+ (NSString *)descriptionString:(NSInteger)index;

+ (NSArray *)themArray:(NSUInteger)index;

+ (BOOL)synchronizeWithArray:(NSArray *)itemArray description:(NSString *)description;

+ (BOOL)synchronizeWithDic:(NSDictionary *)dic;

@end
