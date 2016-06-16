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
            
            _loop.backgroundColor = [UIColor whiteColor];
            _loop.shouldAutoClipImageToViewSize = NO;
            _loop.placeholder = [UIImage imageNamed:@"default.png"];
            
            _loop.alignment = kPageControlAlignCenter;
            _loop.layer.cornerRadius = 5.0;
            [self.contentView addSubview:_loop];
        }
        
    }
    return self;
}

- (void)configCell:(NSArray *)imageArray
{
//    NSArray *images = @[@"http://s0.pimg.cn/group5/M00/5B/6D/wKgBfVaQf0KAMa2vAARnyn5qdf8958.jpg?imageMogr2/strip/thumbnail/1200%3E/quality/95",
//                        @"http://7xrs9h.com1.z0.glb.clouddn.com/wp-content/uploads/2016/03/QQ20160322-0@2x.png",
//                        @"http://7xrs9h.com1.z0.glb.clouddn.com/wp-content/uploads/2016/03/QQ20160322-5@2x-e1458635879420.png"
//                        ];
    
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
