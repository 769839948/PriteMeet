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
#define  RequestBaseUrl              @"http://test.momeet.cn"   //http://django.senzapps.cc/
#define  RequestCreateUser           @"/api/user/signup/"
#define  RequestCheckUser            @"/api/user/check/"
#define  RequestCheckCodeBindUser    @"/api/code/is_bound_user/"
#define  RequestUpdateUser           @"/api/user/base_info/"
#define  RequestCheckInvitationCode  @"/api/code/check/"
#define  RequestGetUserInfo          @"/api/user/base_info/"
#define  RequestApplyCode            @"/api/client_get_code/"
#define  RequestUploadUserPhoto      @"/api/user_avatar/"
#define  RequestUploadPhotoToken     @"/api/upload_token/"
#define  RequestBlackList            @"/api/black_list/"
#define  RequestGetBlackList         @"/api/black_list/"
#define  RequestReport               @"/api/report_user"
#define  RequestGetSmsCoe            @"/api/send_sms"
#define  RequsetMobileLogin          @"/api/user/login/"

#define  RequestLikeList             @"/api/liked_list/"


#define  RequestUploadMoreProfile    @"/api/user_detail/"
#define  RequestUploadCoverPhoto     @"/api/user_cover_photo/"

#define  RequestSenderLocation       @"/api/push_geo_location"

#define  RequestLastUpdate           @"/api/user_updated_at/"

#define  RequestAddWorkExp           @"/api/user/work_info"
#define  RequestAddEduExp            @"/api/user/edu_info"

#define  RequestExtINfo              @"/api/user/ext_info/"
#define  RequestInviteInfo           @"/api/user_engagement_activity/"

#define  RequestGetHomeList          @"/api/user/list"

#define  RequestGetOtherInfo         @"/api/user/info"

#define  RequestGetOtherInfoProfile  @"/api/user/base_info_variant/"

#define  RequestGetFilterUserList    @"/api/user/list_filter/"

#define  RequestGetInviteItems       @"/api/user_engagement_theme/"

#define  RequestGetService           @"/api/customer_service/"

#define  RequestGetDicMap            @"/api/dict_map/"

#define  RequestLikeUser             @"/api/like/"

//订单接口
#define  RequestApplyAppointment     @"/api/apply_for_appointment/"

#define  RequestPayUrl               @"/api/payUrl/"

//根据订单号查询订单详情
#define  RequestApiOrder             @"/api/order"

#define  RequestUserAppoitment       @"/api/check_appointment_order/"

#define  RequestAcceptAppointMent    @"/api/accept_appointment"

#define  RequestSwitchAppointMent    @"/api/switch_appointment_status"

#define  RequestRejectReson          @"/api/reject_reason_dict/"

#define  RequestNumberOrder          @"/api/appointment_order_count/"

#define  RequestPlachText            @"/api/document_map/"

//http://momeet.cn/api/dict_map/
//http://momeet.cn/api/document_map/
#endif /* RequestUrl_h */
