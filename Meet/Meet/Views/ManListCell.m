//
//  ManListCell.m
//  Meet
//
//  Created by jiahui on 16/4/29.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "ManListCell.h"
#import "InterestCollectView.h"
#import "Masonry.h"
#import "NSString+StringSize.h"

@interface ManListCell ()

@property (nonatomic, strong) UIView *showdowView;
@property (nonatomic, strong) UIView *personalView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *ageNumber;
@property (nonatomic, strong) UILabel *meetNumber;
@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) InterestCollectView *interestView;

@property (nonatomic, strong) UILabel *bottomLine;

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

@end

@implementation ManListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpView];
    }
    return self;
}


- (void)setUpView
{
    _showdowView = [[UIView alloc] init];
    _showdowView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    _showdowView.layer.cornerRadius = 5.0f;
    [self.contentView addSubview:_showdowView];
    
    _personalView = [[UIView alloc] init];
    _personalView.backgroundColor = [UIColor whiteColor];
    _personalView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:_personalView];
    
    
    _photoImage = [[UIImageView alloc] init];
    _photoImage.backgroundColor = [UIColor blackColor];
    _photoImage.image = [UIImage imageNamed:@"Pic"];
    [_personalView addSubview:_photoImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.numberOfLines = 0;
    [_personalView addSubview:_nameLabel];
    
//    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _likeBtn.frame = CGRectMake(_personalView.frame.size.width - 67, 169, 40, 40);
//    _likeBtn.layer.cornerRadius = 20;
//    [_likeBtn setImage:[UIImage imageNamed:@"Icon_Like"] forState:UIControlStateNormal];
//    _likeBtn.layer.shadowOffset = CGSizeMake(0, 1);
//    _likeBtn.layer.shadowOpacity = 1.0;
//    _likeBtn.layer.shadowRadius = 3;
//    _likeBtn.layer.shadowColor = [[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0] CGColor];
//    _likeBtn.backgroundColor = [UIColor whiteColor];
//    [_personalView addSubview:_likeBtn];
    
    
    _meetNumber = [[UILabel alloc] init];
    _meetNumber.font = [UIFont systemFontOfSize:12.0f];
    _meetNumber.textColor = [UIColor lightGrayColor];
    [_personalView addSubview:_meetNumber];
    
    _ageNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    _ageNumber.layer.cornerRadius = 12;
    _ageNumber.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:232.0/255.0 alpha:1.0];
    [_personalView addSubview:_ageNumber];
    
    //确定是水平滚动，还是垂直滚动
    self.flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.estimatedItemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 20, 27);
    
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _interestView = [[InterestCollectView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    //    [_interestView setCollectViewData:@[@"旅行顾问",@"创意总监",@"谈判专家",@"顾问"]];
    [_personalView addSubview:_interestView];
    [self updateConstraints];
}

- (void)configCell:(NSString *)title array:(NSArray *)array string:(NSString *)string
{
    _nameLabel.text = title;
    _meetNumber.text = string;
    [_interestView setCollectViewData:array];
    NSString *instresTitleString = @"  ";
    for (NSString *instrestTitle in array) {
        instresTitleString = [instresTitleString stringByAppendingString:instrestTitle];
        instresTitleString = [instresTitleString stringByAppendingString:@"  "];
    }
    float instrestHeight = [title heightWithFont:[UIFont fontWithName:@"PingFangSC-Light" size:20.0f] constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
    float height = [self.flowLayout collectionViewContentSize].height;
    NSLog(@"---------%f",height);
    
    float titleHeight = [title heightWithFont:HomeViewNameFont constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
    __weak typeof(self) weakSelf = self;
    if (titleHeight > 30){
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.photoImage.mas_bottom).offset(14);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(14);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-14);
            make.height.mas_offset(titleHeight);
        }];
        [self updateConstraints];
    }
    if (instrestHeight > 27) {
        [_interestView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.meetNumber.mas_bottom).offset(17);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(14);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-14);
            make.bottom.mas_equalTo(weakSelf.personalView.mas_bottom).offset(-14);
            make.height.offset(instrestHeight + 5);
        }];
        [self updateConstraints];
    }
    
    _nameLabel.frame = CGRectMake(0, 0, 100, 100);
    _nameLabel.font = [UIFont systemFontOfSize:22.55f];
    NSArray *textArray = [_nameLabel.text componentsSeparatedByString:@" "];
    NSString *userName = [NSString stringWithFormat:@"%@",[textArray objectAtIndex:0]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_nameLabel.text];
    [str addAttribute:NSFontAttributeName value:HomeViewNameFont range:NSMakeRange(0, userName.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:HomeViewNameColor} range:NSMakeRange(0, userName.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:HomeViewPositionColor} range:NSMakeRange(userName.length, _nameLabel.text.length - userName.length)];
    [str addAttribute:NSFontAttributeName value:HomeViewPositionFont range:NSMakeRange(userName.length, _nameLabel.text.length - userName.length)];
    _nameLabel.attributedText = str;
    
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        __weak typeof(self) weakSelf = self;
        [_showdowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
        }];
        
        [_personalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-5);
        }];
        
        [_photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.personalView.mas_top).offset(0);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(0);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(0);
            make.height.offset(200);
        }];
        
        [_ageNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.personalView.mas_top).offset(18);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-24);
            make.height.offset(24);
            make.width.offset(46);
        }];
        
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.photoImage.mas_bottom).offset(14);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(14);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-14);
            make.height.mas_offset(30);
        }];
        
        [_meetNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(1);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(14);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-14);
            make.bottom.mas_equalTo(weakSelf.interestView.mas_top).offset(-14);
            
            make.height.offset(17);
        }];
        
        [_interestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.meetNumber.mas_bottom).offset(17);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(14);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-14);
            make.bottom.mas_equalTo(weakSelf.personalView.mas_bottom).offset(-14);
            make.height.offset(27);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
