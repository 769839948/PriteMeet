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
#import "ServiceViewModel.h"
#import "AboutViewController.h"
#import "Masonry.h"

typedef NS_ENUM(NSUInteger, RowType) {
    RowBlackList,
    RowNotification,
    RowApplicationCarsh,
    RowAboutUs,
    RowFeedBack,
    RowRate,
    RowLogOut,
};


@interface SetingViewController ()<UITableViewDelegate,UITableViewDataSource,UISheetViewDelegate,MFMailComposeViewControllerDelegate> {
    NSArray *_contentArray;
    NSDictionary *_contentDic;
    UISheetView *_sheetView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ServiceViewModel *viewModel;
@property (copy, nonatomic) NSString *appUrl;
@property (copy, nonatomic) NSString *tellPhone;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appUrl = @"";
    _tellPhone = @"";
    self.navigationItem.title = @"设置";
    self.tableView.backgroundColor = [UIColor whiteColor];
    _contentArray = @[@"黑名单列表",@"新消息通知",@"清除缓存",@"关于我们",@"反馈吐槽",@"喜欢Meet? 去赏个好评",@"退出登录"];
    [self getServiceData];
    _tableView.rowHeight = 49;
    [self hideExcessLine:_tableView];
    [self navigationItemWithLineAndWihteColor];

}

- (void)setUpNavigationBar
{
    [self createNavigationBar];
}

- (void)getServiceData
{
    _viewModel = [[ServiceViewModel alloc] init];
    [_viewModel requestService:^(NSDictionary *object) {
        _appUrl = object[@"evaluate_address"];
        _tellPhone = object[@"phone_num"];
    } failBlock:^(NSDictionary *object) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createNavigationBar];
//    [self navigationItemWithLineAndWihteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
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
    if (indexPath.row == RowLogOut) {
        return 90;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const defaultIdentifier = @"defaultIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defaultIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;

    if (indexPath.row == RowLogOut) {
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
    
    if (indexPath.row == RowApplicationCarsh) {
        cell.detailTextLabel.font = SettingViewLabelFont;
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:MeViewProfileContentLabelColor];
        if ([[self cacheSize] integerValue] < 1) {
            cell.detailTextLabel.text = @"";
        }else{
            cell.detailTextLabel.text = [self cacheSize];
        }
    }
    
    UILabel *cellLineLabel = [[UILabel alloc] init];
    if (indexPath.row == RowLogOut) {
        cellLineLabel.frame = CGRectMake(15, 89, ScreenWidth - 30, 0.5);
    }else{
        cellLineLabel.frame = CGRectMake(15, 49, ScreenWidth - 30, 0.5);
    }
    cellLineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
    [cell.contentView addSubview:cellLineLabel];
    
    if (indexPath.row == RowNotification || indexPath.row == RowLogOut) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == RowBlackList) {
        if (![UserInfo isLoggedIn]) {
            [[UITools shareInstance] showMessageToView:self.view message:@"请登录后在查看" autoHide:YES];
        }else{
            [self performSegueWithIdentifier:@"BlackListViewController" sender:self];
        }
    }else if (indexPath.row == RowNotification) {
        [[UITools shareInstance] showMessageToView:self.view message:@"敬请期待" autoHide:YES];
    }else if (indexPath.row == RowApplicationCarsh){
        [EMAlertView showAlertWithTitle:nil message:@"确定清除缓存？" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            if (buttonIndex == 1) {
                [NSFileManager clearCache:[NSFileManager jk_cachesPath]];
                [self.tableView reloadData];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    }else if (indexPath.row == RowAboutUs){
        [self performSegueWithIdentifier:@"PushToAboutViewController" sender:self];

    }else if (indexPath.row == RowFeedBack){
        if (![MFMailComposeViewController canSendMail]) {
            NSLog(@"Mail services are not available.");
            [[UITools shareInstance] showMessageToView:self.view message:@"请先设置邮箱帐号" autoHide:YES];
            return;
        }
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        composeVC.mailComposeDelegate = self;
        // Configure the fields of the interface.、/////@"feedback@momeet.com"
        //Email
        NSString *email = @"769839948@qq.com";
        if (email != nil && email.length > 1) {
            [composeVC setToRecipients:@[email]];
        } else
            [composeVC setToRecipients:@[@"feedback@momeet.com"]];
        [composeVC setSubject:@"意见反馈"];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    }else if (indexPath.row == RowRate){
        NSString *str = @"";
        if ([_appUrl isEqualToString:@""]) {
            str = [NSString stringWithFormat:
                   @"https://itunes.apple.com/cn/app/id444934666?mt=8"];
        }else{
            str = _appUrl;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        __weak typeof(self) weakSelf = self;
        [EMAlertView showAlertWithTitle:nil message:@"确定退出登录？" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            if (buttonIndex == 1) {
                [UserInfo logout];
                [NSFileManager clearCache:[NSFileManager jk_cachesPath]];
                [AppData shareInstance].isLogin = NO;
                if (weakSelf.logoutBlock) {
                    weakSelf.logoutBlock();
                }
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
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
    if ([segue.identifier isEqualToString:@"PushToAboutViewController"]) {
        AboutViewController *aboutView = (AboutViewController *)[segue destinationViewController];
        aboutView.phone = _tellPhone;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
