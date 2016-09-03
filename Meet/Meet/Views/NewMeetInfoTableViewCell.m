//
//  NewMeetInfoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "NewMeetInfoTableViewCell.h"
#import "InterestCollectView.h"
#import "Masonry.h"
#import "NSString+StringSize.h"
#import "EqualSpaceFlowLayout.h"

#define MeetLabelColor @"#4D4D4D"

@interface NewMeetInfoTableViewCell ()

@property (nonatomic, strong) InterestCollectView *interestView;
@property (nonatomic, strong) UILabel *meetLabel;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) EqualSpaceFlowLayout *flowLayout;

@property (nonatomic, assign) BOOL isBlock;

@end

@implementation NewMeetInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isBlock = YES;
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, ScreenWidth - 40, 0.5)];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
        [self.contentView addSubview:_lineLabel];
    }
    
    //确定是水平滚动，还是垂直滚动
    _flowLayout = [[EqualSpaceFlowLayout alloc] init];
    _interestView = [[InterestCollectView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _interestView.userInteractionEnabled = NO;
    _flowLayout.delegate = _interestView;
    [self.contentView addSubview:_interestView];
    
    _meetLabel = [[UILabel alloc] init];
    _meetLabel.textColor = [UIColor colorWithHexString:AboutUsLabelColor];
    _meetLabel.numberOfLines = 0;
    _meetLabel.font = AboutUsLabelFont;
    [self.contentView addSubview:_meetLabel];
    
    [self updateConstraints];
}

- (void)configCell:(NSString *)meetstring
             array:(NSArray *)array
          andStyle:(CollectionViewItemStyle)style
{
    _meetLabel.text = meetstring;
    [_interestView setCollectViewData:array style:style];
    if ([meetstring isEqualToString:@""]) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.meetLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.000001);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(0.01);
        }];
        [weakSelf.interestView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset([weakSelf cellHeight:array]);
        }];
    }else{
        float titleHeight = [meetstring heightWithFont:AboutUsLabelFont constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 40];
        __weak typeof(self) weakSelf = self;
        [weakSelf.interestView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset([weakSelf cellHeight:array]);
        }];
        
        [weakSelf.meetLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(titleHeight);
        }];
    }
    [self.contentView bringSubviewToFront:_interestView];
    [self updateConstraintsIfNeeded];
    [self updateConstraints];
}

- (void)isHaveShadowColor:(BOOL)isShadowColor
{
    if (!isShadowColor) {
        [self setWhiteView:NO isBottom:NO];
    }else{
        [self setWhiteView:YES isBottom:YES];
    }
}

- (void)hidderLine
{
    _lineLabel.hidden = YES;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_interestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(20);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.meetLabel.mas_top).offset(-20);
        }];
        [_meetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.interestView.mas_bottom).offset(20);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-30);
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}


- (CGFloat)cellHeight:(NSArray *)interArray
{
    CGFloat yOffset = 30;
    CGFloat allSizeWidth = 0;
    for (NSInteger idx = 0; idx < interArray.count; idx++) {
        CGSize itemSize = CGSizeMake([self cellWidth:[interArray objectAtIndex:idx]], 30);
        allSizeWidth = allSizeWidth + itemSize.width + 10;
        if (allSizeWidth > ScreenWidth - 40) {
            yOffset = yOffset + 40;
            allSizeWidth = itemSize.width + 10;
        }
    }
    return yOffset;
}

- (CGFloat)cellWidth:(NSString *)itemString
{
    CGFloat cellWidth;
    cellWidth = [itemString widthWithFont:[UIFont systemFontOfSize:13.0] constrainedToHeight:18];
    return cellWidth + 18;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

@end
