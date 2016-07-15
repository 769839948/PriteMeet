//
//  SettingTableViewCell.m
//  Meet
//
//  Created by Zhang on 7/9/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "Masonry.h"
@interface SettingTableViewCell()

@property (nonatomic, strong) UILabel *cellLineLabel;

@property (nonatomic, assign) BOOL didSetupConstraints;


@end

@implementation SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellLineLabel = [[UILabel alloc] init];
        _cellLineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
        [self.contentView addSubview:_cellLineLabel];
    }
    return self;
}

- (void)setData:(BOOL)isDetailText
{
    if (isDetailText) {
        [_cellLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0.5);
            make.height.offset(0.5);
        }];
    }else{
        [_cellLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0.5);
            make.height.offset(0.5);
        }];
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        __weak typeof(self) weakSelf = self;
        [_cellLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(1);
            make.height.offset(0.5);
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
