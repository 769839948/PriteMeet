//
//  BaseUserInfoViewController.m
//  Meet
//
//  Created by Zhang on 6/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseUserInfoViewController.h"
#import "LabelAndTextFieldCell.h"
#import "UISheetView.h"
#import "UserInfoViewModel.h"


@interface BaseUserInfoViewController ()


@end

@implementation BaseUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
}

- (void)nextStep:(UIBarButtonItem *)sender
{
    if (self.selectRow == 2 && !self.chooseView.hidden) {////Sex Item alert
        [self sexItemModify];
        return ;
    }
    if ([self.headImageUrl isEqualToString:@""]) {
        [UserInfo shareInstance].headimgurl = [WXUserInfo shareInstance].headimgurl;
    }else{
        [UserInfo shareInstance].headimgurl =  self.headImageUrl;
        
    }
    __weak typeof(self) weakSelf = self;
    [self mappingUserInfoWithDicValues];
    [self.viewModel updateUserInfo:[UserInfo shareInstance] withStateArray:[self.stateArray copy] success:^(NSDictionary *object) {
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:YES];
//        [[UserInfoDao shareInstance] updateBean:[UserInfo shareInstance]];
        [[UITools shareInstance] showMessageToView:self.view message:@"保存成功" autoHide:YES];
        UIImage *image = self.dicValues[self.titleContentArray[0]];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSString *saveImagePath = [self imageSaveParth];
        if ([imageData writeToFile:saveImagePath atomically:NO]) {
            //        NSLog(@"保存 成功");
        }
        [weakSelf reloadUerImage:saveImagePath];
        
        
    } fail:^(NSDictionary *object) {
        [[UITools shareInstance] showMessageToView:self.view message:@"保存失败" autoHide:YES];
    } loadingString:^(NSString *str) {
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
