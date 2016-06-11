//
//  MeetInfoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "MeetInfoTableViewCell.h"
#import "InterestCollectView.h"
#import "Masonry.h"
#import "NSString+StringSize.h"
#import "EqualSpaceFlowLayout.h"

@interface MeetInfoTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *meetNumber;

@property (nonatomic, strong) InterestCollectView *interestView;


@end

@implementation MeetInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showdowView.hidden = YES;
        [self setWhiteView:NO isBottom:NO];
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.numberOfLines = 0;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = HomeViewNameFont;
    _nameLabel.textColor = HomeViewNameColor;
    [self.contentView addSubview:_nameLabel];
    
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.numberOfLines = 0;
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    _positionLabel.font = HomeViewPositionFont;
    _positionLabel.textColor = HomeViewPositionColor;
    [self.contentView addSubview:_positionLabel];
    
    _meetNumber = [[UILabel alloc] init];
    _meetNumber.textAlignment = NSTextAlignmentCenter;
    _meetNumber.font = [UIFont systemFontOfSize:12.0f];
    _meetNumber.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_meetNumber];
    
    //确定是水平滚动，还是垂直滚动
    EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
    
    _interestView = [[InterestCollectView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_interestView setEdgX:10];
    flowLayout.delegate = _interestView;
    //    [_interestView setCollectViewData:@[@"旅行顾问",@"创意总监",@"谈判专家",@"顾问"]];
    [self.contentView addSubview:_interestView];
    [self updateConstraints];
}

- (void)configCell:(NSString *)name position:(NSString *)position meetNumber:(NSString *)meetNumber interestCollectArray:(NSArray *)interstArray
{
    _nameLabel.text = name;
    _positionLabel.text = position;
    _meetNumber.text = meetNumber;
    [_interestView setCollectViewData:interstArray];
    NSString *instresTitleString = @"  ";
    for (NSString *instrestTitle in interstArray) {
        instresTitleString = [instresTitleString stringByAppendingString:instrestTitle];
        instresTitleString = [instresTitleString stringByAppendingString:@"   "];
    }
    float instrestHeight = [instresTitleString heightWithFont:[UIFont fontWithName:@"PingFangSC-Light" size:21.0f] constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
    //    float height = [flowLayout collectionViewContentSize].height;
    //    NSLog(@"---------%f",height);
    
    float positionHeight = [position heightWithFont:HomeViewPositionFont constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
    __weak typeof(self) weakSelf = self;
    if (positionHeight > 32){
        [_positionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(11);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.height.offset(positionHeight);
        }];
        [self updateConstraints];
    }
    if (instrestHeight > 30) {
        [_interestView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.meetNumber.mas_bottom).offset(16);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-32);
            make.height.offset(instrestHeight);
        }];
        [self updateConstraints];
    }
    
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(21);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.height.offset(30);
        }];
        [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(11);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(10);
            make.height.offset(30);
        }];
        [_meetNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.positionLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.height.offset(17);
        }];
        [_interestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.meetNumber.mas_bottom).offset(16);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-32);
            make.height.offset(30);
        }];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
