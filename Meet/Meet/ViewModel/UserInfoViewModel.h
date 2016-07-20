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
/**
 *  更新个人信息
 *
 *  @param model        更新的用户信息模型
 */
- (void)updateUserInfo:(UserInfo *)model
        withStateArray:(NSDictionary *)dic
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;
/**
 *  添加教育信息
 *
 *  @param workString   教育字符串
 */
- (void)addEduExperent:(NSString *)workString
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;

/**
 *  更新教育信息
 *
 *  @param eduString    教育字符串
 *  @param eduId        教育id
 */
- (void)updateEduExp:(NSString *)eduString
           witheduId:(NSString *)eduId
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading;

/**
 *  添加工作信息
 *
 *  @param workString   工作字符串
 */
- (void)addWorkExperent:(NSString *)workString
               success:(Success)successBlock
                  fail:(Fail)failBlock
          loadingString:(LoadingView)loading;
/**
 *  更新工作信息
 *
 *  @param workString   工作字符串
 *  @param workId       工作id
 */
- (void)updateWorkExperent:(NSString *)workString
                withWorkId:(NSString *)workId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading;
/**
 *  删除工作信息
 *
 *  @param workId       工作id
 */
- (void)deleteWorkExperent:(NSString *)workId
                   success:(Success)successBlock
                      fail:(Fail)failBlock
             loadingString:(LoadingView)loading;
/**
 *  删除教育信息
 *
 *  @param eduId        教育id
 */
- (void)deleteEduExperent:(NSString *)eduId
                  success:(Success)successBlock
                     fail:(Fail)failBlock
            loadingString:(LoadingView)loading;
/**
 *  获取用户信息
 *
 *  @param openId       用户openid
 */
- (void)getUserInfo:(NSString *)openId
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading;
/**
 *  上传图片到七牛服务器
 *
 *  @param image        图片
 *  @param isApplyCode  是否申请邀请码界面
 */
- (void)uploadImage:(UIImage *)image
        isApplyCode:(BOOL)isApplyCode
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading;

/**
 *  添加个人亮点
 *
 *  @param description  个人亮点字符串
 */
- (void)addStar:(NSString *)description
            success:(Success)successBlock
               fail:(Fail)failBlock
      loadingString:(LoadingView)loading;
/**
 *  获取个人更多信息
 *
 *  @param openId       用户id
*/
- (void)getMoreExtInfo:(NSString *)openId
               success:(Success)successBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;

/**
 *  获取邀约信息
 */
- (void)getInvite:(Success)successBlock
             fail:(Fail)failBlock
    loadingString:(LoadingView)loading;

/**
 *  更新邀约信息
 *
 *  @param description  邀约说明
 *  @param themeArray   邀约主题
 *  @param isActive     是否开启邀约
 */
- (void)uploadInvite:(NSString *)description
          themeArray:(NSArray *)themeArray
            isActive:(BOOL)isActive
             success:(Success)successBlock
                fail:(Fail)failBlock
       loadingString:(LoadingView)loading;

/**
 *  获取所有可以选择的邀约
 */
- (void)getAllInviteAllItems:(Success)successBlock
                        fail:(Fail)failBlock
               loadingString:(LoadingView)loading;

/**
 *  最后一次更新数据时间
 */
- (void)lastModifield:(void (^)(NSString *time))lastBlock failBlock:(Fail)failBock;

/**
 *  保存图片
 *
 *  @param url             图片地址
 *  @param completionBlock 返回成功回调
*/
+ (void)saveCacheImage:(NSString *)url
       completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
                  fail:(Fail)failBlock
         loadingString:(LoadingView)loading;

@end
