//
//  EaseBaseSubView.m
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/21.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "EaseBaseSubView.h"
#import "UIView+Position.h"

@implementation EaseBaseSubView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
    }
    return self;
}

#pragma mark - action

- (void)closeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapBackgroundView:)]) {
        [self.delegate didTapBackgroundView:self];
    }
}

#pragma mark - public

- (void)showFromParentView:(UIView *)view
{
    view.userInteractionEnabled = NO;
    self.top = ScreenHeight;
    [view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.top = 0;
    } completion:^(BOOL finished) {
        view.userInteractionEnabled = YES;
    }];
}

- (void)removeFromParentView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.top = ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
