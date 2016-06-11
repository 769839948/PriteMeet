//
//  AboutUsInfoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "AboutUsInfoTableViewCell.h"
#import "NSString+StringSize.h"

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

@property (nonatomic, copy) NSMutableArray *stringArray;
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
    
}

- (void)configCell:(NSArray *)stringArray
{
    if (_isFirstLoad && stringArray != _stringArray) {
        float maxHeight = 10.0;
        for (NSInteger i = 0; i < stringArray.count; i ++) {
            CustomLabel *customLabel = [CustomLabel setUpLabel:CGRectMake(19, (maxHeight) + 10, ScreenWidth - 38, 0) text:[stringArray objectAtIndex:i]];
            
            [self.contentView addSubview:customLabel];
            maxHeight = CGRectGetMaxY(customLabel.frame);
        }
        _stringArray = [stringArray mutableCopy];
        _isFirstLoad = NO;
    }
    
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
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
