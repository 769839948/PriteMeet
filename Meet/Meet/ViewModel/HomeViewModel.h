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

- (void)getHomeList:(NSString *)page successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock;

- (void)getOtherUserInfo:(NSString *)userId successBlock:(Success)successBlock failBlock:(Fail)failBlock loadingView:(LoadingView)loadViewBlock;

@end
