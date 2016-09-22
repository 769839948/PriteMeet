//
//  MeetRefreshBackFooter.m
//  Meet
//
//  Created by Zhang on 22/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "MeetRefreshBackFooter.h"

@interface MeetRefreshBackFooter()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;

@end


@implementation MeetRefreshBackFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 100;

    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:HomeDetailViewMeetNumberColor];
    label.font = RefreshFootViewTitleFont;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = CGRectMake(0, 53, self.bounds.size.width, 20);
    
    self.loading.center = CGPointMake(self.center.x, 29);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.label.text = @"加载更多内容";
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            self.label.text = @"松开加载更多内容";
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            self.label.text = @"正在加载更多内容...";
            break;
        case MJRefreshStateNoMoreData:
            [self.loading stopAnimating];
            self.label.text = @"没有跟多数据了";
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}

@end
