//
//  ProfileKeyAndValue.m
//  Meet
//
//  Created by Zhang on 6/7/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "ProfileKeyAndValue.h"

@implementation ProfileKeyAndValue

static ProfileKeyAndValue *profileData = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profileData = [[ProfileKeyAndValue alloc] init];
        profileData.appDic = [self loadAppDic];
    });
    return profileData;
}


+ (NSDictionary *)loadAppDic
{
    NSError *error = nil;
    NSString*filePath=[[NSBundle mainBundle] pathForResource:@"ProfileKeyValue"ofType:@"txt"];
    
    NSString *str=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
//    NSLog(@"%@",str);
    return [self dictionaryWithJsonString:str];
    //;
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+ (NSString *)dicValue:(NSString *)key
{
    NSString *str = @"";
    str = [profileData.appDic objectForKey:key];
    return str;
}


@end
