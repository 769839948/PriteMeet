//
//  RequestUrl.h
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#ifndef RequestUrl_h
#define RequestUrl_h

/**
 *  后台请求数据URL存放处
 */
//微信登陆后发送微信信息给后台服务器
#define  RequestBaseUrl              @"http://senzapps.cc/"
#define  RequestCreateUser           @"api/account/user/signin"
#define  RequestCheckUser            @"api/account/user/check"
#define  RequestUpdateUser           @"api/account/user/update"
#define  RequestCheckInvitationCode  @"api/invitation/check/"
#define  RequestGetUserInfo          @"api/user/base_info/"
#define  RequestUploadUserPhoto      @"api/user/avatar/"
#endif /* RequestUrl_h */
