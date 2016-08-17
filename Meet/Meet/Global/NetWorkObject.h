//
//  NetWorkObject.h
//  Meet
//
//  Created by jiahui on 16/5/8.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface NetWorkObject : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress *progress))progress
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (NSURLSessionDownloadTask *)downloadTask:(NSString *)URLString
                                  progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                               destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                         completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress *progress))progress
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
