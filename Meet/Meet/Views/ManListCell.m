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
@property (nonatomic, strong) UIButton *ageNumber;
@property (nonatomic, strong) UILabel *meetNumber;
@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) InterestCollectView *interestView;


@property (nonatomic, strong) EqualSpaceFlowLayout *flowLayout;

@property (nonatomic, assign) CGFloat dicHeight;

@property (nonatomic, strong) UILabel *bottomLine;

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, copy) NSString *user_id;

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
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.layer.cornerRadius = 24;
    _likeBtn.layer.shadowOffset = CGSizeMake(0, 4);
    _likeBtn.layer.shadowOpacity = 0.5;
    _likeBtn.adjustsImageWhenHighlighted = NO;
    _likeBtn.layer.shadowColor = [[UIColor colorWithWhite:0.938 alpha:1.000] CGColor];
    [_likeBtn addTarget:self action:@selector(likeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    _likeBtn.backgroundColor = [UIColor clearColor];
    [_personalView addSubview:_likeBtn];
    
    
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
    _user_id = [NSString stringWithFormat:@"%ld",(long)model.uid];
    __weak typeof(self) weakSelf = self;
    if (model.cover_photo != nil || model.cover_photo != NULL) {
        Cover_photo *coverPhoto = [Cover_photo mj_objectWithKeyValues:model.cover_photo];
        //http://7xsatk.com1.z0.glb.clouddn.com/o_1aqc2rujd1vbc11ten5s12tj115fc.jpg?imageView2/1/w/1065/h/600
//        NSArray *imageArray = [coverPhoto.photo componentsSeparatedByString:@"?"];
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
    if (model.liked) {
        [self reloadLikeBtnImage:YES];
        _likeBtn.tag = 1;
    }else{
        [self reloadLikeBtnImage:NO];
        _likeBtn.tag = 0;
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
        [_meetNumber mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.01);
        }];
        [self updateConstraints];
    }else{
        _meetNumber.text = _meetNumber.text;
    }
    if ([interstArray[0] isEqualToString:@""]) {
        [_interestView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.001);
        }];
        [self updateConstraints];
    }else{
        [_interestView setCollectViewData:interstArray style:ItemBlackAndWhiteLabelText];
        [weakSelf.interestView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset([self cellHeight:interstArray]);
        }];
        [weakSelf updateConstraints];
        [weakSelf updateConstraintsIfNeeded];
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

- (void)reloadLikeBtnImage:(BOOL)isLike
{
    UIImage *image = isLike?[UIImage imageNamed:@"Icon_Liked_Normal"]:[UIImage imageNamed:@"Icon_Like_Normal"];
    UIImage *imageBack = isLike?[UIImage imageNamed:@"Liked"]:[UIImage imageNamed:@"Like"];
    UIImage *imageHight = isLike?[UIImage imageNamed:@"Icon_Liked_Pressed"]:[UIImage imageNamed:@"Icon_Like_Pressed"];
    NSInteger tag = isLike?1:0;
    _likeBtn.tag = tag;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_likeBtn setImage:image forState:UIControlStateNormal];
        [_likeBtn setImage:imageHight forState:UIControlStateHighlighted];
        [_likeBtn setBackgroundImage:imageBack forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.likeBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         }completion:^(BOOL finish){
                             [UIView animateWithDuration:0.25
                                              animations:^{
                                                  self.likeBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              }completion:^(BOOL finish){
                                                  
                                              }];
                         }];
    });
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
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-0);
        }];
        
        [_personalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.showdowView.mas_bottom).offset(-3);
        }];
        
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf.nameLabel.mas_top).offset(-4);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-23);
            make.size.mas_offset(CGSizeMake(48, 48));
        }];
        
        [_photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.personalView.mas_top).offset(0);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(0);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(0);
            make.height.mas_offset((ScreenWidth - 20)*200/355);
        }];
        
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.photoImage.mas_bottom).offset(14);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(14);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-14);
            make.bottom.mas_equalTo(weakSelf.meetNumber.mas_top).offset(-1);
        }];
        
        [_ageNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.personalView.mas_top).offset(18);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-24);
            make.height.offset(24);
            make.width.offset(46);
        }];
        
        [_meetNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(1);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(14);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-14);
            make.bottom.mas_equalTo(weakSelf.interestView.mas_top).offset(-17);
        }];
        
        [_interestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.meetNumber.mas_bottom).offset(17);
            make.left.mas_equalTo(weakSelf.personalView.mas_left).offset(15);
            make.right.mas_equalTo(weakSelf.personalView.mas_right).offset(-15);
            make.bottom.mas_equalTo(weakSelf.personalView.mas_bottom).offset(-17);
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (void)likeButtonPress:(UIButton *)sender
{
    if (self.block) {
        BOOL isLike = sender.tag?1:0;
        self.block(isLike,_user_id);
    }
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
