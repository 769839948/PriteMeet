//
//  WXUserInfo.m
//  Meet
//
//  Created by jiahui on 16/5/7.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "WXUserInfo.h"

#define kEncodedObjectPath_WXUser ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WXuserInfo"])

@implementation WXUserInfo

+ (instancetype)shareInstance {
    static WXUserInfo *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        if([UserInfo isLoggedIn])
        {
            shareInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:kEncodedObjectPath_WXUser];
        }
        else
        {
            shareInstance = [[WXUserInfo alloc] init];
        }

    });
    return shareInstance;
}

+ (void)initWithDic:(NSDictionary *)dic
{
    [WXUserInfo shareInstance].openid = dic[@"openid"];
    [WXUserInfo shareInstance].sex = dic[@"sex"];
    [WXUserInfo shareInstance].province = dic[@"province"];
    [WXUserInfo shareInstance].unionid = dic[@"unionid"];
    [WXUserInfo shareInstance].nickname = dic[@"nickname"];
    [WXUserInfo shareInstance].language = dic[@"language"];
    [WXUserInfo shareInstance].headimgurl = dic[@"headimgurl"];
    [WXUserInfo shareInstance].country = dic[@"country"];
    [WXUserInfo shareInstance].city = dic[@"city"];
    [self synchronize];
}

//是否归档成功
+ (BOOL)synchronize
{
    return [NSKeyedArchiver archiveRootObject:[UserInfo sharedInstance] toFile:kEncodedObjectPath_WXUser];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.openid = [aDecoder decodeObjectForKey:@"openid"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.openid forKey:@"openid"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.country forKey:@"country"];
}

+ (void)logout
{
    [WXUserInfo shareInstance].openid = nil;
    [WXUserInfo shareInstance].unionid = nil;
    [WXUserInfo shareInstance].nickname = nil;
}

@end
