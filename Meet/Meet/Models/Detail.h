//
//  Detail.h
//  Meet
//
//  Created by Zhang on 7/25/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos.h"

@interface Detail : NSObject

@property (nonatomic, assign) long long id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<Photos *> *photo;

@end

