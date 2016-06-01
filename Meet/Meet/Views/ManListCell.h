//
//  ManListCell.h
//  Meet
//
//  Created by jiahui on 16/4/29.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManListCell : UITableViewCell

- (void)configCell:(NSString *)title array:(NSArray *)array string:(NSString *)string;

@property (assign, nonatomic) NSInteger index;

@end
