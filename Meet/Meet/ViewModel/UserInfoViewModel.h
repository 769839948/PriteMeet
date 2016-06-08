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

- (void)addEduExperent:(NSString *)workString
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;

- (void)updateEduExp:(NSString *)eduString
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading;

- (void)addWorkExperent:(NSString *)workString
               success:(Success)successBlock
                  fail:(Fail)failBlock
          loadingString:(LoadingView)loading;

- (void)updateWorkExperent:(NSString *)workString
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
