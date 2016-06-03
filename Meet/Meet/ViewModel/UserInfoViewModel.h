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
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;

@end
