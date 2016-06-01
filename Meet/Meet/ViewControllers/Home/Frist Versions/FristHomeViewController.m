//
//  FristHomeViewController.m
//  Meet
//
//  Created by jiahui on 16/5/18.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "FristHomeViewController.h"
#import "MJRefresh.h"
#import "ManListCell.h"
#import "WeChatResgisterViewController.h"
#import "NSString+StringSize.h"

@interface FristHomeViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *numberMeet;

@end

@implementation FristHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpBottonView];
    [self setUpNavigationBar];
}

- (void)loadNewData {
    NSLog(@"ChoicenessViewController refreshing");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.class isSubclassOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        //         NSLog(@"Home interactivePopGestureRecognizer");
    }
    return YES;
}

- (void)setUpNavigationBar
{
    self.navigationItem.title = @"Meet";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"个人资料" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
}

- (void)setUpBottonView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 84, [[UIScreen mainScreen] bounds].size.height - 74 , 56, 54)];
    [_bottomView addSubview:[self myMeetBt:CGRectMake(0, 0, 54, 54)]];
    [_bottomView addSubview:[self myMeetNumber:CGRectMake(_bottomView.frame.size.width - 18, 0, 18, 18)]];
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:_bottomView];
}

- (UIButton *)myMeetBt:(CGRect)frame
{
    UIButton *meetBt = [UIButton buttonWithType:UIButtonTypeCustom];
    meetBt.frame = frame;
    meetBt.layer.cornerRadius = frame.size.width/2;
    meetBt.layer.backgroundColor = [[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0] CGColor];
    
    return meetBt;
}

- (UILabel *)myMeetNumber:(CGRect)frame
{
    _numberMeet = [[UILabel alloc] initWithFrame:frame];
    _numberMeet.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    _numberMeet.text = @"6";
    _numberMeet.font = [UIFont systemFontOfSize:9.0];
    _numberMeet.textColor = [UIColor whiteColor];
    _numberMeet.textAlignment = NSTextAlignmentCenter;
    _numberMeet.clipsToBounds = YES;
    _numberMeet.layer.cornerRadius = 9;
    return _numberMeet;
}

- (void)setUpTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark - NavigationBarButtonClick
- (void)leftItemClick:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"筛选" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"智能推荐",@"离我最近", nil];
    [actionSheet showInView:self.view];
}


#pragma make - UITableViewDelegate&DataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSArray *array = @[@"旅行顾问",@"创意总监",@"谈判专家",@"顾问",@"测试一下",@"come on"];
    NSString *instresTitleString = @"  ";
    for (NSString *instrestTitle in array) {
        instresTitleString = [instresTitleString stringByAppendingString:instrestTitle];
        instresTitleString = [instresTitleString stringByAppendingString:@"  "];
    }
    float instrestHeight = [instresTitleString heightWithFont:[UIFont fontWithName:@"PingFangSC-Light" size:20.0f] constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
    
    float titleHeight = [@"陈涛 美匠科技联合创始人这是一条测试数据来看看会不会换行" heightWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:22.55f] constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
    //    NSString *reuseIdentifier = cellIndef;
    //    MainTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    //    if (!cell) {
    //        cell = [[MainTableViewCell alloc] init];
    //        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    //        [cell configCell:@"陈涛 美匠科技联合创始人这是一条测试数据来看看会不会换行" array:@[@"旅行顾问",@"创意总监",@"谈判专家",@"顾问"] string:@"62人想见   和你相隔 820M"];
    //        [cell setNeedsUpdateConstraints];
    //        [cell updateConstraintsIfNeeded];
    ////        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    ////        [cell setNeedsLayout];
    ////        [cell layoutIfNeeded];
    //        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //    }
    height = instrestHeight + titleHeight + 320 - 30 - 27;
    return height;
    //    return 360;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndef = @"MainTableViewCell";
    ManListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndef];
    
    if (cell == nil) {
        cell = [[ManListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndef];
    }
    [cell configCell:@"陈涛 美匠科技联合创始人这是一条测试数据来看看会不会换行" array:@[@"旅行顾问",@"创意总监",@"谈判专家",@"顾问",@"测试一下",@"come on"] string:@"62人想见   和你相隔 820M"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([AppData shareInstance].isLogin) {
        
    } else {
//        UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//        WeChatResgisterViewController *resgisterVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"WeChatResgisterNavigation"];
//        [self presentViewController:resgisterVC animated:YES completion:^{
//            
//        }];
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
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
