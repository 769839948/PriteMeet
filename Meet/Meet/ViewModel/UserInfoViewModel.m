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

@implementation UserInfoViewModel

- (NSArray *)imageArray
{
    return @[@"me_newmeet",@"me_ attestation",@"me_mymeet",@"me_wantmeet",@"me_addfriends"];
}
- (NSArray *)titleArray
{
    return @[@"最新邀约",@"身份认证",@"我的约见",@"想见的人",@"邀请朋友"];
}


- (void)updateUserInfo:(UserInfo *)userInfo
        withStateArray:(NSDictionary *)dic
               success:(Success)successBlock
                  fail:(Fail)failBlock
                    loadingString:(LoadingView)loading
{
//    loading(@"更新个人资料");
    NSDictionary *parameters = @{ @"real_name": userInfo.real_name, @"gender":[NSString stringWithFormat:@"%ld",(long)userInfo.gender],@"mobile_num": userInfo.mobile_num,@"avatar": userInfo.avatar, @"birthday": userInfo.birthday, @"weixin_num": userInfo.weixin_num,@"country": userInfo.country,@"location":userInfo.location,@"hometown":userInfo.hometown,@"affection":[NSString stringWithFormat:@"%ld",(long)userInfo.affection],@"height":[NSString stringWithFormat:@"%ld",(long)userInfo.height],@"income":[NSString stringWithFormat:@"%ld",(long)userInfo.income],@"constellation":[NSString stringWithFormat:@"%ld",(long)userInfo.constellation],@"industry":[NSString stringWithFormat:@"%ld",(long)userInfo.industry],@"job_label":userInfo.job_label};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestUpdateUser,[WXUserInfo shareInstance].openid];

    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
    }];
}

- (void)updateEduExp:(NSString *)eduString
           witheduId:(NSString *)eduId
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading
{
    NSArray *array = [eduString componentsSeparatedByString:@"-"];
    NSDictionary *parameters = @{ @"graduated": array[0], @"major":array[1],@"education":[[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"education"] objectForKey:array[2]],@"user_id":[WXUserInfo shareInstance].openid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestAddEduExp,eduId];
    
    [self.manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
    }];
}

- (void)addEduExperent:(NSString *)workString
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading
{
    //    loading(@"更新个人资料");
    NSArray *array = [workString componentsSeparatedByString:@"-"];
    NSDictionary *parameters = @{ @"graduated": array[0], @"major":array[1],@"education":[[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"education"] objectForKey:array[2]],@"user_id":[WXUserInfo shareInstance].openid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestAddEduExp];
    
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
    }];
}


- (void)updateWorkExperent:(NSString *)workString withWorkId:(NSString *)workId
                success:(Success)successBlock
                   fail:(Fail)failBlock
          loadingString:(LoadingView)loading
{
    NSArray *array = [workString componentsSeparatedByString:@"-"];
    NSDictionary *parameters = @{ @"company_name": array[0], @"profession":array[1],@"income":@0,@"user_id":[WXUserInfo shareInstance].openid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestAddWorkExp,workId];
    [self.manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
    }];
}

- (void)deleteWorkExperent:(NSString *)workId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestAddWorkExp,workId];
    [self.manager DELETE:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});

    }];
}

- (void)deleteEduExperent:(NSString *)eduId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@/%@",RequestAddEduExp,eduId];
    [self.manager DELETE:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
        
    }];
}


- (void)addWorkExperent:(NSString *)workString
                success:(Success)successBlock
                   fail:(Fail)failBlock
          loadingString:(LoadingView)loading
{
    NSArray *array = [workString componentsSeparatedByString:@"-"];
    NSDictionary *parameters = @{ @"company_name": array[0], @"profession":array[1],@"income":@0,@"user_id":[WXUserInfo shareInstance].openid};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestAddWorkExp];
    
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
    }];
}

- (void)getUserInfo:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading
{
    loading(@"获取个人信息中");
    NSDictionary *parameters = @{@"openId":openId};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestGetUserInfo];

    [self.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock(responseObject);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"":@""});
    }];
}

- (void)uploadImage:(UIImage *)image openId:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading
{
    loading(@"用户信息保存中");
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestUploadUserPhoto,openId];

//    NSString *url = [RequestUploadUserPhoto stringByAppendingString:openId];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [self.manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"123456.jpg" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"上传失败"});
    }];

}

- (void)updateEduUserInfo:(UserInfo *)model
                  success:(Success)successBlock
                     fail:(Fail)failBlock
            loadingString:(LoadingView)loading
{
//    NSDictionary *parameters = @{@"openid":userInfo.userId,@"nickname":userInfo.name,@"gender":userInfo.sex,@"head_img_url":userInfo.headimgurl,@"province":userInfo.country,@"city":userInfo.city,@"income":userInfo.income,@"height":userInfo.height,@"birthday":userInfo.brithday,@"mobile_num":userInfo.phoneNo,@"weixin_num":userInfo.WX_No,@"hometown":userInfo.home,@"industry_id":userInfo.country,@"affection":userInfo.state,@"real_name":userInfo.name};
    NSDictionary *parameters = @{};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@",RequestUpdateUser];
    
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
    }];
}
- (void)addStar:(NSString *)description
        success:(Success)successBlock
           fail:(Fail)failBlock
  loadingString:(LoadingView)loading
{
    NSDictionary *parameters = @{@"description":description};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestAddStar,[WXUserInfo shareInstance].openid];
    
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
    }];
}

- (void)getMoreExtInfo:(NSString *)openId
        success:(Success)successBlock
           fail:(Fail)failBlock
  loadingString:(LoadingView)loading
{
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestExtINfo,[WXUserInfo shareInstance].openid];
//    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@o4pNpvxA5YQDVsgjmiQ07ChzMtms",RequestExtINfo];
    
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock([responseObject objectForKey:@"user_info"]);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"":@""});
    }];
}


- (void)uploadInvite:(NSString *)description
           themeArray:(NSArray *)themeArray
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading
{

    NSString *them = @"";
    for (NSString *themeString in themeArray) {
        NSDictionary *invitationDic = [[ProfileKeyAndValue shareInstance].appDic objectForKey:@"invitation"];
        them = [them stringByAppendingString:[NSString stringWithFormat:@"%@,",[[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"invitation"]objectForKey:themeString]]];
    }
    NSString *subLastString = [them substringToIndex:them.length - 1];
    NSDictionary *parameters = @{ @"description":description, @"theme":subLastString};
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestInviteInfo,[WXUserInfo shareInstance].openid];
    
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }else{
            failBlock(@{@"error":@"error"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"error":@"error"});
    }];
}

- (void)getInvite:(Success)successBlock
             fail:(Fail)failBlock
    loadingString:(LoadingView)loading
{
    
    NSString *url = [RequestBaseUrl stringByAppendingFormat:@"%@%@",RequestInviteInfo,[WXUserInfo shareInstance].openid];
    
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            successBlock([responseObject objectForKey:@"results"]);
        }else{
            failBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(@{@"":@""});
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

@end
