//
//  LoginViewModel.h
//  Meet
//
//  Created by Zhang on 6/3/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"
#import "WXUserInfo.h"
#import "PSWView.h"

@interface LoginViewModel : BaseRequestViewModel

/**
 *  上传登录信息
 *
 *  @param WXUserInfo   微信登录信息/微博登录信息
 *  @param code         邀请码
 *  @param successBlock 成功返回Block
 *  @param failBlock    失败Block
 *  @param loading      网络加载Loading
 */
- (void)postWXUserInfo:(WXUserInfo *)WXUserInfo
              withCode:(NSString *)code
               Success:(Success)successBlock
                  Fail:(Fail)failBlock
            showLoding:(LoadingView)loading;

/**
 *  老用户登录
 *
 *  @param uid          用户的uid
 */
- (void)oldUserLogin:(NSString *)uid
             Success:(Success)successBlock
                Fail:(Fail)failBlock
          showLoding:(LoadingView)loading;

/**
 *  邀请码检测
 *
 *  @param code         邀请码
 */
- (void)checkCode:(NSString *)code
          Success:(Success)successBlock
             Fail:(Fail)failBlock
       showLoding:(LoadingView)loading;

/**
 *  发送短信验证码
 *
 *  @param mobile       手机号码
 *  @param successBlock successBlock description
 *  @param failBlock    failBlock description
 */
- (void)senderSms:(NSString *)mobile
          success:(Success)successBlock
             Fail:(Fail)failBlock;


/**
 *  新接口登录
 *
 *  @param mobile       mobile description
 *  @param code         code description
 *  @param successBlock successBlock description
 *  @param failBlock    failBlock description
 */
- (void)loginSms:(NSString *)mobile
            code:(NSString *)code
         success:(Success)successBlock
            fail:(Fail)failBlock;

/**
 *  手机号登录
 *
 *  @param mobile       手机号
 *  @param code         验证码
 *  @param successBlock successBlock description
 *  @param failBlock    failBlock description
 */
- (void)loginSms:(NSString *)mobile
            code:(NSString *)code
       applyCode:(NSString *)applyCode
         success:(Success)successBlock
            fail:(Fail)failBlock;
/**
 *  获取用户信息
 *
 *  @param openId       用户的openId.uid(相当于用户的一个固定标识)
 */
- (void)getUserInfo:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading;

/**
 *  申请邀请码
 *
 *  @param userInfo     用户基本信息
 *  @param workExps     用户工作经历信息
 *  @param eduExps      用户教育信息
 */
- (void)applyCode:(UserInfo *)userInfo
        workArray:(NSArray *)workExps
         eduArray:(NSArray *)eduExps
          Success:(Success)successBlock
             Fail:(Fail)failBlock
       showLoding:(LoadingView)loading;

@end
