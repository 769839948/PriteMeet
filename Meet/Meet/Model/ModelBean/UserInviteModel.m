//
//  UserInviteModel.m
//  Meet
//
//  Created by Zhang on 6/14/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UserInviteModel.h"
#import "ProfileKeyAndValue.h"

#define kEncodedObjectPath_UserInvite ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserInviteModel"])

@implementation Results

@end

@implementation UserInviteModel

static UserInviteModel *userInvite = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([UserInviteModel isHaveInviteInfo]) {
            userInvite = [NSKeyedUnarchiver unarchiveObjectWithFile:kEncodedObjectPath_UserInvite];
        }else{
            userInvite = [[UserInviteModel alloc] init];
        }
    });
    return userInvite;
}

+ (BOOL)isHaveInviteInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:kEncodedObjectPath_UserInvite];
}
//是否归档成功
+ (BOOL)synchronize
{
    return [NSKeyedArchiver archiveRootObject:[UserInviteModel shareInstance] toFile:kEncodedObjectPath_UserInvite];
}

+ (BOOL)removeInvite
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager removeItemAtPath:kEncodedObjectPath_UserInvite error:&error];
    if (!result) {
        NSLog(@"注销失败！\%@",error);
    }else{
        
    }
    [UserInviteModel shareInstance].results  = nil;
    return result;
}

- (id)init
{
    if (self = [super init]) {
//        Results *result = [[Results alloc] init];
//        result.theme = @"1";
//        result.
//        self.results = @[];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.results = [aDecoder decodeObjectForKey:@"results"];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.results forKey:@"results"];
}

+ (BOOL)synchronizeWithDic:(NSDictionary *)dicArray
{
    NSMutableArray *userInviiteArray = [NSMutableArray array];
    Results *result = [[Results alloc] init];
    result.introduction = dicArray[@"introduction_main"];
    result.is_fake = [dicArray[@"is_fake"] boolValue];
    result.is_active = [dicArray[@"is_active"] boolValue];
     NSMutableArray *themeArray = [NSMutableArray array];
    for (NSDictionary *results in dicArray[@"theme"]) {
        Theme *theme = [[Theme alloc] init];
        theme.price = [results[@"price"] integerValue];
        theme.theme = results[@"theme"];
        [themeArray addObject:theme];
    }
    result.theme = themeArray;
    [userInviiteArray addObject:result];
    [UserInviteModel shareInstance].results = [userInviiteArray copy];

    return [UserInviteModel synchronize];
}


+ (BOOL)synchronizeWithArray:(NSArray *)itemArray description:(NSString *)description
{
    Results *result = [[Results alloc] init];
    NSMutableArray *themsArray = [NSMutableArray array];
    for (NSString *itemString in itemArray) {
        Theme *themes = [[Theme alloc] init];
        themes.theme = [[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"invitation"] objectForKey:itemString];
        themes.price = 50;
        [themsArray addObject:themes];
    }
    result.theme = [themsArray copy];
    result.introduction = description;
    return [UserInviteModel synchronize];
}

+ (BOOL)isEmptyDescription
{
    BOOL ret = NO;
    
    if ([UserInviteModel shareInstance].results.count == 0) {
        ret = YES;
    }
    return ret;
}

+ (BOOL)isFake
{
    if (![UserInviteModel isEmptyDescription] && [UserInviteModel shareInstance] != nil) {
        return [UserInviteModel shareInstance].results[0].is_fake;
    }else{
        return YES;
    }
}

+ (NSString *)descriptionString:(NSInteger)index
{
    Results *result = [[UserInviteModel shareInstance].results objectAtIndex:index];
    if (result.introduction != nil) {
        return result.introduction;
    }else{
        return @"";
    }
}

+ (NSArray *)themArray:(NSUInteger)index
{
    NSMutableArray *themArray = [NSMutableArray array];
    Results *result = [[UserInviteModel shareInstance].results objectAtIndex:index];

    for (Theme *theme in result.theme) {
        if (![theme.theme isEqualToString:@""]) {
            NSString *themeString = [[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"invitation"] objectForKey:theme.theme];
            if (themeString != nil) {
                [themArray addObject:themeString];
            }
        }
    }
    return [themArray copy];
}

@end




