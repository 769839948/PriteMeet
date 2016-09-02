//
//  AboutUsInfoTableViewCell.h
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface AboutUsInfoTableViewCell : BaseTableViewCell

@property (nonatomic, strong) UIButton *aboutAll;

- (void)configCell:(NSString *)title info:(NSString *)info imageArray:(NSArray *)images withUrl:(NSString *)web_url;

@end
