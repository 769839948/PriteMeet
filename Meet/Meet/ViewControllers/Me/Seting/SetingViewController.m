//
//  SetingViewController.m
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "SetingViewController.h"
#import "UISheetView.h"
#import <MessageUI/MessageUI.h>
#import "AboutViewController.h"
#import "UserInfo.h"
#import "UIViewController+hideExcessLine.h"

@interface SetingViewController ()<UITableViewDelegate,UITableViewDataSource,UISheetViewDelegate,MFMailComposeViewControllerDelegate> {
    NSArray *_contentArray;
    NSDictionary *_contentDic;
    UISheetView *_sheetView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [UITools customNavigationLeftBarButtonForController:self action:@selector(backButtonAction:)];
    self.navigationItem.title = @"设置";
    self.tableView.backgroundColor = [UIColor whiteColor];
    _contentArray = @[@"新消息通知",@"清除缓存",@"关于我们",@"意见反馈",@"赏个好评",@"退出登录"];
//    _contentDic = @{@0:@[@"清除缓存"],@1:@[@"关于Meet",@"意见反馈",@"给Meet好评"],@2:@[@"退出登录"]};
    
    _tableView.rowHeight = 49;
    [self hideExcessLine:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 90;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const defaultIdentifier = @"defaultIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;

    if (indexPath.row == 5) {
        UILabel *logOut = [[UILabel alloc] initWithFrame:CGRectMake(15, 54, 56, 20)];
        logOut.text = _contentArray[indexPath.row];
        logOut.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
        logOut.textColor = [UIColor colorWithHexString:TableViewTextColor];
        [cell.contentView addSubview:logOut];
    }else{
        cell.textLabel.text = _contentArray[indexPath.row];
        cell.textLabel.font = SettingViewLabelFont;
        cell.textLabel.textColor = [UIColor colorWithHexString:TableViewTextColor];
    }
    
    if (indexPath.row == 1 || indexPath.row == 5) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        [self performSegueWithIdentifier:@"PushToAboutViewController" sender:self];

    }else if (indexPath.row == 3){
        if (![MFMailComposeViewController canSendMail]) {
            NSLog(@"Mail services are not available.");
            [[UITools shareInstance] showMessageToView:self.view message:@"请先设置邮箱帐号" autoHide:YES];
            return;
        }
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        // Configure the fields of the interface.、/////@"feedback@momeet.com"
        //Email
        NSString *email = [UserInfo sharedInstance].user_name;
        if (email != nil && email.length > 1) {
            [composeVC setToRecipients:@[email]];
        } else
            [composeVC setToRecipients:@[@"feedback@momeet.com"]];
        [composeVC setSubject:@"意见反馈"];
        [composeVC setMessageBody:@"test message " isHTML:NO];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    }else if (indexPath.row == 4){
        
    }else{
        if ( !_sheetView) {
            _sheetView = [[UISheetView alloc] initWithContenArray:@[@"退出登录",@"取消"] titleMessage:@"退出后依然会保留当前用户信息"];
            _sheetView.delegate = self;
        }
        [AppData shareInstance].isLogin = NO;
        [_sheetView show];
    }
    
}

#pragma mark - 
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    NSString *msg;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            break;
    }
    [[UITools shareInstance] showMessageToView:controller.view message:msg autoHide:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    });
  
}

#pragma mark - UISheetViewDelegate
- (void)sheetView:(UISheetView *)sheet didSelectRowAtIndex:(NSInteger)index {
    if (index == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogoutNotification" object:nil];
        [UserInfo logout];
        [AppData shareInstance].isLogin = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [_sheetView hidden];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
