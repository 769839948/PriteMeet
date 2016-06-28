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
#define  RequestBaseUrl              @"http://momeet.cn"   //http://django.senzapps.cc/
#define  RequestCreateUser           @"/api/user/signup/"
#define  RequestCheckUser            @"/api/user/check/"
#define  RequestUpdateUser           @"/api/user/base_info/"
#define  RequestCheckInvitationCode  @"/api/code/check/"
#define  RequestGetUserInfo          @"/api/user/base_info/"
#define  RequestUploadUserPhoto      @"/api/user_avatar/"
#define  RequestUploadPhotoToken     @"/api/upload_token/"

#define  RequestSenderLocation       @"/api/push_geo_location"

#define  RequestLastUpdate           @"/api/user_updated_at/"

#define  RequestAddWorkExp           @"/api/user/work_info"
#define  RequestAddEduExp            @"/api/user/edu_info"

#define  RequestAddStar              @"/api/user/description/"
#define  RequestExtINfo              @"/api/user/ext_info/"
#define  RequestInviteInfo           @"/api/user_engagement_activity/"

#define  RequestGetHomeList          @"/api/user/list"

#define  RequestGetOtherInfo         @"/api/user/info"

#endif /* RequestUrl_h */
