//
//  ManListCell.h
//  Meet
//
//  Created by jiahui on 16/4/29.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface ManListCell : UITableViewCell


@property (assign, nonatomic) NSInteger index;


+ (void)homeNameLabelColor:(UILabel *)nameLable;

- (void)configCell:(HomeModel *)model interstArray:(NSArray *)interstArray;

@end
