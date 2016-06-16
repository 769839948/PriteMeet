//
//  UserExtenModel.m
//  Meet
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UserExtenModel.h"

//文件地址名称
#define kEncodedObjectPath_UserExten ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserExtenModel"])

@implementation Detail

@end

@implementation UserExtenModel
@synthesize auth_info;

static UserExtenModel *userExten = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        if ([UserExtenModel isHaveExtenInfo]) {
            userExten = [NSKeyedUnarchiver unarchiveObjectWithFile:kEncodedObjectPath_UserExten];

        }else{
            userExten = [[UserExtenModel alloc] init];

        }
    });
    return userExten;
}

+ (BOOL)isHaveExtenInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:kEncodedObjectPath_UserExten];
}
//是否归档成功
+ (BOOL)synchronize
{
    return [NSKeyedArchiver archiveRootObject:[UserExtenModel shareInstance] toFile:kEncodedObjectPath_UserExten];
}

+ (BOOL)remoUserExtenModel
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager removeItemAtPath:kEncodedObjectPath_UserExten error:&error];
    if (!result) {
        NSLog(@"注销失败！\%@",error);
    }else{
        
    }
    [UserExtenModel shareInstance].auth_info  = nil;
    [UserExtenModel shareInstance].cover_photo  = nil;
    [UserExtenModel shareInstance].descriptions  = nil;
    [UserExtenModel shareInstance].detail  = nil;
    
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
        self.auth_info = [aDecoder decodeObjectForKey:@"auth_info"];
        self.cover_photo = [aDecoder decodeObjectForKey:@"cover_photo"];
        self.descriptions = [aDecoder decodeObjectForKey:@"descriptions"];
        self.detail = [aDecoder decodeObjectForKey:@"detail"];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.auth_info forKey:@"auth_info"];
    [aCoder encodeObject:self.cover_photo forKey:@"cover_photo"];
    [aCoder encodeObject:self.descriptions forKey:@"descriptions"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
}


+ (NSArray *)allImageUrl
{
    NSArray *details = [UserExtenModel shareInstance].detail;
    NSMutableArray *urls = [NSMutableArray array];
    for (int i = 0; i < details.count; i ++) {
        Detail *detail = [details objectAtIndex:i];
        [urls addObjectsFromArray:detail.photo];
    }
    return urls;
}

+ (BOOL)synchronizeWithDic:(NSDictionary *)dic
{
    
    [UserExtenModel shareInstance].auth_info  = [dic objectForKey:@"auth_info"];
    NSArray *avatar = [dic[@"cover_photo"] componentsSeparatedByString:@"?"];
    NSString *newString = [avatar[0] stringByAppendingString:@"?imageView2/1/w/1125/h/861"];
    [UserExtenModel shareInstance].cover_photo  = newString;
    [UserExtenModel shareInstance].descriptions  = dic[@"descriptions"];
    NSMutableArray *details = [NSMutableArray array];
    NSArray *detailArray = dic[@"detail"];
    for (int i = 0 ; i < detailArray.count; i ++) {
        Detail *detail = [[Detail alloc] init];
        detail.content = [[detailArray objectAtIndex:i] objectForKey:@"content"];
        detail.id = [[detailArray objectAtIndex:i] objectForKey:@"id"];
//        NSArray *avatar = [[detailArray objectAtIndex:i] objectForKey:@"photo" componentsSeparatedByString:@"?"];
//        NSString *newString = [avatar[0] stringByAppendingString:@"?imageView2/1/w/375/h/271"];
        detail.photo = [[detailArray objectAtIndex:i] objectForKey:@"photo"];
        detail.title = [[detailArray objectAtIndex:i] objectForKey:@"title"];
        [details addObject:detail];
    }
    [UserExtenModel shareInstance].detail  = [details copy];
    UserExtenModel *userExt = [UserExtenModel shareInstance];
    NSLog(@"%@",userExt.auth_info);
    return [UserExtenModel synchronize];
}

+ (BOOL)saveCacheImage:(UIImage *)image withName:(NSString *)name
{
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"uploadImage/big/"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    [UserExtenModel saveSmallImage:image withName:name];
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData writeToFile:saveImagePath atomically:NO];
}

+ (UIImage *)imageForName:(NSString *)name
{
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"uploadImage/big/"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:saveImagePath];
    return [[UIImage alloc] initWithData:data];
}

+ (void)saveSmallImage:(UIImage *)smallImage withName:(NSString *)name
{
    
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"uploadImage/small/"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.5);
    [imageData writeToFile:saveImagePath atomically:NO];
}

+ (UIImage *)smallImageName:(NSString *)name
{
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"uploadImage/samll"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:saveImagePath];
    return [[UIImage alloc] initWithData:data];
}

@end

