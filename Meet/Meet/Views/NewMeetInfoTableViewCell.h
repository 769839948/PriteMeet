//
//  NewMeetInfoTableViewCell.h
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, CollectionViewItemStyle) {
    ItemWhiteColorAndBlackBoard = 0,
    ItemBlackAndWhiteLabelText,
    ItemOrginAndWhiteLabelText,
    ItemWhiteBoardOrginBacground,
    ItemWhiteBacAndGrateText,
    ItemOriginBacAndWhiteText
};

typedef void (^tableCellHeight)(CGFloat height);

@interface NewMeetInfoTableViewCell : BaseTableViewCell


@property (nonatomic,strong) tableCellHeight block;

- (void)configCell:(NSString *)meetstring
             array:(NSArray *)array
          andStyle:(CollectionViewItemStyle)style;

- (void)isHaveShadowColor:(BOOL)isShadowColor;

- (void)hidderLine;

@end
