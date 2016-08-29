//
//  AllInfoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "AllInfoTableViewCell.h"

#define allInfoLabelColor @"#999999"

@interface AllInfoTableViewCell ()

@property (nonatomic, strong) UILabel *allInfoLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation AllInfoTableViewCell

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
    _allInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    _allInfoLabel.text = @"查看全部资料";
    _allInfoLabel.font = AllInfoLabelFont;
    _allInfoLabel.textColor = [UIColor colorWithHexString:allInfoLabelColor];
    _allInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_allInfoLabel];
    
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, ScreenWidth - 40, 0.5)];
    _lineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
    [self.contentView addSubview:_lineLabel];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
