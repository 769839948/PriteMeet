//
//  PwdView.h
//  aaa
//
//  Created by 刘家男 on 16/7/8.
//  Copyright © 2016年 刘家男. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ToolBarButtonPress)(NSInteger tag);

@protocol DelegatePSW <NSObject>

-(void)pwdNum :(NSString *)pwdNum;

@end

@interface PSWView : UIView

@property (nonatomic,weak) id <DelegatePSW>delegate;

@property (nonatomic, strong) ToolBarButtonPress block;

- (instancetype)initWithFrame:(CGRect)frame labelNum:(NSInteger)num showPSW:(BOOL)isShow;

- (void)labelTouch:(UIGestureRecognizer *)tap;

@end
