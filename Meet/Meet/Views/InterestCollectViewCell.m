//
//  InterestCollectViewCell.m
//  Demo
//
//  Created by Zhang on 6/1/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import "InterestCollectViewCell.h"
#import "Masonry.h"
#import "NSString+StringSize.h"

@interface InterestCollectViewCell ()

@property (nonatomic, strong) UILabel *intersLabel;
@property (nonatomic, assign) BOOL isHeightCaculated;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation InterestCollectViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.layer.contentsScale = 2.0f;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = InterestCollectItemFont;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)filleCellWithFeed:(NSString *)text type:(CollectionViewItemStyle)type
{
    self.titleLabel.frame = CGRectMake(7, 0, [self cellWidth:text] + 18, 30);
    
    if (type == ItemWhiteColorAndBlackBoard) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = InterestCollectItemFont;
        self.layer.borderColor = [[UIColor colorWithHexString:HomeDetailViewNameColor] CGColor];
        self.layer.borderWidth = 1;
    }else if (type == ItemBlackAndWhiteLabelText){
        self.backgroundColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = InterestCollectItemFont;
        if (ScreenWidth == 414) {
            self.titleLabel.frame = CGRectMake(7, -15, [self cellWidth:text] + 18, 60);
        }
    }else if (type == ItemWhiteBoardOrginBacground) {
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 1;
        self.titleLabel.font = InterestCollectItemFont;
        self.backgroundColor = [UIColor colorWithHexString:AppointMentBackGroundColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }else if (type == ItemOriginBacAndWhiteText) {
        self.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = InterestCollectItemFont;
        self.isSelect = YES;
    }else if (type == ItemWhiteBacAndGrateText) {
        self.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelect];
        self.titleLabel.textColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelectColor];
        self.titleLabel.font = InterestCollectItemFont;
        self.isSelect = NO;
    }
    self.titleLabel.text = text;
    [self updateConstraintsIfNeeded];
}

- (void)filleCellSelect:(BOOL)select
{
    if (select) {
        self.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.isSelect = YES;
    }else{
        self.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelect];
        self.titleLabel.textColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelectColor];
        self.isSelect = NO;
    }
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if (!self.isHeightCaculated) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
        CGRect newSize = layoutAttributes.frame;
        newSize.size.width = size.width;
        newSize.size.height = size.height;
        self.isHeightCaculated = YES;
    }
    return layoutAttributes;
}

- (CGFloat)cellWidth:(NSString *)itemString
{
    CGFloat cellWidth;
    cellWidth = [itemString widthWithFont:InterestCollectItemFont constrainedToHeight:18];
    return cellWidth;
}


@end
