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


- (UILabel *)titleLabel{
    if (!_titleLabel) {
//        _titleLabel.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0];
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.layer.contentsScale = 2.0f;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = InterestCollectItemFont;
        [self.contentView addSubview:_titleLabel];
    }
    
    
    return _titleLabel;
}


- (void)filleCellWithFeed:(NSString *)text
{
    self.titleLabel.text = text;
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
