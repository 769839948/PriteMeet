//
//  UserInfoModel.h
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"

@interface UserInfoViewModel : BaseRequestViewModel

- (void)updateUserInfo:(UserInfo *)model
        withStateArray:(NSDictionary *)dic
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;

- (void)updateEduUserInfo:(UserInfo *)model
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;


- (void)getUserInfo:(NSString *)openId
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;

- (void)uploadImage:(UIImage *)image openId:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading;
@end
