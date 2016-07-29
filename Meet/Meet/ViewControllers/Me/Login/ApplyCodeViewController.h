//
//  ApplyCodeViewController.h
//  Meet
//
//  Created by Zhang on 7/8/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "MyProfileViewController.h"

typedef void (^ShowToolsBlock)();
typedef void (^LoginViewShow)();

@interface ApplyCodeViewController : MyProfileViewController


@property (nonatomic, strong) ShowToolsBlock showToolsBlock;
@property (nonatomic, strong) LoginViewShow loginViewBlock;

@end
