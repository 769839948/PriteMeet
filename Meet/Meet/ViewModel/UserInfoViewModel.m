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

- (void)updateUserInfo:(UserInfo *)model
               success:(Success)successBlock
                  fail:(Fail)failBlock
                    loadingString:(LoadingView)loading
{
    NSDictionary *parameters = @{@"openid":@"WXUserInfo.openid",@"nickname":@"ceshi shuxi",@"sex":@"WXUserInfo.sex",@"head_img_url":@"http://rd.wechat.com/redirect/confirm?block_type=26&url=http%3A%2F%2F7xsatk.com1.z0.glb.clouddn.com%2Fe07ffb0def9cbefd97e2b177e914390b.jpg%3FimageMogr%2Fv2%2Fthumbnail%2F913x651&version=11020201&devicetype=iMac+MacBookPro12%2C1+OSX+OSX+10.11.5+build(15F34)&lang=en&scene=0&pass_ticket=k3dIY9RdsxdpRp6ASoS5R3cMveV2R22iNyn%2BWPPV%2BYOQsNw6OX6GmH%2F7GauDDZzx",@"union_id":@"WXUserInfo.unionid",@"province":@"WXUserInfo.province",@"city":@"WXUserInfo.city",@"country":@"WXUserInfo.country"};
    [self.manager POST:RequestUpdateUser parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

@end
