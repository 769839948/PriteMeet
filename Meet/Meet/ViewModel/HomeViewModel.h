//
//  HomeViewModel.h
//  Meet
//
//  Created by Zhang on 6/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseRequestViewModel.h"

@interface HomeViewModel : BaseRequestViewModel

@property (nonatomic, copy) NSArray *meetDetailImageArray;
@property (nonatomic, copy) NSArray *meetDetailtitleArray;


- (NSArray *)baseInfoTitle;
- (NSArray *)sectionTitle;


/**
 *  用户筛选接口========两种筛选方式距离和智能推荐
 *
 *  @param page          分页显示
 *  @param latitude      latitude description
 *  @param longitude     longitude description
 *  @param filterName    筛选的方式（智能推荐、按距离排序）
 */
//- (void)getHomeFilterList:(NSString *)page
//                 latitude:(double)latitude
//                longitude:(double)longitude
//                   filter:(NSString *)filterName
//             successBlock:(Success)successBlock
//                failBlock:(Fail)failBlock
//              loadingView:(LoadingView)loadViewBlock;


- (void)getDataFilterList:(NSString *)page
                filterUrl:(NSString *)url
             successBlock:(Success)successBlock
                failBlock:(Fail)failBlock;



- (void)getindexIndustry:(Success)successBlock
               failBlock:(Fail)failBlock;
/**
 *  获取他人用户信息
 *
 *  @param userId        他人用户uid
 *  @param successBlock  successBlock description
 *  @param failBlock     failBlock description
 *  @param loadViewBlock loadViewBlock description
 */
- (void)getOtherUserInfo:(NSString *)userId
            successBlock:(Success)successBlock
               failBlock:(Fail)failBlock
             loadingView:(LoadingView)loadViewBlock;

/**
 *  获取他人更多信息接口
 *
 *  @param userId        userId description
 *  @param successBlock  successBlock description
 *  @param failBlock     failBlock description
 *  @param loadViewBlock loadViewBlock description
 */
- (void)getOtherUserInfoProfile:(NSString *)userId
                   successBlock:(Success)successBlock
                      failBlock:(Fail)failBlock
                    loadingView:(LoadingView)loadViewBlock;

/**
 *  获取所有字典
 *
 *  @param successBlock successBlock description
 *  @param failBlock    failBlock description
 */
- (void)getDicMap:(Success)successBlock
        failBlock:(Fail)failBlock;




/**
 *  获取所有文案
 *
 *  @param sucessBlock <#sucessBlock description#>
 *  @param failBlock   <#failBlock description#>
 */
- (void)getAllPlachText:(Success)sucessBlock
              failBlock:(Fail)failBlock;

/**
 *  发送经纬度
 *
 *  @param latitude  latitude description
 *  @param longitude longitude description
 */
- (void)senderLocation:(double)latitude
             longitude:(double)longitude;
/**
 *  发送ip地址经纬度
 *
 *  @param successblock successblock description
 *  @param failBlock    failBlock description
 */
- (void)senderIpAddress:(Success)successblock
                   fail:(Fail)failBlock;



@end
