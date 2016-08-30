//
//  ManListCell.h
//  Meet
//
//  Created by jiahui on 16/4/29.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Meet-Swift.h"

@class HomeModel;

typedef void(^LikeButtonBlock)(BOOL isLike, NSString *user_id);

@interface ManListCell : UITableViewCell

@property (nonatomic, strong) UIButton *likeBtn;

@property (assign, nonatomic) NSInteger index;

@property (nonatomic, strong) LikeButtonBlock block;

+ (void)homeNameLabelColor:(UILabel *)nameLable;

- (void)configCell:(HomeModel *)model interstArray:(NSArray *)interstArray;

- (void)reloadLikeBtnImage:(BOOL)isLike;

- (void)reloadNumberOfMeet:(BOOL)isLike number:(NSInteger)number;

@end
