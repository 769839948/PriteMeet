//
//  BaseTableViewCell.h
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *showdowView;
@property (nonatomic, strong) UIView *whitView;
@property (nonatomic, assign) BOOL didSetupConstraints;

/**
 *  设置那个方向圆角
 *
 *  @param controllerArray [1,0,0,0] 代表 左上、右上、左下、右下
 */
- (void)setCircular:(NSArray *)controllerArray;

/**
 *  暂时的解决办法
 *
 *  @param isOnBottom 是否在线内
 */
- (void)setWhiteView:(BOOL)isOnBottom isMoreCell:(BOOL)isMoreCell
;

- (void)setWhiteView:(BOOL)isCornerRadius isBottom:(BOOL)isBottom;

@end
