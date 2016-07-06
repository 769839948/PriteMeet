//
//  GuidanceText.m
//  Meet
//
//  Created by Zhang on 7/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "GuidanceText.h"

//文件地址名称
#define kEncodedObjectPath_GuidanceText ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GuidanceText"])

@implementation GuidanceText

static GuidanceText *guidanceText = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([GuidanceText isGuidanceText]) {
            guidanceText = [NSKeyedUnarchiver unarchiveObjectWithFile:kEncodedObjectPath_GuidanceText];
        }else{
            guidanceText = [[GuidanceText alloc] init];
        }
    });
    return guidanceText;
}

//是否归档成功
+ (BOOL)synchronize
{
    return [NSKeyedArchiver archiveRootObject:[UserInfo sharedInstance] toFile:kEncodedObjectPath_GuidanceText];
}

+ (BOOL)isGuidanceText
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:kEncodedObjectPath_GuidanceText];
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
        self.inviteGuidance = [aDecoder decodeObjectForKey:@"inviteGuidance"];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.inviteGuidance forKey:@"inviteGuidance"];
}


- (BOOL)synchronize:(NSDictionary *)dic
{
    self.inviteGuidance = dic[[NSString stringWithFormat:@"300%ld20",(long)self.type]];
    return [GuidanceText synchronize];
}



@end
