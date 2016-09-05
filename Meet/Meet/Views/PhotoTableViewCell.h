//
//  PhotoTableViewCell.h
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void (^ClickImageIndex)(NSInteger index, NSArray *imageArray, UIView *scourceView);

@interface PhotoTableViewCell : BaseTableViewCell

@property (nonatomic, strong) ClickImageIndex clickBlock;

- (void)configCell:(NSArray *)imageArray gender:(NSInteger)gender age:(NSInteger)age;

@end
