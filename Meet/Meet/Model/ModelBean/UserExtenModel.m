//
//  UserExtenModel.m
//  Meet
//
//  Created by Zhang on 6/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UserExtenModel.h"
#import "MJExtension.h"
@class Photos;
//文件地址名称
#define kEncodedObjectPath_UserExten ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserExtenModel"])

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
    [UserExtenModel shareInstance].highlight  = nil;
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
        self.highlight = [aDecoder decodeObjectForKey:@"highlight"];
        self.detail = [aDecoder decodeObjectForKey:@"detail"];
        self.completeness = [aDecoder decodeObjectForKey:@"completeness"];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.auth_info forKey:@"auth_info"];
    [aCoder encodeObject:self.cover_photo forKey:@"cover_photo"];
    [aCoder encodeObject:self.highlight forKey:@"highlight"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
    [aCoder encodeObject:self.completeness forKey:@"completeness"];
}


+ (NSArray *)allImageUrl
{
    NSArray *details = [UserExtenModel shareInstance].detail;
    NSMutableArray *urls = [NSMutableArray array];
    for (int i = 0; i < details.count; i ++) {
        Detail *detail = [details objectAtIndex:i];
        for (int j = 0; j < detail.photo.count; j ++) {
            NSDictionary *dic = (NSDictionary *)[detail.photo objectAtIndex:j];
            [urls addObject:dic[@"photo"]];
        }
    }
    return urls;
}

+ (BOOL)synchronizeWithDic:(NSDictionary *)dic
{
    
    [UserExtenModel shareInstance].auth_info  = [dic objectForKey:@"auth_info"];
    Cover_photo *coverPhoto = dic[@"cover_photo"];
    [UserExtenModel shareInstance].cover_photo  = coverPhoto;
    [UserExtenModel shareInstance].highlight  = dic[@"highlight"];
    NSMutableArray *details = [NSMutableArray array];
    NSArray *detailArray = dic[@"detail"];
    Completeness *completeness = [[Completeness alloc] init];
    completeness.completeness = [[dic[@"completeness"] objectForKey:@"completeness"] integerValue];
    completeness.next_page = [[dic[@"completeness"] objectForKey:@"next_page"] integerValue];
    completeness.msg = [dic[@"completeness"] objectForKey:@"msg"];
    [UserExtenModel shareInstance].completeness = completeness;
    for (int i = 0 ; i < detailArray.count; i ++) {
        Detail *detail = [[Detail alloc] init];
        detail.content = [[detailArray objectAtIndex:i] objectForKey:@"content"];
        detail.id = [[detailArray objectAtIndex:i] objectForKey:@"id"];
        detail.photo = [[detailArray objectAtIndex:i] objectForKey:@"photos"];
        detail.title = [[detailArray objectAtIndex:i] objectForKey:@"title"];
        [details addObject:detail];
    }
    [UserExtenModel shareInstance].detail  = [details copy];
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

