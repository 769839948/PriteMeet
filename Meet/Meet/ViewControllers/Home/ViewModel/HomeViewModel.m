//
//  HomeViewModel.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (NSArray *)meetDetailImageArray
{
    return @[@"meetdetail_aboutus",@"meetdetail_newmeet",@"meetdetail_wantmeet"];
}

- (NSArray *)meetDetailtitleArray
{
    return @[@"关于我们的那些事",@"最新邀约",@"更多想见的人"];
}

@end
