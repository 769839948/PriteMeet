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

@implementation Theme

@end

@implementation Results

@end

@implementation UserInviteModel

static UserInviteModel *userInvite = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if ([UserInviteModel isHaveInviteInfo]) {
            userInvite = [[UserInviteModel alloc] init];
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

+ (BOOL)synchronizeWithDic:(NSArray *)dicArray
{
    NSMutableArray *userInviiteArray = [NSMutableArray array];
    for (NSDictionary *results in dicArray) {
        Results *result = [[Results alloc] init];
        result.created = results[@"created"];
        result.is_active = [results[@"is_active"] boolValue];
        result.descriptions = results[@"description"];
        result.user_id = [results[@"user_id"] integerValue];
        NSMutableArray *themeArray = [NSMutableArray array];
        NSArray *themes = results[@"theme"];
        for (NSDictionary *themeDic in themes) {
            Theme *theme = [[Theme alloc] init];
            theme.id = [themeDic[@"id"] integerValue];
            theme.price = [themeDic[@"price"] integerValue];
            theme.theme = themeDic[@"theme"];
            [themeArray addObject:theme];
        }
        result.theme = themeArray;
        [userInviiteArray addObject:result];
    }
    
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
    result.is_active = YES;
    result.descriptions = description;
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

+ (NSString *)descriptionString:(NSInteger)index
{
    Results *result = [[UserInviteModel shareInstance].results objectAtIndex:index];
    if (result.descriptions != nil) {
        return result.descriptions;
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
            NSLog(@"%@",theme.theme);
            NSString *themeString = [[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"invitation"] objectForKey:theme.theme];
            if (themeString != nil) {
                [themArray addObject:themeString];
            }
        }
    }
    return [themArray copy];
}

@end




