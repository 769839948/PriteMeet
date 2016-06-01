//
//  NSString+StringSize.m
//  Kaoban
//
//  Created by Jane on 8/25/15.
//  Copyright (c) 2015 kaoban. All rights reserved.
//

#import "NSString+StringSize.h"
#import <objc/runtime.h>
static char SCTextStorageKey;
static char SCLayoutManagerKey;
static char SCTextContainerKey;

@implementation NSString (StringSize)

/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGFloat) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
//    CGSize size = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, 9999)
//                   
//                       lineBreakMode:UILineBreakModeWordWrap];
//    
//    CGFloat delta = size.height; 
//    
//    return delta;
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}
- (float) heightWithFont:(UIFont *)font maxSize:(CGSize)maxSize andLinebreakMode:(NSLineBreakMode)linebreakMode
{
    NSTextStorage *textStorage = objc_getAssociatedObject(self, &SCTextStorageKey);
    NSLayoutManager *layoutManager = objc_getAssociatedObject(self, &SCLayoutManagerKey);
    NSTextContainer *textContainer = objc_getAssociatedObject(self, &SCTextContainerKey);
    
    if (!textStorage) {
        textStorage = [[NSTextStorage alloc] initWithString:self attributes:@{NSFontAttributeName : font}];
        objc_setAssociatedObject(self, &SCTextStorageKey, textStorage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (!textContainer) {
        textContainer = [[NSTextContainer alloc] init];
        [textContainer setLineBreakMode:linebreakMode];
        [textContainer setLineFragmentPadding:0.0f];
        objc_setAssociatedObject(self, &SCTextContainerKey, textContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [textContainer setSize:maxSize];
    
    if (!layoutManager) {
        layoutManager = [[NSLayoutManager alloc] init];
        [layoutManager addTextContainer:textContainer];
        objc_setAssociatedObject(self, &SCLayoutManagerKey, layoutManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [textStorage addLayoutManager:layoutManager];
    
    CGRect rect = [layoutManager usedRectForTextContainer:textContainer];
    return rect.size.height;
}

//+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
//{
//    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
//    detailTextView.font = [UIFont systemFontOfSize:fontSize];
//    detailTextView.text = value;
//    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
//    return deSize.height;
//}

+ (float) widthForString:(NSString *)value fontSize:(float)fontSize
{
    CGSize sizeName = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
                        constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                            lineBreakMode:NSLineBreakByWordWrapping];
    return sizeName.width;
}


@end
