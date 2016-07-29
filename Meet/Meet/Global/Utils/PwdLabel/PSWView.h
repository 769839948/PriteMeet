//
//  PwdView.h
//  aaa
//
//  Created by 刘家男 on 16/7/8.
//  Copyright © 2016年 刘家男. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KeyboardType) {
    KeyboardTypeDefault,//默认从0开始
    KeyboardTypeNum
};

typedef void (^ToolBarButtonPress)(NSInteger tag);
typedef void (^KeyBoardReturnPress)(NSString *codeNumber);

@protocol DelegatePSW <NSObject>

-(void)pwdNum :(NSString *)pwdNum;

@end

@interface PSWView : UIView

@property (nonatomic,weak) id <DelegatePSW>delegate;

@property (nonatomic, strong) ToolBarButtonPress block;

@property (nonatomic, strong) KeyBoardReturnPress keyBoardPressBlock;

- (instancetype)initWithFrame:(CGRect)frame labelNum:(NSInteger)num showPSW:(BOOL)isShow keyboarType:(KeyboardType)type;

- (void)labelTouch:(UIGestureRecognizer *)tap;

- (void)changeLabelColor:(UIColor *)textColor;

@end
