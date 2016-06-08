//
//  LabelTableViewCell.m
//  Meet
//
//  Created by jiahui on 16/5/11.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "LabelTableViewCell.h"
#import "Masonry.h"

@interface LabelTableViewCell()

@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation LabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
    [self.contentView addSubview:_lineLabel];
    [self updateConstraints];
    // Initialization code
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        __weak typeof(self) weakSelf = self;
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
            make.height.offset(0.5);
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
