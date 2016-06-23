//
//  HomeMdoel.h
//  Meet
//
//  Created by Zhang on 6/15/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cover_photo;
@interface Cover_photo : NSObject

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, assign) long long id;

@end


@interface HomeModel : NSObject

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, copy) Cover_photo *cover_photo;

@property (nonatomic, copy) NSString *job_label;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *laititude;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *longtitude;

@property (nonatomic, copy) NSString *personal_label;

@end
