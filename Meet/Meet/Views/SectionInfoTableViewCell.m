//
//  SectionInfoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "SectionInfoTableViewCell.h"
#import "Masonry.h"

@interface SectionInfoTableViewCell ()

@property (nonatomic, retain) UIImageView *cellImageView;
@property (nonatomic, retain) UILabel *titleLabel;

@end

@implementation SectionInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showdowView.hidden = YES;
        [self setWhiteView:YES isBottom:NO];
        [self setUpView];
        
    }
    return self;
}


- (void)setUpView
{
    _cellImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_cellImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = MeetSectionTitleNameFont;
    _titleLabel.textColor = MeetSectionTitleNameColot;
    [self.contentView addSubview:_titleLabel];
}

- (void)configCell:(NSString *)imageName titleString:(NSString *)title
{
    _cellImageView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = title;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.showdowView.mas_top).offset(14);
            make.left.mas_equalTo(weakSelf.showdowView.mas_left).offset(10);
            make.width.offset(20.0f);
            make.height.offset(20.0f);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.showdowView.mas_top).offset(15);
            make.left.mas_equalTo(weakSelf.cellImageView.mas_right).offset(9);
            make.right.mas_equalTo(weakSelf.showdowView.mas_right).offset(0);
            make.height.offset(20.0f);
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
