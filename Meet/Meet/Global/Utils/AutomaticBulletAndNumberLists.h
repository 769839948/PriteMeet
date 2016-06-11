//
//  AutomaticBulletAndNumberLists.h
//  UITextViewParagraph
//
//  Created by Zhang on 6/10/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 
 USAGE:
 Implement the -shouldChangeTextInRange:replacementText: method
 on your UITextViewDelegate as follows:
 
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 {
 if ([text isEqualToString:@"\n"]) {
 // When the user hits 'return,' perform auto list continuation for bulleted and numbered lists:
 return [AutomaticBulletAndNumberLists autoContinueListsForTextView:textView editingAtRange:range];
 }
 return YES;
 }
 
 */

@interface AutomaticBulletAndNumberLists : NSObject

// Simultaneously check to continue Bullet lists and Number lists:
+ (BOOL)autoContinueListsForTextView:(UITextView*)textView editingAtRange:(NSRange)range;

// Checks each list type individually:
+ (BOOL)autoContinueBulletListForTextView:(UITextView*)textView editingAtRange:(NSRange)range;
+ (BOOL)autoContinueNumberedListForTextView:(UITextView*)textView editingAtRange:(NSRange)range;

@end
