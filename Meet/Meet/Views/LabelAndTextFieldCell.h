//
//  LabelAndTextFieldCell.h
//  Meet
//
//  Created by jiahui on 16/5/4.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellTextField;
@interface LabelAndTextFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titelLabel;
@property (weak, nonatomic) IBOutlet CellTextField *textField;

@property (nonatomic, strong) UILabel *lineLabel;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
