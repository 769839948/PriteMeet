//
//  AppDelegate+AMapLocation.m
//  Meet
//
//  Created by Zhang on 6/23/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "AppDelegate+AMapLocation.h"
#import <AMapFoundationKit/AMapServices.h>

@implementation AppDelegate (AMapLocation)

- (void)setAMapServers
{
    [AMapServices sharedServices].apiKey = GAODEMapKey;
}


@end
