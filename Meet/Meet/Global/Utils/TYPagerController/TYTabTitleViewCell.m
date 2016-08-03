//
//  TYTabTitleViewCell.m
//  TYPagerControllerDemo
//
//  Created by tany on 16/5/4.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "TYTabTitleViewCell.h"

@interface TYTabTitleViewCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *numberLabel;
@end

@implementation TYTabTitleViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
        [self addTabNumberLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
        [self addTabNumberLabel];
    }
    return self;
}

- (void)addTabTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)addTabNumberLabel
{
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.font = [UIFont systemFontOfSize:8];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
    numberLabel.layer.cornerRadius = 7;
    numberLabel.layer.masksToBounds = YES;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numberLabel];
    _numberLabel = numberLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.contentView.bounds;
    _titleLabel.frame = frame;
    _numberLabel.frame = CGRectMake(frame.size.width - 20, frame.origin.y + 7, 20, 14);
}

@end
