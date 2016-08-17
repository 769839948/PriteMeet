//
//  ApplyCodeViewController.m
//  Meet
//
//  Created by Zhang on 7/8/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "ApplyCodeViewController.h"
#import "LoginViewModel.h"
#import "UserInfo.h"
#import "AddInformationViewController.h"

@interface ApplyCodeViewController ()

@property (nonatomic, strong) LoginViewModel *loginViewModel;

@property (nonatomic, copy) NSMutableArray *worke_exps;
@property (nonatomic, copy) NSMutableArray *edu_exps;

@end

@implementation ApplyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请邀请码";
    self.isApplyCode = YES;
    [self setNavigationBarItem];
    _loginViewModel = [[LoginViewModel alloc] init];
    _worke_exps = [[NSMutableArray alloc] init];
    _edu_exps = [[NSMutableArray alloc] init];
//    self.isBaseView = YES;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self navigationItemWithLineAndWihteColor];
    self.talKingDataPageName = @"Login-ApplyCode";
}

- (void)setNavigationBarItem
{
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navigationbar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonPress:)],[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    UIBarButtonItem *rightBtItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(applyCodePress:)];
    [rightBtItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:HomeDetailViewNameColor],NSFontAttributeName:NavigationBarRightItemFont} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtItem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:HomeDetailViewNameColor]];
}

- (void)leftBarButtonPress:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [UserInfo logout];
    if (self.loginViewBlock) {
        self.loginViewBlock();
    }
    UserDefaultsRemoveSynchronize(@"ApplyCodeAvatar");
}

- (void)applyCodePress:(UIBarButtonItem *)sender
{
    [self mappingUserInfoWithDicValues];
    if (UserDefaultsGetSynchronize(@"ApplyCodeAvatar") != nil && ![[UserInfo sharedInstance].job_label isEqualToString:@""] && ![[UserInfo sharedInstance].mobile_num isEqualToString:@""] && ![[UserInfo sharedInstance].location isEqualToString:@"0,0"]) {
        __weak typeof(self) weakSelf = self;
        [_loginViewModel applyCode:[UserInfo sharedInstance] workArray:_worke_exps eduArray:_edu_exps Success:^(NSDictionary *object) {
            [UserInfo logout];
            weakSelf.complyApplyCodeSuccess = YES;
            if (weakSelf.showToolsBlock) {
                weakSelf.showToolsBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } Fail:^(NSDictionary *object) {
            [[UITools shareInstance] showMessageToView:self.view message:@"请填写完全内容后再提交哦" autoHide:YES];
        } showLoding:^(NSString *str) {
            
        }];
    }else{
        [[UITools shareInstance] showMessageToView:self.view message:@"请填写完全内容后再提交哦" autoHide:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddInformationVC"]) {
        AddInformationViewController *addInfom = (AddInformationViewController *)[segue destinationViewController];
        addInfom.block = ^(NSIndexPath *path, NSString *string, ViewEditType type){
            if (type == ViewTypeAdd) {
                if (path.section == 2){
                    [self.arrayWorkExper addObject:string];
                    [_worke_exps addObject:string];
                    [self updateWorkUserFile:[self.arrayWorkExper copy] withId:[self.arrayWorkExper copy]];
                    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    [self.arrayEducateExper addObject:string];
                    [_edu_exps addObject:string];
                    [self updateEduUserFile:[self.arrayEducateExper copy] withEduId:[self.arrayEducateExper copy]];
                    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else if (type == ViewTypeEdit){
                if (path.section == 2){
                    [self.arrayWorkExper replaceObjectAtIndex:path.row - 1 withObject:string];
                    [_worke_exps replaceObjectAtIndex:path.row - 1 withObject:string];
                    [self updateWorkUserFile:[self.arrayWorkExper copy] withId:[self.arrayWorkExper copy]];
                    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    [self.arrayEducateExper replaceObjectAtIndex:path.row - 1 withObject:string];
                    [_edu_exps replaceObjectAtIndex:path.row - 1 withObject:string];
                    [self updateEduUserFile:[self.arrayEducateExper copy] withEduId:[self.arrayEducateExper copy]];
                    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                if (path.section == 2){
                    [self.arrayWorkExper removeObjectAtIndex:path.row - 1];
                    [self updateWorkUserFile:[self.arrayWorkExper copy] withId:[self.arrayWorkExper copy]];
                    [_worke_exps removeObjectAtIndex:path.row - 1];
                    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    [self.arrayEducateExper removeObjectAtIndex:path.row - 1];
                    [_edu_exps removeObjectAtIndex:path.row - 1];
                    [self updateEduUserFile:[self.arrayEducateExper copy] withEduId:[self.arrayEducateExper copy]];
                    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            }
        };
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            addInfom.indexPath = (NSIndexPath *)sender;
        }
        if (addInfom.indexPath.section == 2 || addInfom.indexPath.section == 3) {
            if (addInfom.indexPath.row == 0) {
                addInfom.viewType = ViewTypeAdd;
                
            }else{
                if (addInfom.indexPath.row == self.arrayWorkExper.count + 1 && addInfom.indexPath.section == 2) {
                    
                }else{
                    addInfom.viewType = ViewTypeEdit;
                    if (addInfom.indexPath.section == 2) {
                        addInfom.cachTitles = [self.arrayWorkExper objectAtIndex:addInfom.indexPath.row - 1];
                    }else{
                        addInfom.cachTitles = [self.arrayEducateExper objectAtIndex:addInfom.indexPath.row -1 ];
                        
                    }
                }
                
            }
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
