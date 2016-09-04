//
//  PhotoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "PhotoTableViewCell.h"
//#import "HYBLoopScrollView.h"
#import "SDCycleScrollView.h"
#import "Masonry.h"

@interface PhotoTableViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIButton *ageNumber;

@end

@implementation PhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.whitView.hidden = YES;
        self.showdowView.hidden = YES;
    }
    return self;
}

- (void)configCell:(NSArray *)imageArray gender:(NSInteger)gender age:(NSInteger)age
{
    //http://7xsatk.com1.z0.glb.clouddn.com/o_1aqc2rujd1vbc11ten5s12tj115fc.jpg?imageView2/1/w/1065/h/708
    //http://7xsatk.com1.z0.glb.clouddn.com/o_1apsial4q1lca41q17vccc81sice.jpg?imageView2/1/w/1065/h/708
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, ScreenWidth - 20, (ScreenWidth - 20)*236/355) delegate:self placeholderImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e7e7e7"] size:CGSizeMake(ScreenWidth - 20, (ScreenWidth - 20)*236/355)]];
        _cycleScrollView.layer.cornerRadius = 5.0;
        _cycleScrollView.pageDotColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        [self.contentView addSubview:_cycleScrollView];
        //         --- 轮播时间间隔，默认1.0秒，可自定义
        _cycleScrollView.autoScroll = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _cycleScrollView.imageURLStringsGroup = imageArray;
        });

    }
//    if (_ageNumber == nil) {
//        _ageNumber = [UIButton buttonWithType:UIButtonTypeCustom];
//        _ageNumber.layer.cornerRadius = 12;
//        _ageNumber.titleLabel.font = HomeViewAgeFont;
//        [self.contentView addSubview:_ageNumber];
//        __weak typeof(self) weakSelf = self;
//        [_ageNumber mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(weakSelf.cycleScrollView.mas_top).offset(18);
//            make.right.mas_equalTo(weakSelf.cycleScrollView.mas_right).offset(-24);
//            make.height.offset(24);
//            make.width.offset(46);
//        }];
//    }
//    
//    if (gender == 1) {
//        _ageNumber.backgroundColor = [UIColor colorWithHexString:HomeViewManColor];
//        [_ageNumber setImage:[UIImage imageNamed:@"home_man"] forState:UIControlStateNormal];
//    }else{
//        [_ageNumber setImage:[UIImage imageNamed:@"home_women"] forState:UIControlStateNormal];
//        _ageNumber.backgroundColor = [UIColor colorWithHexString:HomeViewWomenColor];
//    }
//    [_ageNumber setTitle:[NSString stringWithFormat:@" %ld",age] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.clickBlock != nil) {
        self.clickBlock(index);
    }
}

@end
