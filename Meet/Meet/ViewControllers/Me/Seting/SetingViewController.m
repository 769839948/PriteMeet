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
#import "NSFileManager+Cache.h"
#import "NSFileManager+Paths.h"
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
    _contentArray = @[@"新消息通知",@"清除缓存",@"关于我们",@"反馈吐槽",@"喜欢Meet? 去赏个好评",@"退出登录"];
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
    
    if (indexPath.row == 1) {
        UILabel *cacheLable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 16, ScreenWidth/2 - 20, 16)];
        cacheLable.font = SettingViewLabelFont;
        cacheLable.textAlignment = NSTextAlignmentRight;
        if ([[self cacheSize] integerValue] < 1) {
            cacheLable.text = @"";
        }else{
            cacheLable.text = [self cacheSize];
        }
        cacheLable.textColor = [UIColor colorWithHexString:TableViewTextColor];
        [cell.contentView addSubview:cacheLable];
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
//        __weak typeof(self) weakSelf = self;
        [EMAlertView showAlertWithTitle:nil message:@"确定清除缓存？" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            if (buttonIndex == 1) {
                [NSFileManager clearCache:[NSFileManager jk_cachesPath]];
                [self.tableView reloadData];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
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
        NSString *email = @"769839948@qq.com";
        if (email != nil && email.length > 1) {
            [composeVC setToRecipients:@[email]];
        } else
            [composeVC setToRecipients:@[@"feedback@momeet.com"]];
        [composeVC setSubject:@"意见反馈"];
        [composeVC setMessageBody:@"test message " isHTML:NO];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    }else if (indexPath.row == 4){
        NSString *str = [NSString stringWithFormat:
                         @"https://itunes.apple.com/cn/app/id444934666?mt=8"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        __weak typeof(self) weakSelf = self;
        [EMAlertView showAlertWithTitle:nil message:@"确定退出登录？" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            if (buttonIndex == 1) {
                [UserInfo logout];
                [AppData shareInstance].isLogin = NO;
                if (weakSelf.logoutBlock) {
                    weakSelf.logoutBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"退出",nil];

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


/**
 *  计算缓存大小
 *
 *  @return 返回 NSString 大小
 */
-(NSString *)cacheSize
{
    NSString *roundSize = [self notRounding:[NSFileManager folderSizeAtPath:[NSFileManager jk_cachesPath]] afterPoint:2];
    NSString *cahceSize = [NSString stringWithFormat:@"%@M",roundSize];
    return cahceSize;
}
/**
 *  四舍五入问题
 *
 *  @param price    传入float 参数
 *  @param position 保留小数点后几位
 *
 *  @return 返回NSString
 */
-(NSString *)notRounding:(float)price afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
