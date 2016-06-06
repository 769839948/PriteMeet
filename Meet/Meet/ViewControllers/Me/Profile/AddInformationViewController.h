//
//  AddInformationViewController.h
//  Meet
//
//  Created by jiahui on 16/5/5.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ViewEditType) {
    ViewTypeEdit,
    ViewTypeAdd,
    ViewTypeDelete,
};

typedef void (^AddInfoBlock)(NSIndexPath *indexPath, NSString *string,ViewEditType type);


@interface AddInformationViewController : UIViewController

@property (strong, nonatomic) AddInfoBlock block;

@property (copy, nonatomic) NSArray *arrayTitles;
@property (copy, nonatomic) NSString *cachTitles;
@property (copy, nonatomic) NSString *navTitle;
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) ViewEditType viewType;

@end
