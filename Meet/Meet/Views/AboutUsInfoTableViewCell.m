//
//  AboutUsInfoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "AboutUsInfoTableViewCell.h"
#import "NSString+StringSize.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>




@interface CustomLabel : UILabel

+ (instancetype)setUpLabel:(CGRect)frame text:(NSString *)string;

@end

@implementation CustomLabel

+ (instancetype)setUpLabel:(CGRect)frame text:(NSString *)string
{
    CustomLabel *label = [[CustomLabel alloc] init];
    float height = [string heightWithFont:AboutUsLabelFont constrainedToWidth:frame.size.width];
    label.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    label.font = AboutUsLabelFont;
    label.textColor = [UIColor colorWithHexString:AboutUsLabelColor];
    label.numberOfLines = 0;
    label.text = string;
    return label;
    
}

@end

@interface AboutUsInfoTableViewCell ()

@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *textlabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSMutableArray *stringArray;

@property (nonatomic, strong) UIView *imageContent;

@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation AboutUsInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isFirstLoad = YES;
        _stringArray = [NSMutableArray array];
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
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = HomeDetailAboutUsTitleLabelFont;
    _titleLabel.textColor = [UIColor colorWithHexString:AboutUsCellTitleColor];
    [self.contentView addSubview:_titleLabel];
    
    _textlabel = [[UILabel alloc] init];
    _textlabel.font = HomeDetailAboutUsLabelFont;
    _textlabel.numberOfLines = 0;
    _textlabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textlabel.textColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
    [self.contentView addSubview:_textlabel];
    
    
    _imageContent = [[UIView alloc] init];
    _imageContent.clipsToBounds = YES;
    [self.contentView addSubview:_imageContent];
    
}

- (void)configCell:(NSString *)title info:(NSString *)info imageArray:(NSArray *)images withUrl:(NSString *)web_url
{
    __weak typeof(self) weakSelf = self;

    _titleLabel.text = title;
    _textlabel.text = info;
    
    if (![web_url isEqualToString:@""]) {
        for (NSInteger i = 0; i < images.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            NSArray *imageArray = [[images objectAtIndex:i] componentsSeparatedByString:@"?"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray[0] stringByAppendingString:HomeDetailMoreInfoImageSize]] placeholderImage:PlaceholderImage options:SDWebImageRetryFailed];
            imageView.frame = CGRectMake(i * 64, 0, 59, 59);
            [_imageContent addSubview:imageView];
        }
        UIImage *image = [UIImage imageNamed:@"photo_detail"];
        UIImageView *detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 40 - image.size.width, 0, image.size.width, image.size.height)];
        NSLog(@"%f",detailImage.frame.origin.x);
        detailImage.image  = image;
        [_imageContent addSubview:detailImage];
        UIImageView *detailNextImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 47, 24, 7, 12)];
        detailNextImage.image  = [UIImage imageNamed:@"info_next"];
        [_imageContent addSubview:detailNextImage];
    }else{
        
        [_textlabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-30);
        }];
    }
    if ([title isEqualToString:@""]) {
        [_textlabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        }];
    }
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(26);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.textLabel.mas_top).offset(-15);
        }];
        [_textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.imageContent.mas_top).offset(-22);
        }];
        
        [_imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.textlabel.mas_bottom).offset(22);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-30);
            make.height.offset(59);
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
