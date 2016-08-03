//
//  AddStarViewController.m
//  Meet
//
//  Created by jiahui on 16/5/5.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "AddStarViewController.h"
#import "UITextView+Placeholder.h"
#import "IQKeyboardManager.h"
#import "UserInfoViewModel.h"
#import "UserExtenModel.h"
#import "UIViewController+DismissKeyboard.h"

@interface CustomTextView : UITextView

+ (instancetype)setUpTextView:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag;

@end

@implementation CustomTextView

+ (instancetype)setUpTextView:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag
{
    CustomTextView *textView = [[CustomTextView alloc] initWithFrame:frame];
    textView.text = [NSString stringWithFormat:@"●%@",text];
    [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    textView.layer.borderColor = [[UIColor redColor] CGColor];
    textView.layer.borderWidth = 0.5;
    [textView setTag:tag];
    textView.font = [UIFont systemFontOfSize:20.0];
    [textView becomeFirstResponder];
    frame.size.height = textView.contentSize.height;
    textView.frame = frame;
    return textView;
}
@end

@interface AddStarViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UserInfoViewModel *viewModel;
@property (copy, nonatomic) NSMutableArray *stringArray;
@property (nonatomic, assign) CGFloat height;

@end

@implementation AddStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel = [[UserInfoViewModel alloc] init];
    self.navigationItem.title = @"描述个人亮点";
    NSString *str = [UserExtenModel shareInstance].highlight;
    if (![str isEqualToString:@""]) {
        _stringArray = [NSMutableArray arrayWithArray:[[[UserExtenModel shareInstance].highlight componentsSeparatedByString:@"\n"] copy]];
    }else{
        _stringArray = [[NSMutableArray alloc] init];
        [_stringArray addObject:@""];
    }
    if (IOS_7LAST) {
        self.navigationController.navigationBar.translucent = NO;
    }
    [self setUpTextView];
    [self setupForDismissKeyboard];
    [self.view addSubview:_textView];
    [self.textView becomeFirstResponder];
}

- (void)setUpTextView
{
    CGFloat height = 10;
    for (NSInteger i = 0; i < _stringArray.count; i ++) {
        CustomTextView *textView = [CustomTextView setUpTextView:CGRectMake(3, height, [[UIScreen mainScreen] bounds].size.width - 6, 0) text:_stringArray[i] tag:i + 1];
        textView.delegate = self;
        height = CGRectGetMaxY(textView.frame) + 10;
        [self.view addSubview:textView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

#pragma mark - action
- (void)leftItemClick:(UINavigationItem *)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (IBAction)saveAction:(id)sender {
    NSString *string = @"";
    for (NSInteger i = 0; i < _stringArray.count; i ++) {
        CustomTextView *textView = (CustomTextView *)[self.view viewWithTag:i + 1];
        if (textView.text.length > 1) {
            NSString *tempString = [textView.text substringFromIndex:1];
            string = [string stringByAppendingString:tempString];
            if (i != _stringArray.count - 1) {
                string = [string stringByAppendingString:@"\n"];
            }
        }
    }
    __weak typeof(self) weakSelf = self;
    [_viewModel addStar:string success:^(NSDictionary *object) {
        [UserExtenModel shareInstance].highlight = string;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    } fail:^(NSDictionary *object) {
        
    } loadingString:^(NSString *str) {
        
    }];
    
}

#pragma mark -  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.textView resignFirstResponder];
    return NO;
}

#pragma mark -  UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.tag == 1 && textView.text.length >= 1 && ![[textView.text substringToIndex:1] isEqualToString:@"●"]){
        ;
        textView.text  = [NSString stringWithFormat:@"●%@",textView.text];
    }
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    if (textView.contentSize.height != textView.frame.size.height) {
        CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:textView.tag];
        [self updateFrame:custonmeText];
    }
    textView.frame = frame;
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        NSInteger tag = textView.tag + 1;
        if ((CustomTextView *)[self.view viewWithTag:tag]) {
            CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:tag];
            [custonmeText becomeFirstResponder];
        }else{
            CustomTextView *cutomeText = [CustomTextView setUpTextView:CGRectMake(3, CGRectGetMaxY(textView.frame) + 10, [[UIScreen mainScreen] bounds].size.width - 6, 0) text:@"" tag:tag];
            cutomeText.delegate = self;
            [_stringArray addObject:@"tag"];
            [self.view addSubview:cutomeText];
        }
        return NO;
        
    }else if([text isEqualToString:@""]){
        if(textView.text.length == 1 && (long)textView.tag > 1){
            if ((long)textView.tag != _stringArray.count) {
                [self updataTag:(CustomTextView *)[self.view viewWithTag:textView.tag]];
            }
            [_stringArray removeLastObject];
            [textView removeFromSuperview];
            NSInteger tag = (long)textView.tag - 1;
            CustomTextView *tempText = (CustomTextView *)[self.view viewWithTag:tag];
            [tempText becomeFirstResponder];
            return NO;
        }else if((long)textView.tag == 1 && textView.text.length == 1){
            if ((long)textView.tag != _stringArray.count) {
                [self updataTag:(CustomTextView *)[self.view viewWithTag:textView.tag]];
            }
            if (_stringArray.count != 1) {
                [_stringArray removeLastObject];
                [textView removeFromSuperview];
            }
            textView.text = @"●";
        }
    }
    return  YES;
}


- (void)updateFrame:(CustomTextView *)textView
{
    CGFloat orignY = textView.contentSize.height + textView.frame.origin.y;
    for (NSInteger i = textView.tag + 1; i <= _stringArray.count + 1; i ++) {
        CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:i];
        CGRect frame = custonmeText.frame;
        frame.origin.y = orignY + 10;
        custonmeText.frame = frame;
        orignY = frame.origin.y + custonmeText.contentSize.height;
    }
}

- (void)updataTag:(CustomTextView *)textView
{
    NSInteger tempTag = textView.tag;
    textView.tag = 100000;
    for (NSInteger i = tempTag + 1; i <= _stringArray.count + 1; i ++) {
        CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:i];
        [custonmeText setTag:i - 1];
    }
    
    CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:tempTag];
    CGRect frame = custonmeText.frame;
    frame.origin.y = frame.origin.y - 50;
    custonmeText.frame = frame;
    [self updateFrame:custonmeText];
}


@end
