//
//  AppGlobalData.h
//  Meet
//
//  Created by Zhang on 23/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppGlobalData : NSObject

@property (nonatomic, strong) NSMutableDictionary *homeListDic;

@property (nonatomic, strong) NSMutableDictionary *homeDetailDic;

@property (nonatomic, strong) NSMutableDictionary *meInfoDic;

+ (instancetype)sharedInstance;

@end
