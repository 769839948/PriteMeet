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
    manager.requestSerializer.timeoutInterval = 10.0f;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [acceptContentTypes addObject:@"text/plain"];
    [acceptContentTypes addObject:@"text/html"];
    [acceptContentTypes addObject:@"application/json"];
    [acceptContentTypes addObject:@"charset=utf-8"];
    [acceptContentTypes addObject:@"multipart/form-data"];
//    [acceptContentTypes addObject:@{@"Token":@"adfsd"}];
    manager.responseSerializer.acceptableContentTypes = acceptContentTypes;
    return manager;
}

#pragma mark -- GET请求 --
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(Success)success
                 failure:(Fail)failure {
    
    [self.manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(@{@"error":error});
        }
    }];
}

#pragma mark -- POST请求 --
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(Success)success
                  failure:(Fail)failure {
    
    [self.manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(@{@"error":error});
        }
    }];
}

#pragma mark -- put网络请求 --
- (void)putWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(Success)success
                 failure:(Fail)failure{
    
    [self.manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(@{@"success":@YES,@"data":responseObject[@"content"]});
        }else{
            failure(@{@"success":@NO,@"data":responseObject[@"content"]});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(@{@"error":error});
        }
    }];
}

#pragma mark -- delete网络请求 --
- (void)deleteWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                    success:(Success)success
                    failure:(Fail)failure
{
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"9b594c43-9546-7dc8-caee-3fd1f345edd5" };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        failure(@{@"error":error});
                                                    } else {
                                                        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        success(responseDic);
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark -- POST/GET网络请求 --
- (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(Success)success
                     failure:(Fail)failure {
    
    switch (type) {
        case HttpRequestTypeGet:
        {
            [self.manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject[@"content"]);
                }else{
                    failure(@{@"error":@"服务器加载出错"});
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(@{@"error":error});
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            [self.manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject[@"content"]);
                }else{
                    failure(@{@"error":@"服务器加载出错"});
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(@{@"error":error});
                }
            }];
        }
            break;
    }
}

#pragma mark -- 上传图片 --
- (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                uploadParam:(UploadParam *)uploadParam
                    success:(Success)success
                    failure:(Fail)failure {
    
    [self.manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject[@"content"]);
        }else{
            failure(@{@"error":@"服务器加载出错"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(@{@"error":error});
        }
    }];
}



@end
