//
//  AddJobLabelTableViewCell.h
//  Meet
//
//  Created by Zhang on 7/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CellArray)(NSArray *array);

@interface AddJobLabelTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) CellArray block;

- (void)configCell:(NSArray *)array;

@end
