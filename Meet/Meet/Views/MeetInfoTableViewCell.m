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
#import "Meet-Swift.h"

@interface MeetInfoTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *meetNumber;

@property (nonatomic, strong) UIImageView *authentication;
@property (nonatomic, strong) UIImageView *unAuthentication;

@property (nonatomic, strong) CenterlabelView *centerLabelView;


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
    _nameLabel.font = HomeViewDetailNameFont;
    _nameLabel.textColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
    [self.contentView addSubview:_nameLabel];
    
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.numberOfLines = 0;
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    _positionLabel.font = HomeViewDetailPositionFont;
    _positionLabel.textColor = [UIColor colorWithHexString:HomeDetailViewPositionColor];
    [self.contentView addSubview:_positionLabel];
    
    _meetNumber = [[UILabel alloc] init];
    _meetNumber.textAlignment = NSTextAlignmentCenter;
    _meetNumber.font = HomeViewDetailMeetNumberFont;
    _meetNumber.textColor = [UIColor colorWithHexString:HomeDetailViewMeetNumberColor];
    [self.contentView addSubview:_meetNumber];
    
    _centerLabelView = [[CenterlabelView alloc] init];
    [self.contentView addSubview:_centerLabelView];

    _authentication = [[UIImageView alloc] init];
    [self.contentView addSubview:_authentication];
    
    _unAuthentication = [[UIImageView alloc] init];
    [self.contentView addSubview:_unAuthentication];
    
    [self updateConstraints];
}

- (void)configCell:(NSString *)name position:(NSString *)position meetNumber:(NSString *)meetNumber interestCollectArray:(NSArray *)interstArray autotnInfo:(NSString *)autnInfo
{
    _nameLabel.text = name;
    __weak typeof(self) weakSelf = self;
    if ([position isEqualToString:@""]) {
        [_positionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.1);
        }];
        [self updateConstraints];
    }else{
        _positionLabel.text = position;
        float positionHeight = [position heightWithFont:HomeViewDetailPositionFont constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 160];
        if (positionHeight > 32){
            [_positionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(positionHeight);
            }];
            [self updateConstraints];
        }
    }
    if ([meetNumber isEqualToString:@""]) {
        [_meetNumber mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.1);
        }];
        [self updateConstraints];
    }else{
        _meetNumber.text = meetNumber;
    }
    
    if (interstArray.count == 0) {
        [_centerLabelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.001);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
        }];
        [self updateConstraints];
    }else{
        if ([interstArray[0] isEqualToString:@""]) {
            [_centerLabelView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0.001);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);

            }];
            [self updateConstraints];
        }else{
            CGFloat height = [_centerLabelView setUpCustomLabelArray:interstArray];
            [_centerLabelView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(height);
            }];
            [weakSelf updateConstraints];
            [weakSelf updateConstraintsIfNeeded];
        }
    }
    
    NSArray *authArray = [autnInfo componentsSeparatedByString:@","];
    if (authArray.count == 3) {
        _authentication.hidden = NO;
        _unAuthentication.hidden = YES;
        _authentication.image = [UIImage imageNamed:@"home_detail_verifie_select"];
    }else{
        _authentication.hidden = YES;
        _unAuthentication.hidden = NO;
        _unAuthentication.image = [UIImage imageNamed:@"home_detail_uverifie_unselect"];

    }
    
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(25);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.positionLabel.mas_top).offset(-5);
        }];
        [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(80);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-80);
            make.bottom.mas_equalTo(weakSelf.meetNumber.mas_top).offset(-8);
            make.height.offset(30);
        }];
        [_meetNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.positionLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.centerLabelView.mas_top).offset(-16);
        }];
        [_centerLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.meetNumber.mas_bottom).offset(16);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-32);
        }];
        
        [_authentication mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.size.mas_offset(CGSizeMake(68, 30));
        }];
        
        [_unAuthentication mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.authentication.mas_bottom).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.size.mas_offset(CGSizeMake(68, 30));
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
