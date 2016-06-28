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
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
#import "ProfileKeyAndValue.h"
#import "ThemeTools.h"
#import "Meet-Swift.h"
#import "HomeViewModel.h"
#import "MJExtension.h"
#import "HomeModel.h"
#import "UserInfo.h"
#import "UITools.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapLocationKit/AMapLocationManager.h>

@interface FristHomeViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *numberMeet;

@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HomeViewModel *viewModel;
@property (nonatomic, copy) NSMutableArray *homeModelArray;
@property (nonatomic, copy) NSMutableDictionary *offscreenCells;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation FristHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    _page = 0;
    _viewModel = [[HomeViewModel alloc] init];
    _homeModelArray = [NSMutableArray array];
    [self setUpNavigationBar];
    [self setUpRefreshView];
    [self setUpHomeData];
    [self setUpLocationManager];
    
    NSString *ipAddress = [[UITools shareInstance] getIPAddress:NO];
    
}

- (void)setUpLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为3s
    self.locationManager.locationTimeout =3;
    //   逆地理请求超时时间，最低2s，此处设置为3s
    self.locationManager.reGeocodeTimeout = 3;
    self.locationManager.delegate = self;
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == 1)
            {
                return;
            }
        }
        if ([UserInfo isLoggedIn]) {
            [weakSelf.viewModel senderLocation:location.coordinate.latitude longitude:location.coordinate.longitude];
        }
//        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

- (void)loadNewData {
    NSLog(@"ChoicenessViewController refreshing");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}


- (void)setUpHomeData
{
    _page ++;
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    __weak typeof(self) weakSelf = self;
    [_viewModel getHomeList:pageString successBlock:^(NSDictionary *object) {
        [weakSelf.homeModelArray addObjectsFromArray:[HomeModel  mj_objectArrayWithKeyValuesArray:object]];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failBlock:^(NSDictionary *object) {
        if (_page > 0) {
            _page --;
        }
        [weakSelf setUpHomeData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } loadingView:^(NSString *str) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBarTintColor:NavigationBarTintColorCustome];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.bottomView removeFromSuperview];
    [self.statusView removeFromSuperview];
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
    
    [self setStatusView];
}

- (void)rightItemPess:(UIBarButtonItem *)sender
{
    [self presentViewController:[[BaseNavigaitonController alloc] initWithRootViewController:[[MeViewController alloc] init]] animated:YES completion:^{
        
    }];
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
    
//    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bottomView];
}

- (void)setStatusView
{
    _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_statusView];
}

- (void)setUpRefreshView
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setUpHomeData)];

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
    [_tableView registerClass:[ManListCell class] forCellReuseIdentifier:@"MainTableViewCell"];
    [self.view addSubview:_tableView];
}

- (NSArray *)indexArray
{
    return _homeModelArray;
}

- (void)configureCell:(ManListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *model = self.indexArray[indexPath.section];
    [cell configCell:model interstArray:[model.personal_label componentsSeparatedByString:@","]];
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

    HomeModel *homeModel = _homeModelArray[indexPath.section];
    
    return [tableView fd_heightForCellWithIdentifier:@"MainTableViewCell" cacheByKey:[NSString stringWithFormat:@"%ld",(long)homeModel.uid] configuration:^(ManListCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
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
    return _homeModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndef = @"MainTableViewCell";
    ManListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndef forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MeetDetailViewController *meetDetailView = [[MeetDetailViewController alloc] init];
    [meetDetailView showNavbar];
    HomeModel *model = [_homeModelArray objectAtIndex:indexPath.section];
    meetDetailView.user_id = [NSString stringWithFormat:@"%ld",(long)model.uid];
    [self.navigationController pushViewController:meetDetailView animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (scrollView.contentOffset.y <= 0){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:TableViewBackGroundColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    if (translation.y < 0)
    {
        _bottomView.hidden = YES;
        _statusView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }else if(translation.y > 0){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        _statusView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = NO;
    }
    
    if (scrollView.contentOffset.y <= 0){
        
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}

#pragma mark - AMapLocationDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

/**
 *  开始监控region回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 开始监控的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didStartMonitoringForRegion:(AMapLocationRegion *)region
{
    
}
/**
 *  进入region回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 进入的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region
{
    
}


@end
