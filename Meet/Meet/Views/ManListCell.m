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
#import "EqualSpaceFlowLayout.h"
#import "MJExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ManListCell ()<EqualSpaceFlowLayoutDelegate>

@property (nonatomic, strong) UIView *showdowView;
@property (nonatomic, strong) UIView *personalView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *ageNumber;
@property (nonatomic, strong) UILabel *meetNumber;
@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) InterestCollectView *interestView;


@property (nonatomic, strong) EqualSpaceFlowLayout *flowLayout;

@property (nonatomic, assign) CGFloat dicHeight;

@property (nonatomic, strong) UILabel *bottomLine;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ManListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpView];
        _dicHeight = 27;
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
    _photoImage.image = [UIImage imageNamed:@"Pic"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth - 20, ([[UIScreen mainScreen] bounds].size.width - 20)*200/355) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _photoImage.bounds;
    maskLayer.path = maskPath.CGPath;
    _photoImage.layer.mask = maskLayer;
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
    _meetNumber.font = HomeMeetNumberFont;
    _meetNumber.textColor = [UIColor colorWithHexString:HomeMeetNumberColor];
    [_personalView addSubview:_meetNumber];
    
    _ageNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    _ageNumber.layer.cornerRadius = 12;
    _ageNumber.titleLabel.font = HomeViewAgeFont;
    [_personalView addSubview:_ageNumber];
    
    _flowLayout = [[EqualSpaceFlowLayout alloc] init];
    if (_interestView == nil) {
        _interestView = [[InterestCollectView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _flowLayout.delegate = _interestView;
        [_personalView addSubview:_interestView];
    }
    [self updateConstraints];
}

- (NSString *)getTimeNow
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

- (void)configCell:(HomeModel *)model interstArray:(NSArray *)interstArray
{
    __weak typeof(self) weakSelf = self;
    if (model.cover_photo != nil || model.cover_photo != NULL) {
        Cover_photo *coverPhoto = [Cover_photo mj_objectWithKeyValues:model.cover_photo];
        [_photoImage sd_setImageWithURL:[NSURL URLWithString:coverPhoto.photo] placeholderImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e7e7e7"] size:_photoImage.frame.size] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        }];
    }else{
        _photoImage.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
    }

    if (model.gender == 1) {
        _ageNumber.backgroundColor = [UIColor colorWithHexString:HomeViewManColor];
        [_ageNumber setImage:[UIImage imageNamed:@"home_man"] forState:UIControlStateNormal];
    }else{
        [_ageNumber setImage:[UIImage imageNamed:@"home_women"] forState:UIControlStateNormal];
        _ageNumber.backgroundColor = [UIColor colorWithHexString:HomeViewWomenColor];
    }
    [_ageNumber setTitle:[NSString stringWithFormat:@" %ld",(long)model.age] forState:UIControlStateNormal];
    
    if ([model.job_label isEqualToString:@" "]) {
        _nameLabel.text = [model.real_name stringByAppendingString:[NSString stringWithFormat:@" 他还没填写职业标签%@", model.job_label]];

    }else{
        _nameLabel.text = [model.real_name stringByAppendingString:[NSString stringWithFormat:@" %@", model.job_label]];

    }
    float titleHeight = [_nameLabel.text heightWithFont:HomeViewNameFont constrainedToWidth:ScreenWidth - 40];
    if (titleHeight > 30){
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(titleHeight);
        }];
        [self updateConstraints];
    }
    if (model.distance == nil) {
        _meetNumber.text = [NSString stringWithFormat:@"和你相隔  0m"];

    }else{
        _meetNumber.text = [NSString stringWithFormat:@"和你相隔  %@",model.distance];

    }
    if ([_meetNumber.text isEqualToString:@""]) {
        [_meetNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.interestView.mas_top).offset(-16);
            make.height.mas_offset(0.1);
        }];
        [self updateConstraints];
    }else{
        _meetNumber.text = _meetNumber.text;
    }
    if ([interstArray[0] isEqualToString:@""]) {
        [_interestView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.meetNumber.mas_bottom).offset(0);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-0);
            make.height.mas_offset(0.001);
        }];
        [self updateConstraints];
    }else{
        [_interestView setCollectViewData:interstArray];
        [weakSelf.interestView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.meetNumber.mas_bottom).offset(16);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-32);
            make.height.offset([self cellHeight:interstArray]);
        }];
        [weakSelf updateConstraints];
        [weakSelf updateConstraintsIfNeeded];
        _flowLayout.block = ^(CGFloat height){
            
            
        };
    }
    [ManListCell homeNameLabelColor:_nameLabel];

}

+ (void)homeNameLabelColor:(UILabel *)nameLable
{
    NSArray *textArray = [nameLable.text componentsSeparatedByString:@" "];
    NSString *userName = [NSString stringWithFormat:@"%@",[textArray objectAtIndex:0]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameLable.text];
    [str addAttribute:NSFontAttributeName value:HomeViewNameFont range:NSMakeRange(0, userName.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:HomeViewNameColor} range:NSMakeRange(0, userName.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:HomeViewPositionColor} range:NSMakeRange(userName.length, nameLable.text.length - userName.length)];
    [str addAttribute:NSFontAttributeName value:HomeViewPositionFont range:NSMakeRange(userName.length, nameLable.text.length - userName.length)];
    nameLable.attributedText = str;
}

- (CGFloat)cellHeight:(NSArray *)interArray
{
    CGFloat yOffset = 28;
    CGFloat allSizeWidth = 0;
    for (NSInteger idx = 0; idx < interArray.count; idx++) {
        CGSize itemSize = CGSizeMake([self cellWidth:[interArray objectAtIndex:idx]], 28);
        allSizeWidth = allSizeWidth + itemSize.width + 10;
        if (allSizeWidth > ScreenWidth - 40) {
            yOffset = yOffset + 35;
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
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-3);
        }];
        
        [_photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.personalView.mas_top).offset(0);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(0);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(0);
            make.height.offset(([[UIScreen mainScreen] bounds].size.width - 20)*200/355);
            make.bottom.mas_equalTo(weakSelf.nameLabel.mas_top).offset(-14);
        }];
        
        [_ageNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.personalView.mas_top).offset(18);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-24);
            make.height.offset(24);
            make.width.offset(46);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.photoImage.mas_bottom).offset(14);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(14);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-14);
            make.bottom.mas_equalTo(weakSelf.meetNumber.mas_top).offset(-1);
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
            make.bottom.mas_equalTo(weakSelf.personalView.mas_bottom).offset(-17);
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
