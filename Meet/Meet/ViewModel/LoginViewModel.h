//
//  LoginViewModel.h
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"
#import "WXUserInfo.h"

@interface LoginViewModel : BaseRequestViewModel

- (void)postWXUserInfo:(WXUserInfo *)WXUserInfo
                            withCode:(NSString *)code
                                 Success:(Success)successBlock
                                    Fail:(Fail)failBlock
                              showLoding:(LoadingView)loading;

- (void)oldUserLogin:(NSString *)uid
             Success:(Success)successBlock
                Fail:(Fail)failBlock
          showLoding:(LoadingView)loading;

- (void)checkCode:(NSString *)code
          Success:(Success)successBlock
             Fail:(Fail)failBlock
               showLoding:(LoadingView)loading;

- (void)getUserInfo:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading;


- (void)applyCode:(UserInfo *)userInfo
        workArray:(NSArray *)workExps
         eduArray:(NSArray *)eduExps
          Success:(Success)successBlock
             Fail:(Fail)failBlock
       showLoding:(LoadingView)loading;

@end
