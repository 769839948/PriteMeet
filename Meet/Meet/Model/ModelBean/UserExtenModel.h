//
//  UserExtenModel.h
//  Meet
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Detail;

@interface Detail : NSObject

@property (nonatomic, assign) long long id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<NSString *> *photo;

@end


@interface UserExtenModel : NSObject


@property (nonatomic, copy) NSString *cover_photo;

@property (nonatomic, strong) NSArray<Detail *> *detail;

@property (nonatomic, assign) long long user_id;

@property (nonatomic, copy) NSString *descriptions;

@property (nonatomic, copy) NSString *auth_info;


+ (instancetype)shareInstance;

+ (NSArray *)allImageUrl;

+ (BOOL)synchronize;

+ (BOOL)remoUserExtenModel;

+ (BOOL)synchronizeWithDic:(NSDictionary *)dic;
+ (UIImage *)imageForName:(NSString *)name;
+ (BOOL)saveCacheImage:(UIImage *)image withName:(NSString *)name;



@end


