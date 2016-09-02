//
//  MeetInfoTableViewCell.h
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseTableViewCell.h"
@class HomeDetailModel;

@interface MeetInfoTableViewCell : BaseTableViewCell

- (void)configCell:(NSString *)name position:(NSString *)position meetNumber:(NSString *)meetNumber interestCollectArray:(NSArray *)interstArray autotnInfo:(NSString *)autnInfo;

@end
