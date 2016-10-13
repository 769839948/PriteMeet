//
//  EaseEndLiveView.m
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/19.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "EaseEndLiveView.h"

#import "EaseTagView.h"
#import "UIView+Position.h"

@interface EaseEndLiveView ()

@property (nonatomic, strong) UIButton *endButton;

@property (nonatomic, strong) EaseTagView *userTagView;
@property (nonatomic, strong) EaseEndTagView *likeTagView;
@property (nonatomic, strong) EaseEndTagView *timeTagView;
@property (nonatomic, strong) EaseEndTagView *audienceTagView;
@property (nonatomic, strong) EaseEndTagView *commentsTagView;


@end

@implementation EaseEndLiveView

- (instancetype)initWithUsername:(NSString*)username
                            like:(NSString*)like
                            time:(NSString*)time
                        audience:(NSString*)audience
                        comments:(NSString*)comments
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.endButton];
        
        _userTagView = [[EaseTagView alloc] initWithFrame:CGRectMake((ScreenWidth - 86.f)/2, 128.f, 86.f, 108.f) name:username imageName:nil];
        [self addSubview:_userTagView];
        
        _timeTagView = [[EaseEndTagView alloc] initWithFrame:CGRectMake((ScreenWidth - 86.f)/2, _userTagView.bottom + 10.f, 86.f, 50) name:NSLocalizedString(@"endview.time", @"Time") text:time];
        [self addSubview:_timeTagView];
        
        _audienceTagView = [[EaseEndTagView alloc] initWithFrame:CGRectMake((ScreenWidth - 86.f)/2 - _timeTagView.width, _timeTagView.bottom + 10.f, 86.f, 50.f) name:NSLocalizedString(@"endview.audience", @"Audience") text:audience];
        [self addSubview:_audienceTagView];
        
        _commentsTagView = [[EaseEndTagView alloc] initWithFrame:CGRectMake((ScreenWidth - 86.f)/2 + _timeTagView.width, _timeTagView.bottom + 10.f, 86.f, 50.f) name:NSLocalizedString(@"endview.comment", @"Comments") text:comments];
        [self addSubview:_commentsTagView];
    }
    return self;
}


- (UIButton*)endButton
{
    if (_endButton == nil) {
        _endButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _endButton.frame = CGRectMake(0, ScreenHeight - 54.f, ScreenWidth, 54.f);
        _endButton.backgroundColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
        [_endButton setTitle:NSLocalizedString(@"endview.button.ok", @"Ok") forState:UIControlStateNormal];
        [_endButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endButton;
}

- (void)endAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEndButton)]) {
        [self.delegate didClickEndButton];
    }
}

@end
