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
#import "WXUserInfo.h"
#import "Meet-Swift.h"

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
    __weak typeof(self) weakSelf = self;
    [self mappingUserInfoWithDicValues];
    [self.viewModel updateUserInfo:[UserInfo sharedInstance] withStateArray:[self.stateArray copy] success:^(NSDictionary *object) {
        [[UITools shareInstance] showMessageToView:self.view message:@"保存成功" autoHide:YES];
        UIImage *image = self.dicValues[self.titleContentArray[0]];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSString *saveImagePath = [self imageSaveParth];
        if ([imageData writeToFile:saveImagePath atomically:NO]) {
            //        NSLog(@"保存 成功");
        }
        [weakSelf reloadUerImage:saveImagePath];
        UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
        SetInvitationViewController *invitationView = [meStoryBoard instantiateViewControllerWithIdentifier:@"SetInvitationViewController"];
        [weakSelf.navigationController pushViewController:invitationView animated:YES];
    } fail:^(NSDictionary *object) {
        [[UITools shareInstance] showMessageToView:self.view message:@"保存失败" autoHide:YES];
    } loadingString:^(NSString *str) {
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
