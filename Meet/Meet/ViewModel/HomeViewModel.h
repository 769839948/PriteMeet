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

- (void)getHomeList:(NSString *)page latitude:(double)latitude  longitude:(double)longitude successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock;

- (void)getHomeFilterList:(NSString *)page latitude:(double)latitude  longitude:(double)longitude filter:(NSString *)filterName successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock;

- (void)getOtherUserInfo:(NSString *)userId successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock;

- (void)getOtherUserInfoProfile:(NSString *)userId successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock;

- (void)getDicMap:(Success)successBlock failBlock:(Fail)failBlock;

- (void)senderLocation:(double)latitude  longitude:(double)longitude;

- (void)senderIpAddress:(Success)successblock fail:(Fail)failBlock;

@end
