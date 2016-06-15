//
//  BaseRequestViewModel.h
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^LoadingView)(NSString *str);
typedef void (^Success)(NSDictionary *object);
typedef void (^Fail)(NSDictionary *object);

@interface BaseRequestViewModel : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

//+ (AFHTTPSessionManager *)manager;
//- (AFHTTPSessionManager *)manager;


@end
