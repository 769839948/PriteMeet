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
        [self setWhiteView:NO isMoreCell:NO];
        self.whitView.hidden = YES;
        self.showdowView.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        _loop = [[HYBLoopScrollView alloc] init];
        [self.contentView addSubview:_loop];
        
    }
    return self;
}

- (void)configCell
{
    NSArray *images = @[@"http://s0.pimg.cn/group5/M00/5B/6D/wKgBfVaQf0KAMa2vAARnyn5qdf8958.jpg?imageMogr2/strip/thumbnail/1200%3E/quality/95",
                        @"http://7xrs9h.com1.z0.glb.clouddn.com/wp-content/uploads/2016/03/QQ20160322-0@2x.png",
                        @"http://7xrs9h.com1.z0.glb.clouddn.com/wp-content/uploads/2016/03/QQ20160322-5@2x-e1458635879420.png"
                        ];
    
    
    // 当有导航条时，若距离上面不点满，或者被挡一部分，请一定要设置这一行，因为7.0之后self.view的起点坐标从
    // 状态栏开始的。
    _loop = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width - 20, ([[UIScreen mainScreen] bounds].size.width - 20)*236/355) imageUrls:images timeInterval:3 didSelect:^(NSInteger atIndex) {
        
    } didScroll:^(NSInteger toIndex) {
        
    }];
    
    _loop.backgroundColor = [UIColor whiteColor];
    _loop.shouldAutoClipImageToViewSize = NO;
    _loop.placeholder = [UIImage imageNamed:@"default.png"];
    
    _loop.alignment = kPageControlAlignCenter;
    _loop.layer.cornerRadius = 5.0;
    [self.contentView addSubview:_loop];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_loop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(0);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(0);
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
