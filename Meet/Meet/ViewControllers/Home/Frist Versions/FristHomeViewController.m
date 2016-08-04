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
#import "NSString+StringSize.h"
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
#import "AMScrollingNavbar.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapLocationKit/AMapLocationManager.h>

typedef NS_ENUM(NSInteger, FillterName) {
    NomalList,
    LocationList,
    ReconmondList,
};


@interface FristHomeViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate,ScrollingNavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *numberMeet;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) HomeViewModel *viewModel;
@property (nonatomic, copy) NSMutableArray *homeModelArray;
@property (nonatomic, copy) NSMutableDictionary *offscreenCells;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) double logtitude;
@property (nonatomic, assign) double latitude;

@property (nonatomic, assign) FillterName fillterName;

@end

@implementation FristHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fillterName = ReconmondList;
    [self setUpTableView];
    
    _page = 0;
    _viewModel = [[HomeViewModel alloc] init];
    _homeModelArray = [NSMutableArray array];
    [self getProfileKeyAndValues];
    [self setUpRefreshView];
    [self setUpLocationManager];
    [self addLineNavigationBottom];
    self.talKingDataPageName = @"Home";

}

- (void)getProfileKeyAndValues
{
    [_viewModel getDicMap:^(NSDictionary *object) {
        [ProfileKeyAndValue shareInstance].appDic = object;
    } failBlock:^(NSDictionary *object) {
        
    }];
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
        _latitude = location.coordinate.latitude;
        _logtitude = location.coordinate.longitude;
        [weakSelf setUpHomeData];
        if ([UserInfo isLoggedIn]) {
            [weakSelf.viewModel senderLocation:location.coordinate.latitude longitude:location.coordinate.longitude];
        }
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

- (void)loadNewData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}


- (void)setUpHomeData
{
    if (_fillterName == NomalList) {
        _page ++;
        NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
        __weak typeof(self) weakSelf = self;
        [_viewModel getHomeList:pageString latitude:_latitude longitude:_logtitude successBlock:^(NSDictionary *object) {
            weakSelf.tableView.scrollEnabled = YES;
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
    }else{
        _page ++;
        NSString *filter =  @"";
        if (_fillterName == LocationList) {
            filter = @"location";
        }else{
            filter = @"recommend";
        }
        NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
        __weak typeof(self) weakSelf = self;
        [_viewModel getHomeFilterList:pageString latitude:_latitude longitude:_logtitude filter:filter successBlock:^(NSDictionary *object) {
            [weakSelf.homeModelArray addObjectsFromArray:[HomeModel  mj_objectArrayWithKeyValuesArray:object]];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.scrollEnabled = YES;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(ScrollingNavigationController *)self.navigationController followScrollView:self.tableView delay:50.0f];
    [self navigationItemWhiteColorAndNotLine];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:HomeTableViewBackGroundColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self setUpBottonView];
    [self setUpNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    [self.bottomView removeFromSuperview];
    [(ScrollingNavigationController *)self.navigationController showNavbarWithAnimated:YES];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navigationbar_fittle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Icon_User"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPess:)];
    ScrollingNavigationController *navigation = (ScrollingNavigationController *)self.navigationController;
    navigation.scrollingNavbarDelegate = self;
}

- (void)rightItemPess:(UIBarButtonItem *)sender
{
    [self presentViewController:[[BaseNavigaitonController alloc] initWithRootViewController:[[MeViewController alloc] init]] animated:YES completion:^{

    }];
}

- (UIView *)titleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(2, -1, 78, 25)];
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

- (void)orderPress:(UIButton *)sender
{
//    UIStoryboard *orderStory = [UIStoryboard storyboardWithName:@"Order" bundle:[NSBundle mainBundle]];
//    OrderViewController *orderVC = [orderStory instantiateViewControllerWithIdentifier:@"OrderViewController"];
//    [self.navigationController pushViewController:orderVC animated:YES];
//    EditMoreProfileViewController *edilt = [[EditMoreProfileViewController alloc] init];
//    [self.navigationController pushViewController:edilt animated:YES];
//    PayViewController *controller = [[PayViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
    OrderPageViewController *orderPageVC = [[OrderPageViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:orderPageVC];
    [orderPageVC setBarStyle:TYPagerBarStyleCoverView];
//    orderPageVC.cellSpacing = 100;
    orderPageVC.progressColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
    [self.navigationController presentViewController:navVC animated:YES completion:^{
        
    }];
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
    [meetBt setImage:[UIImage imageNamed:@"meet_order"] forState:UIControlStateNormal];
    meetBt.layer.backgroundColor = [[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0] CGColor];
    [meetBt addTarget:self action:@selector(orderPress:) forControlEvents:UIControlEventTouchUpInside];
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
    _tableView.backgroundColor = [UIColor colorWithHexString:HomeTableViewBackGroundColor];
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
    HomeModel *model = [_homeModelArray objectAtIndex:indexPath.section];
    meetDetailView.user_id = [NSString stringWithFormat:@"%ld",(long)model.uid];
    [self.navigationController pushViewController:meetDetailView animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (scrollView.contentOffset.y <= 0){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:HomeTableViewBackGroundColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:HomeTableViewBackGroundColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }

    if (translation.y < -54)
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:HomeDetailViewNameColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        _statusView.backgroundColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
    }else if(translation.y > 0){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:HomeTableViewBackGroundColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        _statusView.backgroundColor = [UIColor colorWithHexString:HomeTableViewBackGroundColor];

    }

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_homeModelArray removeAllObjects];
            _fillterName = ReconmondList;
            _page = 0;
            [self setUpHomeData];
        
            break;
        case 1:
            [_homeModelArray removeAllObjects];
            _fillterName = LocationList;
            _page = 0;
            [self setUpHomeData];
        default:
            
            break;
    }
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

- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    __weak typeof(self) weakSelf = self;
    if (status == kCLAuthorizationStatusNotDetermined){
        [_viewModel senderIpAddress:^(NSDictionary *object) {
            _logtitude = [object[@"lon"] doubleValue];
            _latitude = [object[@"lat"] doubleValue];
            [weakSelf setUpHomeData];
        } fail:^(NSDictionary *object) {
            
        }];
    }else if(status == kCLAuthorizationStatusDenied){
        [_viewModel senderIpAddress:^(NSDictionary *object) {
            _logtitude = [object[@"lon"] doubleValue];
            _latitude = [object[@"lat"] doubleValue];
            [weakSelf setUpHomeData];
        } fail:^(NSDictionary *object) {
            
        }];
    }else if(status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways){
        [self setUpHomeData];
    }
}

- (void)scrollingNavigationController:(ScrollingNavigationController * _Nonnull)controller didChangeState:(enum NavigationBarState)state
{
    if (state == NavigationBarStateExpanded) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:HomeTableViewBackGroundColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }else if (state == NavigationBarStateCollapsed){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:HomeDetailViewNameColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    }
}


@end
