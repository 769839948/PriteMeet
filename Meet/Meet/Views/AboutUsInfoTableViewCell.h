//
//  AboutUsInfoTableViewCell.h
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void (^AboutUsButtonPress)();

@interface AboutUsInfoTableViewCell : BaseTableViewCell

@property (nonatomic, strong) AboutUsButtonPress block;

@property (nonatomic, strong) UIButton *aboutAll;


- (void)configCell:(NSArray *)stringArray withGender:(NSInteger)gender;

@end
