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
#import "UIViewController+ScrollingNavbar.h"
#import "Meet-Swift.h"
#import "MJRefresh.h"
#import "ProfileKeyAndValue.h"
#import "MeViewController.h"
#import "ThemeTools.h"


@interface FristHomeViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *numberMeet;

@end

@implementation FristHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpNavigationBar];
    [self setUpRefreshView];
    
}

- (void)loadNewData {
    NSLog(@"ChoicenessViewController refreshing");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setUpBottonView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBarTintColor:NavigationBarTintColorCustome];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.bottomView removeFromSuperview];
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:YES];
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
    self.navigationItem.titleView = [self titleView];
    self.navigationItem.title = @"Meet";
    UIButton *fillteBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [fillteBt setImage:[UIImage imageNamed:@"navigationbar_fittle"] forState:UIControlStateNormal];
    [fillteBt setFrame:CGRectMake(0, 0, 40, 40)];
    [fillteBt addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:fillteBt];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    if (IOS_7LAST) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    UIButton *icon_User = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon_User setImage:[UIImage imageNamed:@"Icon_User"] forState:UIControlStateNormal];
    [icon_User setFrame:CGRectMake(0, 0, 40, 40)];
    [icon_User addTarget:self action:@selector(rightItemPess:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:icon_User];
}

- (void)rightItemPess:(UIBarButtonItem *)sender
{
    UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MeViewController *meViewController = [meStoryBoard instantiateViewControllerWithIdentifier:@"MeViewController"];
    [self.navigationController pushViewController:meViewController animated:YES];
}

- (UIView *)titleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:titleView.frame];
    imageView.image = [UIImage imageNamed:@"navigationbar_title"];
    [titleView addSubview:imageView];
    return titleView;
}

- (void)setUpBottonView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 84, [[UIScreen mainScreen] bounds].size.height - 74, 56, 54)];
    [_bottomView addSubview:[self myMeetBt:CGRectMake(0, 0, 54, 54)]];
    [_bottomView addSubview:[self myMeetNumber:CGRectMake(_bottomView.frame.size.width - 18, 0, 18, 18)]];
    [[UIApplication sharedApplication].keyWindow addSubview:_bottomView];
}

- (void)setUpRefreshView
{
//    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        <#code#>
//    }]
}

- (UIButton *)myMeetBt:(CGRect)frame
{
    UIButton *meetBt = [UIButton buttonWithType:UIButtonTypeCustom];
    meetBt.frame = frame;
    meetBt.layer.cornerRadius = frame.size.width/2;
//    [meetBt setBackgroundImage:[UIImage imageNamed:@"meet_order"] forState:UIControlStateNormal];
    [meetBt setImage:[UIImage imageNamed:@"meet_order"] forState:UIControlStateNormal];
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
    [self followScrollView:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:TableViewBackGroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark - NavigationBarButtonClick
- (IBAction)leftItemClick:(UIBarButtonItem *)sender
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
    NSArray *array = @[];
    //    NSArray *array = @[@"培养功夫",@"体态训练",@"金牌得主",@"私教",@"杨氏太极第六代"];
    float instrestHeight = 0;
    if (array.count == 0) {
        instrestHeight = 0.0;
    }else{
        NSString *instresTitleString = @"  ";
        for (NSString *instrestTitle in array) {
            instresTitleString = [instresTitleString stringByAppendingString:instrestTitle];
            instresTitleString = [instresTitleString stringByAppendingString:@"  "];
        }
        instrestHeight = [instresTitleString heightWithFont:[UIFont fontWithName:@"PingFangSC-Light" size:24.0f] constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
    }

    
    
    float titleHeight = [@"叶泳湘 杨氏太极第六代女传人 国际武术金牌" heightWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:22.55f] constrainedToWidth:[[UIScreen mainScreen] bounds].size.width - 20];
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
    height = instrestHeight + titleHeight + 320 - 30 - 27 - 200 + ([[UIScreen mainScreen] bounds].size.width - 20)*200/355;
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
    NSArray *array = @[];
    //    NSArray *array = @[@"培养功夫",@"体态训练",@"金牌得主",@"私教",@"杨氏太极第六代"];
    [cell configCell:@"叶泳湘 杨氏太极第六代女传人 国际武术金牌" array:array string:@"92人想见   和你相隔 820m "];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MeetDetailViewController *meetDetailView = [[MeetDetailViewController alloc] init];
    [meetDetailView showNavbar];
    [self.navigationController pushViewController:meetDetailView animated:YES];
//    if ([AppData shareInstance].isLogin) {
//        
//    } else {
//        
//    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y < 0)
    {
        _bottomView.hidden = YES;
    }else if(translation.y > 0){
        _bottomView.hidden = NO;
    }else{
        
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
