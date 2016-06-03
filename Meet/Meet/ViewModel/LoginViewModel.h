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
                                 Success:(Success)successBlock
                                    Fail:(Fail)failBlock
                              showLoding:(LoadingView)loading;

- (void)oldUserLogin:(WXUserInfo *)WXUserInfo
             Success:(Success)successBlock
                Fail:(Fail)failBlock
          showLoding:(LoadingView)loading;

- (void)checkCode:(NSString *)code
          Success:(Success)successBlock
             Fail:(Fail)failBlock
               showLoding:(LoadingView)loading;

@end
