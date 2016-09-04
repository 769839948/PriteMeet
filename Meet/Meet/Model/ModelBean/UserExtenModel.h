//
//  UserExtenModel.h
//  Meet
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Detail.h"

@class Cover_photo,Head_Photo_List;

@interface UserExtenModel : NSObject


@property (nonatomic, strong) Cover_photo *cover_photo;

@property (nonatomic, strong) NSArray<Detail *> *detail;

@property (nonatomic, strong) NSArray<Head_Photo_List *> *head_photo_list;

@property (nonatomic, assign) long long user_id;

@property (nonatomic, copy) NSString *highlight;

@property (nonatomic, copy) NSString *experience;

@property (nonatomic, copy) NSString *auth_info;

@property (nonatomic, strong) Completeness *completeness;



+ (instancetype)shareInstance;

+ (NSArray *)allImageUrl;

+ (BOOL)synchronize;

+ (BOOL)remoUserExtenModel;

+ (BOOL)synchronizeWithDic:(NSDictionary *)dic;
+ (UIImage *)imageForName:(NSString *)name;
+ (BOOL)saveCacheImage:(UIImage *)image withName:(NSString *)name;



@end


