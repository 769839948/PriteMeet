//
//  BaseRequestViewModel.m
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"

@implementation BaseRequestViewModel
@synthesize manager;

- (AFHTTPSessionManager *)manager
{
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.requestSerializer.timeoutInterval = 10.0f;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [acceptContentTypes addObject:@"text/plain"];
    [acceptContentTypes addObject:@"text/html"];
    [acceptContentTypes addObject:@"application/json"];
    [acceptContentTypes addObject:@"charset=utf-8"];
    manager.responseSerializer.acceptableContentTypes = acceptContentTypes;
    return manager;
}

@end
