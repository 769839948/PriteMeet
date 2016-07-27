//
//  UserInfoModel.m
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UserInfoViewModel.h"
#import "UserInfo.h"
#import "WXUserInfo.h"
#import "ProfileKeyAndValue.h"
#import "NetWorkObject.h"
#import "UserExtenModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "QiniuSDK.h"

@implementation UserInfoViewModel

- (NSArray *)imageArray
{
    return @[@"me_newmeet",@"me_ attestation",@"me_mymeet",@"me_wantmeet",@"me_addfriends"];
}
- (NSArray *)titleArray
{
    return @[@"我的邀约",@"身份认证",@"我的约见",@"想见的人",@"邀请朋友"];
}

- (NSArray *)sectionTitle
{
    return @[@"详细资料",@"工作经历",@"教育背景"];
}

- (NSArray *)sectionButtonTitle
{
    return @[@"",@"添加工作经历",@"添加教育背景"];
}

- (void)updateUserInfo:(UserInfo *)userInfo
        withStateArray:(NSDictionary *)dic
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading
{
    NSDictionary *parameters = @{@"avatar":userInfo.avatar,
                                 @"real_name": userInfo.real_name,
                                 @"gender":[NSString stringWithFormat:@"%ld",(long)userInfo.gender],
                                 @"mobile_num": userInfo.mobile_num,
                                 @"birthday": userInfo.birthday,
                                 @"weixin_num": userInfo.weixin_num,
                                 @"location":userInfo.location,
                                 @"hometown":userInfo.hometown,
                                 @"affection":[NSString stringWithFormat:@"%ld",(long)userInfo.affection],
                                 @"height":[NSString stringWithFormat:@"%ld",(long)userInfo.height],
                                 @"income":[NSString stringWithFormat:@"%ld",(long)userInfo.income],
                                 @"constellation":[NSString stringWithFormat:@"%ld",(long)userInfo.constellation],
                                 @"industry":[NSString stringWithFormat:@"%ld",(long)userInfo.industry],
                                 @"job_label":userInfo.job_label};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestUpdateUser,userInfo.uid];
    [self putWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"data"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)updateEduExp:(NSString *)eduString
           witheduId:(NSString *)eduId
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading
{
    NSArray *array = [eduString componentsSeparatedByString:@"-"];
    NSDictionary *parameters = @{ @"graduated": array[0],
                                  @"major":array[1],
                                  @"education":[[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"education"] objectForKey:array[2]],
                                  @"user_id":[UserInfo sharedInstance].uid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestAddEduExp,eduId];
    [self putWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)addEduExperent:(NSString *)workString
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading
{
    NSArray *array = [workString componentsSeparatedByString:@"-"];
    NSDictionary *parameters = @{@"graduated": array[0],
                                 @"major":array[1],
                                 @"education":[[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"education"] objectForKey:array[2]],
                                 @"user_id":[UserInfo sharedInstance].uid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/",RequestAddEduExp];
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}


- (void)updateWorkExperent:(NSString *)workString
                withWorkId:(NSString *)workId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading
{
    NSArray *array = [workString componentsSeparatedByString:@"-"];
    NSDictionary *parameters = @{ @"company_name": array[0],
                                  @"profession":array[1],
                                  @"income":@0,
                                  @"user_id":[UserInfo sharedInstance].uid
                                  };
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestAddWorkExp,workId];
    [self putWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)deleteWorkExperent:(NSString *)workId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestAddWorkExp,workId];
    [self deleteWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)deleteEduExperent:(NSString *)eduId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestAddEduExp,eduId];
    [self deleteWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}


- (void)addWorkExperent:(NSString *)workString
                success:(Success)successBlock
                   fail:(Fail)failBlock
          loadingString:(LoadingView)loading
{
    NSArray *array = [workString componentsSeparatedByString:@"-"];
    NSDictionary *parameters = @{ @"company_name": array[0],
                                  @"profession":array[1],
                                  @"income":@0,
                                  @"user_id":[UserInfo sharedInstance].uid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestAddWorkExp];
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)getUserInfo:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestGetUserInfo,openId];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"data"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)uploadImage:(UIImage *)image
        isApplyCode:(BOOL)isApplyCode
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading
{
    NSString *urlToken = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestUploadPhotoToken];
    [self getWithURLString:urlToken parameters:nil success:^(NSDictionary *responseObject) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSString *timeNow = [self getTimeNow];
        [upManager putData:imageData key:timeNow token:responseObject[@"content"][@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (!isApplyCode) {
                NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestUploadUserPhoto,[UserInfo sharedInstance].uid];
                NSDictionary *parameters = @{@"key":resp[@"key"],
                                             @"hash":resp[@"hash"],
                                             @"width":resp[@"image"][@"width"],
                                             @"height":resp[@"image"][@"height"]};
                [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
                    [UserInfo saveCacheImage:image withName:@"headImage.jpg"];
                    successBlock(@{@"success":@"1",@"avatar":[NSString stringWithFormat:@"http://7xsatk.com1.z0.glb.clouddn.com/%@",timeNow]});
                } failure:^(NSDictionary *responseObject) {
                    failBlock(@{@"error":@"上传服务器出错"});
                }];
            }else{
                successBlock(@{@"success":@"1",@"avatar":[NSString stringWithFormat:@"http://7xsatk.com1.z0.glb.clouddn.com/%@",timeNow]});
            }
        } option:nil];
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"上传七牛出错"});
    }];
}


- (void)addStar:(NSString *)description
        success:(Success)successBlock
           fail:(Fail)failBlock
  loadingString:(LoadingView)loading
{
    NSDictionary *parameters = @{@"highlight":description};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestExtINfo,[UserInfo sharedInstance].uid];
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)getMoreExtInfo:(NSString *)openId
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestExtINfo,[UserInfo sharedInstance].uid];
    
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"data"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}


- (void)uploadInvite:(NSString *)description
          themeArray:(NSArray *)themeArray
            isActive:(BOOL)isActive
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading
{

    NSString *them = @"";
    for (NSString *themeString in themeArray) {
        them = [them stringByAppendingString:[NSString stringWithFormat:@"%@,",[[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"invitation"]objectForKey:themeString]]];
    }
    NSString *subLastString = @"";
    if (them.length > 1){
        subLastString = [them substringToIndex:them.length - 1];
    }
    NSDictionary *parameters;
    if (isActive) {
        parameters = @{ @"introduction":description,
                        @"theme":subLastString,
                        @"is_active":@YES};
    }else{
        parameters = @{ @"introduction":description,
                        @"theme":subLastString,
                        @"is_active":@NO};
    }
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestInviteInfo,[UserInfo sharedInstance].uid];
    
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)getInvite:(Success)successBlock
             fail:(Fail)failBlock
    loadingString:(LoadingView)loading
{
    
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestInviteInfo,[UserInfo sharedInstance].uid];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"data"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

+ (void)saveCacheImage:(NSString *)url
       completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
             fail:(Fail)failBlock
         loadingString:(LoadingView)loading
{
    NSArray *imageNameArray = [url componentsSeparatedByString:@"?"];
    NSArray *imageName = [imageNameArray[0] componentsSeparatedByString:@"/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   if ([UserExtenModel saveCacheImage:image withName:imageName[3]]) {
                                       completionBlock(YES,image);
                                   }else{
                                       failBlock(@{@"fail":@"1"});
                                   }
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
    
}


- (void)lastModifield:(void (^)(NSString *time))lastBlock failBlock:(Fail)failBock
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestLastUpdate,[UserInfo sharedInstance].uid];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            lastBlock(responseObject[@"content"][@"updated_at"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBock(responseObject);
    }];
}

- (void)getAllInviteAllItems:(Success)successBlock
                   fail:(Fail)failBlock
               loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestGetInviteItems];
    
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"data"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)uploadCoverPhoto:(UIImage *)image
                 success:(Success)successBlock
                    fail:(Fail)failBlock
           loadingString:(LoadingView)loading
{
    [self uploadQiNiuServers:image success:^(NSDictionary *responseObject) {
        NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestUploadCoverPhoto,[UserInfo sharedInstance].uid];
        [self postWithURLString:url parameters:responseObject[@"parameters"] success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(NSDictionary *responseObject) {
            failBlock(responseObject);
        }];
    } failBlock:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)uploadMoreProfile:(NSMutableArray *)imageArrays
                    title:(NSString *)title
                  content:(NSString *)content
                  success:(Success)successBlock
                     fail:(Fail)failBlock
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < imageArrays.count; i ++) {
        [self uploadQiNiuServers:imageArrays[i] success:^(NSDictionary *responseObject) {
            [photos addObject:responseObject[@"parameters"]];
            if (i == imageArrays.count - 1) {
                NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestUploadMoreProfile,[UserInfo sharedInstance].uid];
                NSDictionary *parameters = @{@"photo":photos,
                                             @"title":title,
                                             @"content":content
                                             };
                [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
                    NSLog(@"%@",responseObject);
                } failure:^(NSDictionary *responseObject) {
                    failBlock(responseObject);
                }];
            }
        } failBlock:^(NSDictionary *responseObject) {
            failBlock(responseObject);
        }];
    }
}

- (void)changeMoreProfile:(NSMutableArray *)imageArrays
            moreProfileId:(NSString *)moreProfileId
                    title:(NSString *)title
                  content:(NSString *)content
                  success:(Success)successBlock
                     fail:(Fail)failBlock
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < imageArrays.count; i ++) {
        [self uploadQiNiuServers:imageArrays[i] success:^(NSDictionary *responseObject) {
            [photos addObject:responseObject[@"parameters"]];
            if (i == imageArrays.count - 1) {
                NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestUploadMoreProfile,[UserInfo sharedInstance].uid];
                NSDictionary *parameters = @{@"photo":photos,
                                             @"title":title,
                                             @"content":content,
                                             @"detail_id":moreProfileId
                                             };
                [self putWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
                } failure:^(NSDictionary *responseObject) {
                    
                }];
            }
        } failBlock:^(NSDictionary *responseObject) {
            failBlock(responseObject);
        }];
    }
}

- (void)uploadQiNiuServers:(UIImage *)image
                   success:(Success)successBlock
                 failBlock:(Fail)failBlock
{
    NSString *urlToken = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestUploadPhotoToken];
    [self getWithURLString:urlToken parameters:nil success:^(NSDictionary *responseObject) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSString *timeNow = [self getTimeNow];
        [upManager putData:imageData key:timeNow token:responseObject[@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSDictionary *parameters = @{@"key":resp[@"key"],
                                         @"hash":resp[@"hash"],
                                         @"width":resp[@"image"][@"width"],
                                         @"height":resp[@"image"][@"height"]};
            successBlock(@{@"parameters":parameters});
        } option:nil];
    } failure:^(NSDictionary *responseObject) {
        failBlock(@{@"error":@"上传七牛出错"});
    }];
}

- (void)makeBlackList:(NSString *)otherUid
               succes:(Success)successBlock
                 fail:(Fail)faileBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@%@",RequestBlackList,[UserInfo sharedInstance].uid]];
    NSDictionary *parameters = @{@"black_user":otherUid};
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject);
        }else{
            faileBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        faileBlock(responseObject);
    }];
}

- (void)deleteBlackList:(NSString *)otherUid
                success:(Success)successBlock
                   fail:(Fail)faileBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@%@/black_user/%@",RequestBlackList,[UserInfo sharedInstance].uid,otherUid]];
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"9b594c43-9546-7dc8-caee-3fd1f345edd5" };
    NSDictionary *parameters = @{ @"black_user": otherUid };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        faileBlock(@{@"error":@"error"});
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        successBlock(responseDic[@"content"]);
                                                    }
                                                }];
    [dataTask resume];
}


- (void)getBlackList:(Success)successBlock
                fail:(Fail)failBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@%@",RequestBlackList,[UserInfo sharedInstance].uid]];
    [self getWithURLString:url parameters:nil success:^(NSDictionary *responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject[@"content"][@"black_list"]);
        }
    } failure:^(NSDictionary *responseObject) {
        failBlock(responseObject);
    }];
}

- (void)makeReport:(NSString *)otherUid
            report:(NSString *)reportTheme
            succes:(Success)successBlock
              fail:(Fail)faileBlock
{
    NSString *url = [RequestBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@/%@",RequestReport,[UserInfo sharedInstance].uid]];
    NSDictionary *parameters = @{@"user":otherUid,
                                 @"reason":reportTheme
                                 };
    [self postWithURLString:url parameters:parameters success:^(NSDictionary *responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            successBlock(responseObject);
        }else{
            faileBlock(responseObject);
        }
    } failure:^(NSDictionary *responseObject) {
        faileBlock(responseObject);
    }];
}

- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

@end
