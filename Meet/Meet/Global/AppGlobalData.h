//
//  AppGlobalData.h
//  Meet
//
//  Created by Zhang on 23/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppGlobalData : NSObject

@property (nonatomic, copy) NSMutableDictionary *homeListDic;

+ (instancetype)sharedInstance;

@end
