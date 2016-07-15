//
//  WeiboModel.h
//  Meet
//
//  Created by Zhang on 7/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboModel : NSObject

+ (instancetype)shareInstance;

@property (copy, nonatomic) NSString *unionid;//////用户维一标识
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *headimgurl;
@property (copy, nonatomic) NSString *language;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *openid;
@property (copy, nonatomic) NSArray *privilege;
@property (copy, nonatomic) NSString *province;
@property (strong, nonatomic) NSNumber *sex;//////1为男  2为女

@end
