//
//  UserInfoModel.h
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"
#import "UserInfo.h"

typedef void (^returnImage)(UIImage *image);

@interface UserInfoViewModel : BaseRequestViewModel

- (NSArray *)imageArray;
- (NSArray *)titleArray;

- (NSArray *)sectionTitle;
- (NSArray *)sectionButtonTitle;

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
           witheduId:(NSString *)eduId
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading;


- (void)addWorkExperent:(NSString *)workString
               success:(Success)successBlock
                  fail:(Fail)failBlock
          loadingString:(LoadingView)loading;

- (void)updateWorkExperent:(NSString *)workString
                withWorkId:(NSString *)workId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading;

- (void)deleteWorkExperent:(NSString *)workId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading;

- (void)deleteEduExperent:(NSString *)eduId
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

- (void)addStar:(NSString *)description
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading;

- (void)getMoreExtInfo:(NSString *)openId
           success:(Success)successBlock
              fail:(Fail)failBlock
     loadingString:(LoadingView)loading;

- (void)getInvite:(Success)successBlock
             fail:(Fail)failBlock
    loadingString:(LoadingView)loading;

- (void)uploadInvite:(NSString *)description
          themeArray:(NSArray *)themeArray
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading;


- (void)lastModifield:(void (^)(NSString *time))lastBlock failBlock:(Fail)failBock;

+ (void)saveCacheImage:(NSString *)url
       completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;

@end
