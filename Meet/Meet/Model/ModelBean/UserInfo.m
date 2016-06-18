//
//  UserInfo.m
//  NSKeyedArchiverDemo
//
//  Created by Zhang on 6/7/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import "UserInfo.h"
#import "UserExtenModel.h"
#import "UserInviteModel.h"

#import <UIKit/UIKit.h>
//文件地址名称
#define kEncodedObjectPath_User ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserInfo"])

@implementation Completeness

@end

@implementation UserInfo

static UserInfo *userInfo=nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if([UserInfo isLoggedIn])
        {
            userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:kEncodedObjectPath_User];
        }
        else
        {
            userInfo = [[UserInfo alloc] init];
        }
    });
    return userInfo;
}

//是否归档成功
+ (BOOL)synchronize
{
    return [NSKeyedArchiver archiveRootObject:[UserInfo sharedInstance] toFile:kEncodedObjectPath_User];
}

+ (BOOL)isLoggedIn
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:kEncodedObjectPath_User];
}

+ (BOOL)logout
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager removeItemAtPath:kEncodedObjectPath_User error:&error];
    [UserExtenModel remoUserExtenModel];
    [UserInviteModel removeInvite];
    if (!result) {
        NSLog(@"注销失败！\%@",error);
    }else{
        
    }
    [UserInfo sharedInstance].real_name  = nil;
    [UserInfo sharedInstance].location  = nil;
    [UserInfo sharedInstance].birthday  = nil;
    [UserInfo sharedInstance].mobile_num  = nil;
    [UserInfo sharedInstance].religion  = 0;
    [UserInfo sharedInstance].birthday  = nil;
    [UserInfo sharedInstance].user_name  = nil;
    [UserInfo sharedInstance].country  = nil;
    [UserInfo sharedInstance].wechat_union_id  = nil;
    [UserInfo sharedInstance].affection  = 0;
    [UserInfo sharedInstance].weixin_num  = nil;
    [UserInfo sharedInstance].smoke  = 0;
    [UserInfo sharedInstance].work_expirence  = @[];
    [UserInfo sharedInstance].constellation  = 0;
    [UserInfo sharedInstance].id_card  = nil;
    [UserInfo sharedInstance].industry  = nil;
    [UserInfo sharedInstance].social_id  = nil;
    [UserInfo sharedInstance].drink  = 0;
    [UserInfo sharedInstance].gender  = 0;
    [UserInfo sharedInstance].height  = 0;
    [UserInfo sharedInstance].avatar  = nil;
    [UserInfo sharedInstance].age  = 0;
    [UserInfo sharedInstance].income  = 0;
    [UserInfo sharedInstance].edu_expirence  = @[];
    [UserInfo sharedInstance].created  = nil;
    [UserInfo sharedInstance].hometown  = nil;
    [UserInfo sharedInstance].isFirstLogin = NO;
    [UserInfo sharedInstance].completeness = nil;
    [UserInfo sharedInstance].personal_label = nil;
    [UserInfo sharedInstance].job_label = nil;
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
        self.real_name = [aDecoder decodeObjectForKey:@"real_name"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.mobile_num = [aDecoder decodeObjectForKey:@"mobile_num"];
        self.religion = [aDecoder decodeIntegerForKey:@"religion"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.wechat_union_id = [aDecoder decodeObjectForKey:@"wechat_union_id"];
        self.affection = [aDecoder decodeIntegerForKey:@"affection"];
        self.weixin_num = [aDecoder decodeObjectForKey:@"weixin_num"];
        self.smoke = [aDecoder decodeIntegerForKey:@"smoke"];
        self.work_expirence = [aDecoder decodeObjectForKey:@"work_expirence"];
        self.constellation = [aDecoder decodeIntegerForKey:@"constellation"];
        self.id_card = [aDecoder decodeObjectForKey:@"id_card"];
        self.industry = [aDecoder decodeObjectForKey:@"industry"];
        self.social_id = [aDecoder decodeObjectForKey:@"social_id"];
        self.drink = [aDecoder decodeIntegerForKey:@"drink"];
        self.gender = [aDecoder decodeIntegerForKey:@"gender"];
        self.height = [aDecoder decodeIntegerForKey:@"height"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.income = [aDecoder decodeIntegerForKey:@"income"];
        self.edu_expirence = [aDecoder decodeObjectForKey:@"edu_expirence"];
        self.created = [aDecoder decodeObjectForKey:@"created"];
        self.hometown = [aDecoder decodeObjectForKey:@"hometown"];
        self.isFirstLogin = [aDecoder decodeBoolForKey:@"isFirstLogin"];
        self.completeness = [aDecoder decodeObjectForKey:@"completeness"];
        self.personal_label = [aDecoder decodeObjectForKey:@"personal_label"];
        self.job_label = [aDecoder decodeObjectForKey:@"job_label"];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.real_name forKey:@"real_name"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.mobile_num forKey:@"mobile_num"];
    [aCoder encodeInteger:self.religion forKey:@"religion"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.wechat_union_id forKey:@"wechat_union_id"];
    [aCoder encodeInteger:self.affection forKey:@"affection"];
    [aCoder encodeObject:self.weixin_num forKey:@"weixin_num"];
    [aCoder encodeInteger:self.smoke forKey:@"smoke"];
    [aCoder encodeObject:self.work_expirence forKey:@"work_expirence"];
    [aCoder encodeInteger:self.constellation forKey:@"constellation"];
    [aCoder encodeObject:self.id_card forKey:@"id_card"];
    [aCoder encodeInteger:self.industry forKey:@"industry"];
    [aCoder encodeObject:self.social_id forKey:@"social_id"];
    [aCoder encodeInteger:self.drink forKey:@"drink"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeInteger:self.height forKey:@"height"];
    [aCoder encodeInteger:self.income forKey:@"income"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.edu_expirence forKey:@"edu_expirence"];
    [aCoder encodeObject:self.created forKey:@"created"];
    [aCoder encodeObject:self.hometown forKey:@"hometown"];
    [aCoder encodeBool:self.isFirstLogin forKey:@"isFirstLogin"];
    [aCoder encodeObject:self.completeness forKey:@"completeness"];
    [aCoder encodeObject:self.job_label forKey:@"job_label"];
    [aCoder encodeObject:self.personal_label forKey:@"personal_label"];
}

+ (BOOL)synchronizeWithDic:(NSDictionary *)dic
{
    [UserInfo sharedInstance].real_name  = dic[@"real_name"];
    [UserInfo sharedInstance].location  = dic[@"location"];
    [UserInfo sharedInstance].birthday  = dic[@"birthday"];
    [UserInfo sharedInstance].mobile_num  = dic[@"mobile_num"];
    [UserInfo sharedInstance].religion  = [dic[@"religion"] integerValue];
    [UserInfo sharedInstance].birthday  = dic[@"birthday"];
    [UserInfo sharedInstance].user_name  = dic[@"user_name"];
    [UserInfo sharedInstance].country  = dic[@"country"];
    [UserInfo sharedInstance].wechat_union_id  = dic[@"wechat_union_id"];
    [UserInfo sharedInstance].affection  = [dic[@"affection"] integerValue];
    [UserInfo sharedInstance].weixin_num  = dic[@"weixin_num"];
    [UserInfo sharedInstance].smoke  = [dic[@"smoke"] integerValue];
    [UserInfo sharedInstance].work_expirence  = dic[@"work_expirence"];
    [UserInfo sharedInstance].constellation  = [dic[@"constellation"] integerValue];
    [UserInfo sharedInstance].id_card  = dic[@"id_card"];
    [UserInfo sharedInstance].industry  = [dic[@"industry"] integerValue];
    [UserInfo sharedInstance].social_id  = dic[@"social_id"];
    [UserInfo sharedInstance].drink  = [dic[@"drink"] integerValue];
    [UserInfo sharedInstance].gender  = [dic[@"gender"] integerValue];
    [UserInfo sharedInstance].height  = [dic[@"height"] integerValue];
    [UserInfo sharedInstance].avatar  = dic[@"avatar"];
    [UserInfo sharedInstance].age  = [dic[@"age"] integerValue];
    [UserInfo sharedInstance].income  = [dic[@"income"] integerValue];
    [UserInfo sharedInstance].edu_expirence  = dic[@"edu_expirence"];
    [UserInfo sharedInstance].created  = dic[@"created"];
    [UserInfo sharedInstance].hometown  = dic[@"hometown"];
    [UserInfo sharedInstance].job_label = dic[@"job_label"];
    [UserInfo sharedInstance].personal_label = dic[@"personal_label"];
    [UserInfo sharedInstance].isFirstLogin = YES;
    
    Completeness *completeness = [[Completeness alloc] init];
    completeness.completeness = [[dic[@"completeness"] objectForKey:@"completeness"] integerValue];
    completeness.next_page = [[dic[@"completeness"] objectForKey:@"next_page"] integerValue];
    completeness.msg = [dic[@"completeness"] objectForKey:@"msg"];
    [UserInfo sharedInstance].completeness = completeness;
    
    return [UserInfo synchronize];
}

+ (BOOL)saveCacheImage:(UIImage *)image withName:(NSString *)name
{
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"uploadImage/headerImage/"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    [UserInfo saveSmallImage:image withName:name];
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData writeToFile:saveImagePath atomically:NO];
}

+ (UIImage *)imageForName:(NSString *)name
{
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"uploadImage/headerImage/"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:saveImagePath];
    return [[UIImage alloc] initWithData:data];
}

+ (void)saveSmallImage:(UIImage *)smallImage withName:(NSString *)name
{
    
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"uploadImage/headerImageSmall/"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.5);
    [imageData writeToFile:saveImagePath atomically:NO];
}

+ (UIImage *)smallImageName:(NSString *)name
{
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"uploadImage/headerImageSmall/"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:saveImagePath];
    return [[UIImage alloc] initWithData:data];
}

/*
+ (BOOL)saveBaseData:(id)data WithName:(NSString *)name
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path    = paths.lastObject;
    NSString *temPath = [path stringByAppendingPathComponent:@"baseData"];
    
    if (![fm fileExistsAtPath:temPath])
    {
        NSError *error = nil;
        [fm createDirectoryAtPath:temPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *filePath = [temPath stringByAppendingFormat:@"/%@.plist",name];
    return [NSKeyedArchiver archiveRootObject:data toFile:filePath];
}

+ (id)getBaseDataWithName:(NSString *)name
{
    NSFileManager *fm  = [NSFileManager defaultManager];
    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path     = paths[0];
    NSString *filePath = [path stringByAppendingFormat:@"/baseData/%@.plist",name];
    //    LSLog(@"read_path = %@",filePath);
    if (![fm isReadableFileAtPath:filePath])
    {
        return nil;
    }
    id dat = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return dat;
}

+ (void)saveChatWithMessageArray:(NSMutableArray *)message withKey:(NSString *)key
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path    = paths.lastObject;
    NSString *temPath = [path stringByAppendingPathComponent:@"ChatData"];
    
    if (![fm fileExistsAtPath:temPath])
    {
        NSError *error = nil;
        [fm createDirectoryAtPath:temPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *filePath = [temPath stringByAppendingFormat:@"/%@.plist",key];
    [NSKeyedArchiver archiveRootObject:message toFile:filePath];
}

+ (id)getChatMessageWithKey:(NSString *)key
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path    = paths.lastObject;
    NSString *temPath = [path stringByAppendingPathComponent:@"ChatData"];
    if (![fm fileExistsAtPath:temPath])
    {
        return nil;
    }
    NSString *filePath = [temPath stringByAppendingFormat:@"/%@.plist",key];
    NSData *dat        = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return dat;
}

*/
//
//+ (NSDictionary *)objectClassInArray{
//    return @{@"edu_expirence" : [Edu_Expirence class], @"work_expirence" : [Work_Expirence class]};
//}
@end



