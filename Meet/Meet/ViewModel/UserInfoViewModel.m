//
//  UserInfoModel.m
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UserInfoViewModel.h"
#import "UserInfo.h"

@implementation UserInfoViewModel

- (void)updateUserInfo:(UserInfo *)userInfo
               success:(Success)successBlock
                  fail:(Fail)failBlock
                    loadingString:(LoadingView)loading
{
//    loading(@"更新个人资料");
    NSDictionary *parameters = @{@"openid":userInfo.userId,@"nickname":userInfo.name,@"gender":userInfo.sex,@"head_img_url":userInfo.headimgurl,@"province":userInfo.country,@"city":userInfo.city,@"income":userInfo.income,@"height":userInfo.height,@"birthday":userInfo.brithday,@"mobile_num":userInfo.phoneNo,@"weixin_num":userInfo.WX_No,@"hometown":userInfo.home,@"industry_id":userInfo.country,@"affection":userInfo.state,@"real_name":userInfo.name};
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

@end
