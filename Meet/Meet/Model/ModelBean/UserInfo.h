//
//  UserInfo.h
//  NSKeyedArchiverDemo
//
//  Created by Zhang on 6/7/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Edu_Expirence,Work_Expirence;

@interface UserInfo : NSObject


@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *mobile_num;

@property (nonatomic, assign) NSInteger religion;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *wechat_union_id;

@property (nonatomic, assign) NSInteger affection;

@property (nonatomic, copy) NSString *weixin_num;

@property (nonatomic, assign) NSInteger smoke;

@property (nonatomic, strong) NSArray<Work_Expirence *> *work_expirence;

@property (nonatomic, assign) NSInteger constellation;

@property (nonatomic, copy) NSString *id_card;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, copy) NSString *social_id;

@property (nonatomic, assign) NSInteger drink;

@property (nonatomic, assign) long long id;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger income;

@property (nonatomic, strong) NSArray<Edu_Expirence *> *edu_expirence;

@property (nonatomic, copy) NSString *created;

@property (nonatomic, copy) NSString *hometown;

@property (nonatomic, assign) BOOL isFirstLogin;

+ (instancetype)sharedInstance;

+ (BOOL)synchronizeWithDic:(NSDictionary *)dic;

+ (BOOL)synchronize;

+ (BOOL)isLoggedIn;

+ (BOOL)logout;

+ (BOOL)saveCacheImage:(UIImage *)image withName:(NSString *)name;

+ (UIImage *)imageForName:(NSString *)name;

//+ (BOOL)saveBaseData:(id)data WithName:(NSString *)name;
//
//+ (id)getBaseDataWithName:(NSString *)name;
//
//+ (void)saveChatWithMessageArray:(NSMutableArray *)message withKey:(NSString *)key;
//
//+ (id)getChatMessageWithKey:(NSString *)key;



@end
