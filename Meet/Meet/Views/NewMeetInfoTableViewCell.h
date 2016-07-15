//
//  NewMeetInfoTableViewCell.h
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void (^tableCellHeight)(CGFloat height);

@interface NewMeetInfoTableViewCell : BaseTableViewCell


@property (nonatomic,strong) tableCellHeight block;

- (void)configCell:(NSString *)meetstring array:(NSArray *)array;
- (void)isHaveShadowColor:(BOOL)isShadowColor;

@end
