//
//  PwdView.m
//  aaa
//
//  Created by 刘家男 on 16/7/8.
//  Copyright © 2016年 刘家男. All rights reserved.
//

#import "PSWView.h"
#import "WXApi.h"

#define  LableWidh    40
#define  LableHeight  52

#define  SpachMarginX 16

@interface PSWView ()<UITextFieldDelegate>

@property (nonatomic, strong)NSMutableArray *labelMArr;

@property (nonatomic, strong)UITextField *numTextField;

@property BOOL isShow;

@end

@implementation PSWView

- (UITextField *)numTextField
{
    if (!_numTextField) {
        _numTextField = [[UITextField alloc]initWithFrame:self.bounds];
        _numTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _numTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _numTextField.textColor = [UIColor clearColor];
        _numTextField.tintColor = [UIColor clearColor];
        _numTextField.inputAccessoryView = [self setUpView];
        [_numTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        _numTextField.delegate = self;
    }
    return _numTextField;
}


- (UIView *)setUpView
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
    inputView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, 155, 30)];
    label.textColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
    label.font = IQKeyboardManagerFont;
    label.text = @"使用已有 Meet 账号登录";
    [inputView addSubview:label];
    
    UIButton *weibo = [UIButton buttonWithType:UIButtonTypeCustom];
    weibo.frame = CGRectMake(ScreenWidth - 50, 9, 30, 30);
    weibo.layer.cornerRadius = 15;
    weibo.tag = 1;
    weibo.layer.masksToBounds = YES;
    [weibo addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [weibo setImage:[UIImage imageNamed:@"keyboard_weibo"] forState:UIControlStateNormal];
    [inputView addSubview:weibo];
    
    if ([WXApi isWXAppInstalled]) {
        UIButton *weChat = [UIButton buttonWithType:UIButtonTypeCustom];
        weChat.frame = CGRectMake(ScreenWidth - 94, 9, 30, 30);
        weChat.layer.cornerRadius = 15;
        weChat.tag = 2;
        [weChat addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        weChat.layer.masksToBounds = YES;
        [weChat setImage:[UIImage imageNamed:@"keyboard_weChat"] forState:UIControlStateNormal];
        [inputView addSubview:weChat];
    }
    return inputView;
}

- (void)buttonPress:(UIButton *)sender
{
    if (self.block) {
        self.block(sender.tag);
    }
}

- (NSMutableArray *)labelMArr
{
    if (!_labelMArr) {
        _labelMArr = [NSMutableArray array];
    }
    return _labelMArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame labelNum:1 showPSW:YES];
}

- (instancetype)initWithFrame:(CGRect)frame labelNum:(NSInteger)num showPSW:(BOOL)isShow
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.numTextField];
        self.isShow = isShow;
        for (int i = 0; i < num; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SpachMarginX + LableWidh) *i, 0, LableWidh, LableHeight)];
            label.backgroundColor = [UIColor colorWithHexString:TableViewBackGroundColor];
            [self.labelMArr addObject:label];
            label.font = ApplyCodeFont;
            label.textAlignment = NSTextAlignmentCenter;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouch:)];
            [label addGestureRecognizer:tap];
            [self addSubview:label];
        }
        
    }
    return self;
}

- (void)labelTouch:(UIGestureRecognizer *)tap
{
    [self.numTextField becomeFirstResponder];
}

- (void)textFieldChange:(id)sender
{
    for (int i = 0; i < self.labelMArr.count; i++) {
        UILabel *label = self.labelMArr[i];
        if (i < self.numTextField.text.length) {
            //显示密码
            if(self.isShow){
                label.text = [NSString stringWithFormat:@"%c", [self.numTextField.text characterAtIndex:i]];
            }else{
            //隐藏密码
                label.text = @"●";
            }
        } else {
            label.text = @"";
        }
    }
    if (self.numTextField.text.length > 4) {
        self.numTextField.text = [self.numTextField.text substringToIndex:4];
    }
    if ([self.delegate respondsToSelector:@selector(pwdNum:)]) {
        [self.delegate pwdNum:(self.numTextField.text)];
    }
//    [self.delegate pwdNum:(self.numTextField.text)];

//    NSLog(@"%@",self.numTextField.text);
}

@end
