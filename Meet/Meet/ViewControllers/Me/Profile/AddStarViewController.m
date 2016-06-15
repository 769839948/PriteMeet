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
#import "AutomaticBulletAndNumberLists.h"
#import "UserInfoViewModel.h"

@interface AddStarViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UserInfoViewModel *viewModel;

@end

@implementation AddStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel = [[UserInfoViewModel alloc] init];
    self.navigationItem.title = @"描述个人亮点";
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(3, 0, self.view.bounds.size.width - 6, self.view.bounds.size.height)];
    _textView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _textView.placeholder = @"添更多亮点，更有利于别人搜索到你";
    _textView.delegate = self;
    _textView.text = @"1 地方不开门地方不开门\n2 好纠结快快快\n3 呵呵几节课\n4 刚好回家";
    if (IOS_7LAST) {
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.view addSubview:_textView];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = NO;
}

#pragma mark - action
- (void)leftItemClick:(UINavigationItem *)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (IBAction)saveAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [_viewModel addStar:_textView.text success:^(NSDictionary *object) {
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
    // Add "1" when the user starts typing into the text field
    if (range.location == 0 && textView.text.length == 0) {
        
        // If the user simply presses enter, ignore the newline
        // entry, but add "1" to the start of the line.
        if ([text isEqualToString:@"\n"]) {
            [textView setText:@"1 "];
            NSRange cursor = NSMakeRange(range.location + 3, 0);
            textView.selectedRange = cursor;
            return NO;
        }
        
        // In all other scenarios, append the replacement text.
        else {
            [textView setText:[NSString stringWithFormat:@"1 %@", text]];
        }
    }
    
    // goBackOneLine is a Boolean to indicate whether the cursor
    // should go back 1 line; set to YES in the case that the
    // user has deleted the number at the start of the line
    bool goBackOneLine = NO;
    
    // Get a string representation of the current line number
    // in order to calculate cursor placement based on the
    // character count of the number
    NSString *stringPrecedingReplacement = [textView.text substringToIndex:range.location];
    NSString *currentLine = [NSString stringWithFormat:@"%lu", [stringPrecedingReplacement componentsSeparatedByString:@"\n"].count + 1];
    
    // If the replacement string either contains a new line
    // character or is a backspace, proceed with the following
    // block...
    if ([text rangeOfString:@"\n"].location != NSNotFound || range.length == 1) {
        
        // Combine the new text with the old
        NSString *combinedText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        // Seperate the combinedText into lines
        NSMutableArray *lines = [[combinedText componentsSeparatedByString:@"\n"] mutableCopy];
        
        // To handle the backspace condition
        if (range.length == 1) {
            
            // If the user deletes the number at the beginning of the line,
            // also delete the newline character proceeding it
            // Check to see if the user's deleting a number and
            // if so, keep moving backwards digit by digit to see if the
            // string's preceeded by a newline too.
            if ([textView.text characterAtIndex:range.location] >= '0' && [textView.text characterAtIndex:range.location] <= '9') {
                
                NSUInteger index = 1;
                char c = [textView.text characterAtIndex:range.location];
                while (c >= '0' && c <= '9') {
                    
                    c = [textView.text characterAtIndex:range.location - index];
                    
                    // If a newline is found directly preceding
                    // the number, delete the number and move back
                    // to the preceding line.
                    if (c == '\n') {
                        combinedText = [textView.text stringByReplacingCharactersInRange:NSMakeRange(range.location - index, range.length + index) withString:text];
                        
                        lines = [[combinedText componentsSeparatedByString:@"\n"] mutableCopy];
                        
                        // Set this variable so the cursor knows to back
                        // up one line
                        goBackOneLine = YES;
                        
                        break;
                    }
                    index ++;
                }
            }
            
            // If the user attempts to delete the number 1
            // on the first line...
            if (range.location == 1) {
                
                NSString *firstRow = [lines objectAtIndex:0];
                
                // If there's text left in the current row, don't
                // remove the number 1
                if (firstRow.length > 3) {
                    return  NO;
                }
                
                // Else if there's no text left in text view other than
                // the 1, don't let the user delete it
                else if (lines.count == 1) {
                    return NO;
                }
                
                // Else if there's no text in the first row, but there's text
                // in the next, move the next row up
                else if (lines.count > 1) {
                    [lines removeObjectAtIndex:0];
                }
            }
        }
        
        // Using a loop, remove the numbers at the start of the lines
        // and store the new strings in the linesWithoutLeadingNumbers array
        NSMutableArray *linesWithoutLeadingNumbers = [[NSMutableArray alloc] init];
        
        // Go through each line
        for (NSString *string in lines) {
            
            // Use the following string to make updates
            NSString *stringWithoutLeadingNumbers = [string copy];
            
            // Go through each character
            for (int i = 0; i < (int)string.length ; i++) {
                
                char c = [string characterAtIndex:i];
                
                // If the character's a number, remove it
                if (c >= '0' && c <= '9') {
                    stringWithoutLeadingNumbers = [stringWithoutLeadingNumbers stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                } else {
                    // And break from the for loop since the number
                    // and subsequent space have been removed
                    break;
                }
            }
            
            // Remove the white space before and after the string to
            // clean it up a bit
            stringWithoutLeadingNumbers = [stringWithoutLeadingNumbers stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [linesWithoutLeadingNumbers addObject:stringWithoutLeadingNumbers];
        }
        
        // Using a loop, add the numbers to the start of the lines
        NSMutableArray *linesWithUpdatedNumbers = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i < linesWithoutLeadingNumbers.count ; i ++) {
            NSString *updatedString = [linesWithoutLeadingNumbers objectAtIndex:i];
            NSString *lineNumberString = [NSString stringWithFormat:@"%d ", i + 1];
            updatedString = [lineNumberString stringByAppendingString:updatedString];
            [linesWithUpdatedNumbers addObject:updatedString];
        }
        
        // Then combine the array back into a string by re-adding the
        // new lines
        NSString *combinedString = @"";
        
        for (int i = 0 ; i < linesWithUpdatedNumbers.count ; i ++) {
            combinedString = [combinedString stringByAppendingString:[linesWithUpdatedNumbers objectAtIndex:i]];
            if (i < linesWithUpdatedNumbers.count - 1) {
                combinedString = [combinedString stringByAppendingString:@"\n"];
            }
        }
        
        // Set the cursor appropriately.
        NSRange cursor;
        if ([text isEqualToString:@"\n"]) {
            cursor = NSMakeRange(range.location + currentLine.length + 2, 0);
        } else if (goBackOneLine) {
            cursor = NSMakeRange(range.location - 1, 0);
        } else {
            cursor = NSMakeRange(range.location, 0);
        }
        
        textView.selectedRange = cursor;
        
        // And update the text view
        [textView setText:combinedString];
        
        return NO;
    }
    
    return YES;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        // When the user hits 'return,' perform auto list continuation for bulleted and numbered lists:
//        return [AutomaticBulletAndNumberLists autoContinueListsForTextView:textView editingAtRange:range];
//    }
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
