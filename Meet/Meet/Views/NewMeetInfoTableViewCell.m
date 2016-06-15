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
#define MeetLabelFont 

@interface NewMeetInfoTableViewCell ()

@property (nonatomic, strong) InterestCollectView *interestView;
@property (nonatomic, strong) UILabel *meetLabel;

@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation NewMeetInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setWhiteView:YES isBottom:YES];
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
    EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
    
    _interestView = [[InterestCollectView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    flowLayout.delegate = _interestView;
    //    [_interestView setCollectViewData:@[@"旅行顾问",@"创意总监",@"谈判专家",@"顾问"]];
    [self.contentView addSubview:_interestView];
    
    _meetLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 20, 200)];
    _meetLabel.textColor = [UIColor colorWithHexString:AboutUsLabelColor];
    _meetLabel.numberOfLines = 0;
    _meetLabel.font = AboutUsLabelFont;
    [self.contentView addSubview:_meetLabel];
    
    [self updateConstraints];
}

- (void)configCell:(NSString *)meetstring array:(NSArray *)array
{
    _meetLabel.text = meetstring;
    [_interestView setCollectViewData:array];
    NSString *instresTitleString = @"  ";
    for (NSString *instrestTitle in array) {
        instresTitleString = [instresTitleString stringByAppendingString:instrestTitle];
        instresTitleString = [instresTitleString stringByAppendingString:@"   "];
    }
    float instrestHeight = [instresTitleString heightWithFont:[UIFont fontWithName:@"PingFangSC-Light" size:23.0f] constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
    //    float height = [flowLayout collectionViewContentSize].height;
    //    NSLog(@"---------%f",height);
    
    float titleHeight = [meetstring heightWithFont:AboutUsLabelFont constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 40];
    __weak typeof(self) weakSelf = self;
    if (titleHeight > 30){
        [_meetLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.interestView.mas_bottom).offset(14);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-30);
            make.height.mas_offset(titleHeight);
        }];
        [self updateConstraints];
    }
    if (instrestHeight > 27) {
        [_interestView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(20);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.meetLabel.mas_top).offset(-14);
            make.height.offset(instrestHeight);
        }];
        [self updateConstraints];
    }
    
    [self updateConstraintsIfNeeded];
}


- (void)isHaveShadowColor:(BOOL)isShadowColor
{
    if (!isShadowColor) {
//        [self setWhiteView:NO isBottom:NO];
        self.showdowView.hidden = YES;
    }
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_interestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(20);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.meetLabel.mas_top).offset(-14);
            make.height.offset(27);
        }];
        [_meetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.interestView.mas_bottom).offset(14);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-30);
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

@end
