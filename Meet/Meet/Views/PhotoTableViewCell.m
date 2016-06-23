//
//  PhotoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "PhotoTableViewCell.h"
#import "HYBLoopScrollView.h"
#import "Masonry.h"

@interface PhotoTableViewCell ()

@property (nonatomic, strong) HYBLoopScrollView *loop;

@end

@implementation PhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.whitView.hidden = YES;
        self.showdowView.hidden = YES;
        if (_loop == nil) {
            _loop = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(10, 0, ScreenWidth - 20, (ScreenWidth - 20)*236/355) imageUrls:nil timeInterval:0 didSelect:^(NSInteger atIndex) {
                
            } didScroll:^(NSInteger toIndex) {
                
            }];
            
            _loop.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
            _loop.shouldAutoClipImageToViewSize = NO;
            _loop.placeholder = PlaceholderImage;
            
            _loop.alignment = kPageControlAlignCenter;
            _loop.layer.cornerRadius = 5.0;
            [self.contentView addSubview:_loop];
        }
        
    }
    return self;
}

- (void)configCell:(NSArray *)imageArray
{
    // 状态栏开始的。
    if (_loop.imageUrls != nil) {
        
    }else{
        _loop.imageUrls = imageArray;
    }
    
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_loop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(0);
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
