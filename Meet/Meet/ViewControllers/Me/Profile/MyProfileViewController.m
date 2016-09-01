//
//  MyProfileViewController.m
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyProfileViewController.h"
#import "CellTextField.h"
#import "LabelAndTextFieldCell.h"
#import "TextViewCell.h"
#import "UIImage+PureColor.h"
#import "MoreProfileViewController.h"
#import "AddInformationViewController.h"
#import "AddStarViewController.h"
#import "NetWorkObject.h"
#import "UISheetView.h"
#import "ProfileKeyAndValue.h"
#import "UserInfoViewModel.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "WXUserInfo.h"
#import "Meet-Swift.h"
#import "Masonry.h"
#import "NSString+StringType.h"
#import "AddJobLabelTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "IQKeyboardManager.h"
#import "TZImagePickerController.h"

typedef NS_ENUM(NSUInteger, SectonContentType) {
    SectionProfile,
    SectionWoerkExperience,
    SectionOccupation,///职业
    SectionEducateExp,//教育
    SectionPrivate,///个人亮点
    SectionMore,//更多
};

typedef NS_ENUM(NSUInteger, RowType) {
    RowHeadImage,
    RowName,
    RowSex,
    RowBirthday,
    RowWorkLocation,
    RowJobLabel,
    RowPhoneNumber,
    RowWX_Id,
    RoWIndustry,
    RowIncome,
    RowState,
    RowConstellation,
};

@interface MyProfileViewController () <UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISheetViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate, TZImagePickerControllerDelegate> {
    
    __weak IBOutlet UIView *_bottomPickerView;
    __weak IBOutlet UIDatePicker *_datePicker;
    __weak IBOutlet UIPickerView *_picker;

    
    NSArray *_arraySexPick;////2
    NSMutableArray *_arrayHeightPick;/////4
    NSMutableArray *_arrayWorkLocationPick;////7
    NSArray *_arrayIncomePick;/////8
    NSArray *_arrayIndustryPick;/////
    NSArray *_arrayLovedPick;/////9
    NSArray *_arrayConstellationPick;////10
    NSMutableArray *_arrayStatesPick;/////省
    NSMutableDictionary *_dicCityPick;////区市 key为省
    
    NSMutableArray *_workeExperId;
    NSMutableArray *_eduExperId;

    NSMutableDictionary *_dicValues;////////tableView内容数据缓存 Key为对应的Title Value为用户填入的结果
    NSMutableDictionary *_dicPickSelectValues;////保存pickView对应的位置 ，value为pickView所选的位置，key为对应的title字符串
    NSMutableDictionary *_dicPickLocationValue;/////工作地点 和 家乡pick 值 （key为对应的title字符串 value为pickView所选的位置数组（） ）
    NSInteger _tempComponet0Row;
    
    NSMutableArray *_arrayWorkExper;///工作经历
    NSMutableArray *_arrayOccupationLable;///职业标签
    NSMutableArray *_arrayEducateExper;///教育背景
    
    UISheetView *_sheetView;
    UIAlertView *_sexAlertView;
    BOOL _isNotSelectHeight;
    
    NSArray *_moreInfoArray;
    
    NSIndexPath *selectIndexPath;
    
    
    
    CGFloat insterHeight;
    
    BOOL _isSectionOne;
}


@property (weak, nonatomic) IBOutlet UILabel *pickerTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (strong, nonatomic) NSMutableArray *photos;

@property (nonatomic, copy) NSMutableArray *jobLabelArray;

@property (nonatomic, assign) BOOL isBlockReloadData;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNewUser"];
    self.navigationItem.title = @"个人信息";
    _isBaseView = NO;
    _titleContentArray = @[@"头像",@"真实姓名",@"性别",@"生日",@"工作城市",@"职业",@"手机号码",@"微信号"];
    _moreInfoArray = @[@"行业",@"年收入",@"情感状态",@"星座"];
    
    _dicValues = [NSMutableDictionary dictionary];

    _arrayWorkExper = [NSMutableArray arrayWithArray:[self workExpArray]];
    _arrayOccupationLable = [NSMutableArray arrayWithArray:@[@"产品总监, 产品经理 "]];
    _arrayEducateExper = [NSMutableArray arrayWithArray:[self eduWorkExpArray]];

    [self loadPickViewData];
    _chooseView.hidden = YES;
    _datePicker.backgroundColor = [UIColor whiteColor];

    _datePicker.maximumDate = [NSDate  date];
    _picker.backgroundColor = [UIColor whiteColor];
    
    _viewModel = [[UserInfoViewModel alloc] init];
    _jobLabelArray = [[NSMutableArray alloc] init];
    [self loadLastUpdate];
    [self setUpTableView];
    [self setNavigationBarItem];
    self.talKingDataPageName = @"Me-MyProfile";
}

- (void)setUpTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfilePhotoCell" bundle:nil] forCellReuseIdentifier:@"ProfilePhotoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileSectionTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileSectionTitleTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WorkeAndEduTableViewCell" bundle:nil] forCellReuseIdentifier:@"WorkeAndEduTableViewCell"];
    [self.tableView registerClass:[AddJobLabelTableViewCell class] forCellReuseIdentifier:@"addJobLabelTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfilePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfilePhotoTableViewCell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:MeViewProfileBackGroundColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
/**
 *  设置导航栏标题
 */
- (void)setNavigationBarItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:NavigationBarTintColorCustome]];
}


- (void)leftItemClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)workExpArray
{
    NSMutableArray *workArray = [NSMutableArray array];
    _workeExperId = [NSMutableArray array];
    for (Work_Expirence *work_expirence in [UserInfo sharedInstance].work_expirence) {
        NSString *workString = [NSString stringWithFormat:@"%@-%@",work_expirence.company_name,work_expirence.profession];
        [workArray addObject:workString];
        [_workeExperId addObject:[NSString stringWithFormat:@"%ld",(long)work_expirence.wid]];
    }
    return workArray;
}

- (NSArray *)eduWorkExpArray
{
       NSMutableArray *workArray = [NSMutableArray array];
    _eduExperId = [NSMutableArray array];
    for (Edu_Expirence *edu_info in [UserInfo sharedInstance].edu_expirence) {
        NSString *workString = [NSString stringWithFormat:@"%@-%@-%@",edu_info.graduated,edu_info.major, [[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"education"] objectForKey:[NSString stringWithFormat:@"%@",edu_info.education]]];
        [workArray addObject:workString];
        [_eduExperId addObject:[NSString stringWithFormat:@"%ld",(long)edu_info.eid]];
    }
    return workArray;
}

- (void)loadLastUpdate
{
    __weak typeof(self) weakSelf = self;
    [_viewModel lastModifield:^(NSString *time) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastModifield"] != nil) {
            NSString *lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastModifield"];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastModifield"] == nil) {
                [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"lastModifield"];
            }else if (![lastTime isEqualToString:time]){
                [_viewModel getUserInfo:[UserInfo sharedInstance].uid success:^(NSDictionary *object) {
                    [UserInfo synchronizeWithDic:object];
                    [weakSelf loadPickViewData];
                    [weakSelf.tableView reloadData];
                    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"lastModifield"];
                } fail:^(NSDictionary *object) {
                } loadingString:^(NSString *str) {
                    
                }];
            }
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"lastModifield"];
        }
    } failBlock:^(NSDictionary *object) {
        
    }];
}

- (void)loadPickViewData {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///pickView cache
        _dicPickSelectValues = [NSMutableDictionary dictionary];
        _dicPickLocationValue = [NSMutableDictionary dictionary];
        _arraySexPick = @[@"男",@"女"];
        _arrayHeightPick = [NSMutableArray arrayWithObject:@"150cm以下"];
        for (int i = 150; i <= 190; i++) {
            NSString *str = FORMAT(@"%dcm",i);
            [_arrayHeightPick addObject:str];
        }
        [_arrayHeightPick addObject:@"190cm以上"];
        _arrayIndustryPick = @[@"互联网/软件",@"金融",@"重工制造",@"法律/会计/咨询",@"贸易",@"房产建筑",@"学生",@"文化/传媒",@"电子/硬件",@"轻工制造",@"教育科研",@"零售",@"能源环保水利",@"酒店旅游",@"制药/生物科技",@"医疗",@"生活服务",@"交通运输",@"电信",@"政府/社会组织",@"农林牧渔"];
        _arrayIncomePick = @[@"未选择",@"10W以下",@"10W~20W",@"20W~30W",@"30W~50W",@"50W~100W",@"100W以上"];
        _arrayLovedPick = @[@"单身",@"未婚",@"已婚"];
        _arrayConstellationPick = @[@"水瓶座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座"];
       
        //location
        NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:path]) {
            [NSException raise:@"File not found" format:@"Couldn't find the file at path: %@", path];
        }
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        if (array.count >1) {
            _arrayStatesPick = [NSMutableArray arrayWithCapacity:28];
            _dicCityPick = [NSMutableDictionary dictionaryWithCapacity:28];
        }
        _stateArray = [[NSMutableDictionary alloc] init];
        [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * stop) {
            NSString *stateName = dic[@"State"];
            [_arrayStatesPick addObject:stateName];
            [_stateArray setValue:dic[@"StateId"] forKey:stateName];
            NSArray *cities = dic[@"Cities"];
            NSMutableArray *temp = [NSMutableArray array];
            [cities enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * stop) {
                NSString *cityName = obj[@"city"];
                [weakSelf.stateArray setValue:obj[@"cityId"] forKey:cityName];
                [temp addObject:cityName];
            }];
            [_dicCityPick setObject:temp forKey:stateName];
        }];
        [weakSelf mappingContentDicValue];
    });

}

- (void)locationRowMappingForRow:(NSInteger)row {
    
    NSString *locationCity ;
    if (row == RowWorkLocation) {
        locationCity = [UserInfo sharedInstance].location;
    }
    if (![locationCity isKindOfClass:[NSNull class]] && locationCity != nil && locationCity.length > 2) {
        NSArray *stateAndCity = [locationCity componentsSeparatedByString:@","];
        __block NSInteger stateRow = 0;
        __block NSInteger cityRow = 0;
        [stateAndCity enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * stop) {
            if (idx == 0) {
                [_arrayStatesPick enumerateObjectsUsingBlock:^(NSString *state, NSUInteger _idx, BOOL *stop) {
                    if ([str isEqualToString:state]) {
                        stateRow = _idx;
                        *stop = YES;
                    }
                }];
            } else if(idx == 1) {
                NSArray *cityArray = [self pickViewComponent2Content:stateRow];
                [cityArray enumerateObjectsUsingBlock:^(NSString *city, NSUInteger _idx, BOOL *stop) {
                    if ([city isEqualToString:str]) {
                        cityRow = _idx;
                        *stop = YES;
                    }
                }];
            }
            [_dicPickLocationValue setObject:@[[NSNumber numberWithInteger:stateRow] ,[NSNumber numberWithInteger:cityRow]] forKey:_titleContentArray[row]];
        }];
    }
}


- (NSDate *)getDateFromString:(NSString *)pstrDate
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *dtPostDate = [df1 dateFromString:pstrDate];
    return dtPostDate;
}

//得到星座的算法
-(NSInteger )getAstroWithDateString:(NSString *)YYYYMMDD{
    NSString *mStr = [YYYYMMDD substringWithRange:NSMakeRange(5, 2)];
    NSString *dStr = [YYYYMMDD substringWithRange:NSMakeRange(8, 2)];
    
    NSInteger m = mStr.intValue;
    NSInteger d = dStr.intValue;
    NSString *astroString = @"bb00112233445566778899aabb";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return [self stringForInteger:result];
}

- (NSInteger)stringForInteger:(NSString *)str{
    if ([str isEqualToString:@"aa"]) {
        return 10;
    } else if([str isEqualToString:@"bb"]) {
        return 11;
    } else {
        NSString *subStr = [str substringWithRange:NSMakeRange(0, 1)];
        return subStr.intValue;
    }
}

- (void)mappingContentDicValue{
    
    _dicValues[_titleContentArray[RowHeadImage]] = [UserInfo imageForName:@"headImage.jpg"];
    _dicValues[_titleContentArray[RowName]] = [UserInfo sharedInstance].real_name;
    if ([[NSString stringWithFormat:@"%ld",(long)[UserInfo sharedInstance].gender] isEqualToString:@"1"]) {
        _dicValues[_titleContentArray[RowSex]] = @"男";
    }else if ([[NSString stringWithFormat:@"%ld",(long)[UserInfo sharedInstance].gender] isEqualToString:@"2"]){
        _dicValues[_titleContentArray[RowSex]] = @"女";
    }else{
        _dicValues[_titleContentArray[RowSex]] = @"未选择";
    }
    if ([[UserInfo sharedInstance].birthday isEqualToString:@""] || [[UserInfo sharedInstance].birthday isEqualToString:@"(null)"] || [UserInfo sharedInstance].birthday == nil){
        _dicValues[_titleContentArray[RowBirthday]] = @"未选择";
    }else{
        _dicValues[_titleContentArray[RowBirthday]] = [UserInfo sharedInstance].birthday;
    }

    if ([UserInfo sharedInstance].mobile_num == nil) {
        _dicValues[_titleContentArray[RowPhoneNumber]] = @"";
    }else{
        _dicValues[_titleContentArray[RowPhoneNumber]] = [UserInfo sharedInstance].mobile_num;
    }
    
    if ([UserInfo sharedInstance].weixin_num == nil) {
        _dicValues[_titleContentArray[RowWX_Id]] = @"";
    }else{
        _dicValues[_titleContentArray[RowWX_Id]] = [UserInfo sharedInstance].weixin_num;
    }
    NSArray *locationArray = [[UserInfo sharedInstance].location componentsSeparatedByString:@","];
    if ([locationArray[0] isEqualToString:@"(null)"] || [locationArray[0] isEqualToString:@"0"] || [UserInfo sharedInstance].location == nil) {
        _dicValues[_titleContentArray[RowWorkLocation]] = @"未选择";
    }else{
        if ([[self valueKey:locationArray[0]] isEqualToString:@""] || [[self valueKey:locationArray[1]] isEqualToString:@""]) {
             _dicValues[_titleContentArray[RowWorkLocation]] = @"未选择";
        }else{
             _dicValues[_titleContentArray[RowWorkLocation]] = [NSString stringWithFormat:@"%@ %@",[self valueKey:locationArray[0]],[self valueKey:locationArray[1]]];
        }
    }
    if ([UserInfo sharedInstance].income == 0) {
        _dicValues[_moreInfoArray[RowIncome - _titleContentArray.count]] = @"未选择";
    }else{
        _dicValues[_moreInfoArray[RowIncome - _titleContentArray.count]] = [self valueKey:[UserInfo sharedInstance].income colume:@"income"];
    }
    
    if ([UserInfo sharedInstance].affection == 0) {
        _dicValues[_moreInfoArray[RowState - _titleContentArray.count]] = @"未选择";
    }else{
        _dicValues[_moreInfoArray[RowState - _titleContentArray.count]] = [self valueKey:[UserInfo sharedInstance].affection colume:@"affection"];
    }

    NSString *industry = [NSString stringWithFormat:@"%ld",(long)[UserInfo sharedInstance].industry];
    if ([industry isEqualToString:@"(null)"] || [industry isEqualToString:@"0"]) {
        _dicValues[_moreInfoArray[RoWIndustry - _titleContentArray.count]] = @"未选择";
    }else{
        _dicValues[_moreInfoArray[RoWIndustry - _titleContentArray.count]] = [self valueKey:[UserInfo sharedInstance].industry colume:@"industry"];
    }
    
    if ((long)[UserInfo sharedInstance].constellation == 0) {
        _dicValues[_moreInfoArray[RowConstellation - _titleContentArray.count]] = @"未选择";
    }else{
        _dicValues[_moreInfoArray[RowConstellation - _titleContentArray.count]] = [self valueKey:[UserInfo sharedInstance].constellation colume:@"constellation"];

    }

    _dicValues[_titleContentArray[RowJobLabel]] = [UserInfo sharedInstance].job_label;
}

- (NSString *)valueKey:(NSString *)value
{
    NSString *keyString = @"";
    for (NSString *key in [self.stateArray allKeys]) {
        if ([[self.stateArray objectForKey:key] isEqualToString:value]) {
            keyString = key;
        }
    }
    return keyString;
}

- (NSString *)valueKey:(NSInteger)value colume:(NSString *)colume
{
    NSString *keyString = @"";
    NSDictionary *dic = [[ProfileKeyAndValue shareInstance].appDic objectForKey:colume];
    for (NSString *key in dic) {
        if ([dic[key] integerValue] == value) {
            keyString = key;
        }
    }
    return keyString;
}

/**
 *  返回用户的所有信息数据
 */
- (void)mappingUserInfoWithDicValues {
    ////图像URL 服务器返回后待加入
    
    NSDictionary *locationDic = [ProfileKeyAndValue shareInstance].appDic;
    NSArray *workcity = [_dicValues[_titleContentArray[RowWorkLocation]] componentsSeparatedByString:@" "];
    NSString *location = @"";
    if ([workcity[0] isEqualToString:@"未选择"]) {
        location = [NSString stringWithFormat:@"0,0"];
    }else{
        location = [NSString stringWithFormat:@"%@,%@",[_stateArray objectForKey:workcity[0]],[_stateArray objectForKey:workcity[1]]];
    }

    NSString *hometown = @"";
    
    NSString *affection = [[locationDic objectForKey:@"affection"] objectForKey:_dicValues[_moreInfoArray[RowState - _titleContentArray.count]]];
    NSString *height  = @"";

    NSString *income = [[locationDic objectForKey:@"income"] objectForKey:_dicValues[_moreInfoArray[RowIncome - _titleContentArray.count]]];
    
    NSString *constellation = [[locationDic objectForKey:@"constellation"] objectForKey:_dicValues[_moreInfoArray[RowConstellation - _titleContentArray.count]]];
    
     NSString *industry = [[locationDic objectForKey:@"industry"] objectForKey:_dicValues[_moreInfoArray[RoWIndustry - _titleContentArray.count]]];
    
    [UserInfo sharedInstance].real_name = _dicValues[_titleContentArray[RowName]];
    [UserInfo sharedInstance].birthday = _dicValues[_titleContentArray[RowBirthday]];
    [UserInfo sharedInstance].height = [height integerValue];
    [UserInfo sharedInstance].mobile_num = _dicValues[_titleContentArray[RowPhoneNumber]];
    [UserInfo sharedInstance].weixin_num = _dicValues[_titleContentArray[RowWX_Id]];
    [UserInfo sharedInstance].location = location;
    [UserInfo sharedInstance].income = [income integerValue];
    [UserInfo sharedInstance].affection = [affection integerValue];
    [UserInfo sharedInstance].hometown = hometown;
    [UserInfo sharedInstance].constellation = [constellation integerValue];
    [UserInfo sharedInstance].industry = [industry integerValue];
    [UserInfo sharedInstance].job_label = _dicValues[_titleContentArray[RowJobLabel]];
    NSInteger sex = 1;
    if ([_dicValues[_titleContentArray[RowSex]] isEqualToString:@"男"])
    {
        sex = 1;
    }else{
        sex = 2;
    }
    [UserInfo sharedInstance].gender = sex;

}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    _bottomViewConstraint.constant = - 300;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data
- (NSArray *)setPickerViewContentArray:(NSInteger)row {

    if (!_isSectionOne) {
        if (row == RowSex) {
            return _arraySexPick;
        }else if (row == RowWorkLocation) {
            return _arrayWorkLocationPick;
        }
    }else{
        row = row + _titleContentArray.count;
        if (row == RoWIndustry) {
            return _arrayIndustryPick;
        } else if (row == RowIncome) {
            return _arrayIncomePick;
        } else if (row == RowState) {
            return _arrayLovedPick;
        } else if (row == RowConstellation) {
            return _arrayConstellationPick;
        }
    }
    return nil;
}

#pragma mark - Action
- (void)saveAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self mappingUserInfoWithDicValues];
    if ([self chectBaseInfo]) {
        [_viewModel updateUserInfo:[UserInfo sharedInstance] withStateArray:[self.stateArray copy] success:^(NSDictionary *object) {
            /**
             *  更新ME界面回调
             */
            if (self.reloadMeViewBlock) {
                self.reloadMeViewBlock(YES);
                [self.navigationController popViewControllerAnimated:YES];
            }
            UIImage *image = _dicValues[_titleContentArray[0]];
            if ([UserInfo saveCacheImage:image withName:@"headerImage.jpg"]) {
                _dicValues[_titleContentArray[0]] = image;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            if (weakSelf.fromeMeView) {
                //            weakSelf.block(YES, NO);
            }else{
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            [UserInfo synchronize];
        } fail:^(NSDictionary *object) {
            MainTheand([[UITools shareInstance] showMessageToView:self.view message:@"保存失败" autoHide:YES];)
        } loadingString:^(NSString *str) {
        }];
    }
}


- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender {

    if (_selectRow == 2) {////Sex Item
        return ;
    }
    [self mappingPickContentInDic];
    [self showChooseViewAnimation:NO];
    
}

- (IBAction)cancelAction:(id)sender {
    
    [self showChooseViewAnimation:NO];
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)tureButtonAction:(id)sender {
    
    [self mappingPickContentInDic];
    [self showChooseViewAnimation:NO];
    [self.tableView reloadRowsAtIndexPaths:@[selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if (_isBaseView) {
        if (selectIndexPath.row == RowWorkLocation) {
            LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:RowJobLabel  inSection:0]];
            [cell.textField becomeFirstResponder];
        }else if (selectIndexPath.row < _titleContentArray.count - 1) {
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndexPath.row + 1 inSection:selectIndexPath.section]];
        }

    }else{
        if (selectIndexPath.row< _moreInfoArray.count - 1) {
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndexPath.row + 1 inSection:selectIndexPath.section]];
        }
    }
}

- (void)mappingPickContentInDic {
    
    if (!_isSectionOne) {
        NSString *key = _titleContentArray[_selectRow];
        if (_datePicker.hidden) { /////
            if (_selectRow == RowWorkLocation) {
                NSInteger fristComponentRow = [_picker selectedRowInComponent:0];
                NSInteger secondComponentRow = [_picker selectedRowInComponent:1];
                NSString *fristValue = _arrayStatesPick[fristComponentRow];
                NSString *secondValue = [self pickViewComponent2Content:fristComponentRow][secondComponentRow];
                [_dicPickLocationValue setObject:@[[NSNumber numberWithInteger:fristComponentRow],[NSNumber numberWithInteger:secondComponentRow]] forKey:_titleContentArray[_selectRow]];
                NSString *locationStr = FORMAT(@"%@ %@",fristValue,secondValue);
                _dicValues[key] = locationStr;
            } else {
                if (self.pickerSelectRow < 0) {
                    
                }else{
                    
                    NSString *result = [self setPickerViewContentArray:self.selectRow][_pickerSelectRow];
                    _dicValues[key] = result;
                    [_dicPickSelectValues setObject:[NSNumber numberWithInt:_pickerSelectRow] forKey:key];
                }
                
            }
        } else {////_datePicker
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSDate *date = _datePicker.date;
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [dateFormat stringFromDate:date];
            _dicValues[key] = strDate;
            NSString *constellatinString = _arrayConstellationPick[[self getAstroWithDateString:strDate]];
            [_dicPickSelectValues setObject:[NSNumber numberWithInteger:[self getAstroWithDateString:strDate]] forKey:_moreInfoArray[RowConstellation - _titleContentArray.count]];
            [UserInfo sharedInstance].constellation = [[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"constellation"] objectForKey:constellatinString];
            _dicValues[_moreInfoArray[RowConstellation - _titleContentArray.count]] = constellatinString;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowBirthday inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
        NSString *key = _moreInfoArray[_selectRow];
        if (_datePicker.hidden) { /////
            if (self.pickerSelectRow < 0) {
                
            }else{
                
                NSString *result = [self setPickerViewContentArray:self.selectRow][_pickerSelectRow];
                _dicValues[key] = result;
                [_dicPickSelectValues setObject:[NSNumber numberWithInt:_pickerSelectRow] forKey:key];
            }
        } else {////_datePicker
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSDate *date = _datePicker.date;
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [dateFormat stringFromDate:date];
            _dicValues[key] = strDate;
            NSString *constellatinString = _arrayConstellationPick[[self getAstroWithDateString:strDate]];
            [_dicPickSelectValues setObject:[NSNumber numberWithInteger:[self getAstroWithDateString:strDate]] forKey:_moreInfoArray[RowConstellation - _titleContentArray.count]];
            _dicValues[_moreInfoArray[RowConstellation - _titleContentArray.count]] = constellatinString;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowBirthday inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
}

- (void)hiddenDatePicker:(BOOL)hidden {
    
    if (hidden) {
        _datePicker.hidden = YES;
        _picker.hidden = NO;
        [_picker reloadAllComponents];
    } else {
        _datePicker.hidden = NO;
        _picker.hidden = YES;
    }
}

- (void)showChooseViewAnimation:(BOOL)show {
    if (show) {
        _bottomViewConstraint.constant = 0;
    } else {
        _bottomViewConstraint.constant = -259;
    }
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState |   UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                             [_bottomPickerView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if (show) {
                                 _chooseView.hidden = NO;
                             } else {
                                 _chooseView.hidden = YES;
                             }
                         }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _sexAlertView) {
        if (buttonIndex == 1) {
            [self mappingPickContentInDic];
            [self showChooseViewAnimation:NO];
        } else {
            
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    return NO;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (!_isSectionOne) {
        if (_selectRow == RowWorkLocation) {
            return 2;
        } else
            return 1;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (!_isSectionOne) {
        if (_selectRow == RowWorkLocation) {
            if (component == 0) {
                return  _arrayStatesPick.count;
            } else {
                NSArray *citiesArray = [self pickViewComponent2Content:_tempComponet0Row];
                return citiesArray.count;
            }
        } else
            return [self setPickerViewContentArray:_selectRow].count;

    }else{
        return [self setPickerViewContentArray:_selectRow].count;
    }
}

- (void)setAddJobLabelData:(AddJobLabelTableViewCell *)cell withArray:(NSArray *)array
{
    [cell configCell:array];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (!_isSectionOne) {
        if (_selectRow == RowWorkLocation) {
            if (component == 0) {
                return  _arrayStatesPick[row];
            } else {
                NSArray *citiesArray = [self pickViewComponent2Content:_tempComponet0Row];
                return citiesArray[row];
            }
        } else
            return (NSString *)[self setPickerViewContentArray:_selectRow][row];
    }else{
        return (NSString *)[self setPickerViewContentArray:_selectRow][row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (!_isSectionOne) {
        if (_selectRow == RowWorkLocation) {
            if (component == 0) {
                _tempComponet0Row = row;
                [pickerView reloadComponent:1];
                return ;
            } else {
                
            }
        }  else
            self.pickerSelectRow = row;
    }else{
        self.pickerSelectRow = row;
    }
    
}

- (NSArray *)pickViewComponent2Content:(NSInteger)component0Row {
    NSString *stateName = _arrayStatesPick[component0Row];
    NSArray *citiesArray = _dicCityPick[stateName];
    return citiesArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _titleContentArray.count;
    }else if (section == 1){
        return _moreInfoArray.count + 1;
    }else if( section == 2) {
        return _arrayWorkExper.count + 1;
    }else if (section == 3) {
        return  _arrayEducateExper.count+ 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewUser"]) {
                return 260;
            }else{
                return 180;
            }
        } else
            return 50;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 65;
        }else{
            return 50;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 65;
        }else{
            return 112;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 65;
        }else{
            return 112;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewUser"]) {
            static  NSString  *CellIdentiferId = @"ProfileTableViewCell";
            ProfileTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            if (cell == nil) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:nil options:nil];
                cell = [nibs lastObject];
                
            }
            if ([UserInfo sharedInstance].avatar != nil && ![[UserInfo sharedInstance].avatar isEqualToString:@""]) {
                NSArray *photoArray = [[UserInfo sharedInstance].avatar componentsSeparatedByString:@"?"];
                NSString *photoUrl = [photoArray[0] stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/500/h/500"]];
                [cell.profilePhoto sd_setImageWithURL:[NSURL URLWithString:photoUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _dicValues[_titleContentArray[0]] = image;
                    [UserInfo saveCacheImage:image withName:@"headImage.jpg"];
                }];
            }else{
                [cell.profilePhoto setImage:[UIImage imageNamed:@"me_profile_photo"] forState:UIControlStateNormal];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static  NSString  *CellIdentiferId = @"ProfilePhotoTableViewCell";
            ProfilePhotoTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            if (cell == nil) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ProfilePhotoTableViewCell" owner:nil options:nil];
                cell = [nibs lastObject];
                
            }
            if (self.isApplyCode) {
                [cell showapplyCodeLabel];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ApplyCodeAvatar"] != nil) {
                    NSArray *photoArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ApplyCodeAvatar"] componentsSeparatedByString:@"?"];
                    NSString *photoUrl = [photoArray[0] stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/500/h/500"]];
                    [UserInfo sharedInstance].avatar = photoUrl;
                    [cell.profilePhoto sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e7e7e7"] size:CGSizeMake(89, 89)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    }];
                }else{
                    [cell.profilePhoto setImage:[UIImage imageNamed:@"me_profile_photo"]];
                }
            }else{
                [cell hidderapplyCodeLabel];
                if ([UserInfo sharedInstance].avatar != nil){
                    NSArray *photoArray = [[UserInfo sharedInstance].avatar componentsSeparatedByString:@"?"];
                    NSString *photoUrl = [photoArray[0] stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/500/h/500"]];
                    [cell.profilePhoto sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e7e7e7"] size:CGSizeMake(89, 89)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [UserInfo saveCacheImage:image withName:@"headImage.jpg"];
                    }];
                }else{
                    [cell.profilePhoto setImage:[UIImage imageNamed:@"me_profile_photo"]];
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else if(section == 0) {
        if (row == RowName || row == RowPhoneNumber || row == RowWX_Id || row == RowJobLabel) {
            NSString *cellIdentifier = @"profileTextFieldCell";
            LabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = (LabelAndTextFieldCell *)[[[NSBundle mainBundle] loadNibNamed:@"LabelAndTextFieldCell" owner:self options:nil] objectAtIndex:0];
                cell.textField.delegate = self;
            }
            cell.tag = row;
            cell.titelLabel.text = _titleContentArray[row];
            if (row == RowName) {
                cell.textField.placeholder = @"真实姓名";
            }else if (row == RowPhoneNumber){
                cell.textField.placeholder = @"接受约见后对方可见";
            }else if (row == RowWX_Id){
                cell.textField.placeholder = @"接受约见后对方可见";
                cell.lineLabel.hidden = YES;
            }else if (row == RowJobLabel){
                cell.textField.placeholder = @"公司简称及职位";
            }
            cell.textField.indexPath = indexPath;
            if (row == RowPhoneNumber || row == RowWX_Id){
                 cell.textField.text = [NSString stringWithFormat:@"%@",_dicValues[_titleContentArray[row]]];
                if (row == RowPhoneNumber && !self.isApplyCode) {
//                    cell.textField.textColor = [UIColor colorWithHexString:MeViewProfileTitleLabelColor];
                    cell.textField.enabled = NO;
                }
            }else{
                cell.textField.text = _dicValues[_titleContentArray[row]];
            }
            cell.textField.tag = indexPath.row;
            if (indexPath.row == _titleContentArray.count - 1) {
                cell.lineLabel.hidden = YES;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.textField setValue:[UIColor colorWithHexString:MeViewProfileContentLabelColorLight] forKeyPath:@"_placeholderLabel.textColor"];
            [IQKeyboardManager sharedManager].enable = YES;
            return  cell;
        } else {
            NSString *cellIdentifier = @"profileLabelCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *titlLabel = (UILabel *)[cell viewWithTag:1];
            titlLabel.font = MeViewProfileLabelFont;
            titlLabel.textColor = [UIColor colorWithHexString:MeViewProfileTitleLabelColor];
            titlLabel.text = _titleContentArray[row];
            [titlLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
            }];
            
            UILabel *contentLabel = (UILabel *)[cell viewWithTag:2];
            contentLabel.text = _dicValues[_titleContentArray[row]];
            contentLabel.font = MeViewProfileLabelFont;
            
            if ([contentLabel.text isEqualToString:@"未选择"]) {
                contentLabel.textColor = [UIColor colorWithHexString:MeViewProfileContentLabelColorLight];
            }else{
                contentLabel.textColor = [UIColor colorWithHexString:MeViewProfileContentLabelColor];
            }
            if (row != _titleContentArray.count - 1) {
                UILabel *lineLabel = [[UILabel alloc] init];
                lineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
                [cell.contentView addSubview:lineLabel];
                [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).offset(20);
                    make.right.equalTo(cell.contentView.mas_right).offset(10);
                    make.bottom.equalTo(cell.contentView.mas_bottom).offset(0);
                    make.height.offset(0.5);
                }];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }
    } else if (row == 0){
        static  NSString  *CellIdentiferId = @"ProfileSectionTitleTableViewCell";
        ProfileSectionTitleTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ProfileSectionTitleTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            
        }
        [cell setData:_viewModel.sectionTitle[indexPath.section -1] buttonTitle:_viewModel.sectionButtonTitle[indexPath.section - 1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }else if (section == 1){
        NSString *cellIdentifier = @"profileLabelCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UILabel *titlLabel = (UILabel *)[cell viewWithTag:1];
        titlLabel.font = MeViewProfileLabelFont;
        titlLabel.textColor = [UIColor colorWithHexString:MeViewProfileTitleLabelColor];
        titlLabel.text = _moreInfoArray[row - 1];
        [titlLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
        }];
        UILabel *contentLabel = (UILabel *)[cell viewWithTag:2];
        contentLabel.text = _dicValues[_moreInfoArray[row -1]];
        contentLabel.font = MeViewProfileLabelFont;
        if ([contentLabel.text isEqualToString:@"未选择"]) {
            contentLabel.textColor = [UIColor colorWithHexString:MeViewProfileContentLabelColorLight];
        }else{
            contentLabel.textColor = [UIColor colorWithHexString:MeViewProfileContentLabelColor];
        }
        if (row != _moreInfoArray.count) {
            UILabel *lineLabel = [[UILabel alloc] init];
            lineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
            [cell.contentView addSubview:lineLabel];
            [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(20);
                make.right.equalTo(cell.contentView.mas_right).offset(10);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(0);
                make.height.offset(0.5);
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }else if (section == 2) {
        if (indexPath.row == _arrayWorkExper.count + 1) {
            static  NSString  *CellIdentiferId = @"addJobLabelTableViewCell";
            AddJobLabelTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            if (cell == nil) {
                cell = [[AddJobLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferId];
            }
            [self setAddJobLabelData:cell withArray:_jobLabelArray];
            
            __weak typeof(self) weakSelf = self;
            cell.block = ^(NSArray *array){
                [_jobLabelArray removeAllObjects];
                [_jobLabelArray addObjectsFromArray:array];
                weakSelf.isBlockReloadData = YES;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [weakSelf.view endEditing:NO];
            };
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }else{
            static  NSString  *CellIdentiferId = @"WorkeAndEduTableViewCell";
            WorkeAndEduTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            if (cell == nil) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"WorkeAndEduTableViewCell" owner:nil options:nil];
                cell = [nibs lastObject];
                
            }
            if (_arrayWorkExper.count > 0) {
                [cell setWorkerData:_arrayWorkExper[indexPath.row - 1]];
            }
            if (_arrayWorkExper.count == indexPath.row) {
                cell.lineLabel.hidden = YES;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }
    }else {
        static  NSString  *CellIdentiferId = @"WorkeAndEduTableViewCell";
        WorkeAndEduTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"WorkeAndEduTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            
        }
        if (_arrayEducateExper.count > 0) {
            [cell setEduData:_arrayEducateExper[indexPath.row - 1]];
        }
        if (_arrayEducateExper.count == indexPath.row) {
            cell.lineLabel.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
}

- (void)editDone:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
}


#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 || indexPath.section == 1) {
        if ((indexPath.section == 0 && indexPath.row != RowPhoneNumber)|| indexPath.section == 1) {
            CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
            float height = [[UIScreen mainScreen] bounds].size.height - rectInTableView.origin.y;
            if (iPhone6Plus){
                if (height > 330) {
                }else{
                    if (_isBaseView || _isApplyCode) {
                        insterHeight = 309 - height;
                    }else{
                        insterHeight = 309 - height;
                    }
                    [tableView setContentOffset:CGPointMake(0, insterHeight) animated:YES];
                }
            }else{
                if (height > 337) {
                }else{
                    
                    if (_isBaseView || _isApplyCode) {
                        if (IS_IPHONE_5){
                            insterHeight = 309 - height;
                        }else{
                            insterHeight = 309 - height;
                        }
                    }else{
                        if (IS_IPHONE_5){
                            insterHeight = 369 - height;
                        }else{
                            insterHeight = 369 - height;
                        }
                    }
                    [tableView setContentOffset:CGPointMake(0, insterHeight) animated:YES];
                    
                }
            }
        }
    }
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    selectIndexPath = indexPath;
    
    if (section == 0) {
         _selectRow = row;
        _isSectionOne= NO;
        if (_pickerTitle == nil) {
            _pickerTitle = (UILabel *)[_bottomPickerView.subviews objectAtIndex:4];
        }
        _pickerTitle.text = _titleContentArray[row];
        if (_selectRow == RowPhoneNumber || _selectRow == RowWX_Id || _selectRow == RowJobLabel || _selectRow == RowName) {
            [self hiddenDatePicker:YES];
            [self showChooseViewAnimation:NO];
        }else if (row == 0) {
            if ( !_sheetView) {
                _sheetView = [[UISheetView alloc] initWithContenArray:@[@"拍照",@"相册选择",@"取消"]];
                _sheetView.delegate = self;
            }
            [_sheetView show];
            [self.view endEditing:YES];
        } else if (row == RowBirthday) {//date picker
            [self.view endEditing:YES];
            NSString *brithDay =  _dicValues[_titleContentArray[RowBirthday]];
            if (brithDay.length > 8) {
                NSDate *date = [self getDateFromString:brithDay];
                [_datePicker setDate:date animated:NO];
            }
            [self hiddenDatePicker:NO];
            [self showChooseViewAnimation:YES];
        } else if (row == RowSex || row == RowWorkLocation) {////_pickView
            [self.view endEditing:YES];
            [self hiddenDatePicker:YES];
            [self showChooseViewAnimation:YES];
            if (row == RowWorkLocation) {
                NSArray *valueArry = _dicPickLocationValue[_titleContentArray[_selectRow]];
                _tempComponet0Row = [valueArry.firstObject intValue];
                [_picker selectRow:[valueArry.firstObject intValue] inComponent:0 animated:NO];
                [_picker selectRow:[valueArry.lastObject intValue] inComponent:1 animated:NO];
             
            }
        }
    }else if (section == 1){
        _selectRow = row - 1;
        _isSectionOne= YES;
        _pickerTitle.text = _moreInfoArray[row - 1];
        if (row != 0) {
            [self.view endEditing:YES];
            [self hiddenDatePicker:YES];
            [self showChooseViewAnimation:YES];
            if (row == RowIncome - _titleContentArray.count + 1){
                NSInteger value = [_dicPickSelectValues[_moreInfoArray[_selectRow]] intValue];
                _pickerSelectRow = value;
                if (value == 0) {
                    _pickerSelectRow = 2;
                }
                [_picker selectRow:_pickerSelectRow inComponent:0 animated:NO];
            }else if (row == RowState - _titleContentArray.count + 1){
                NSInteger value = [_dicPickSelectValues[_moreInfoArray[_selectRow]] intValue];
                _pickerSelectRow = value;
                if (value == 0) {
                    _pickerSelectRow = 1;
                }
                [_picker selectRow:_pickerSelectRow inComponent:0 animated:NO];
            }else  if (row == RoWIndustry - _titleContentArray.count + 1){
                NSInteger value = [_dicPickSelectValues[_moreInfoArray[_selectRow]] intValue];
                _pickerSelectRow = value;
                if (value == 0) {
                    _pickerSelectRow = 1;
                }
                [_picker selectRow:_pickerSelectRow inComponent:0 animated:NO];
            }else{
                NSInteger value = [_dicPickSelectValues[_moreInfoArray[_selectRow]] intValue];
                _pickerSelectRow = value;
                
                [_picker selectRow:_pickerSelectRow inComponent:0 animated:NO];
            }
        }
    }else if(section == 2 && indexPath.row != _arrayWorkExper.count + 1) {
        if (self.isApplyCode) {
            [self performSegueWithIdentifier:@"AddInformationVC" sender:indexPath];
        }else{
            [self performSegueWithIdentifier:@"pushToAddInformationVC" sender:indexPath];

        }
    }else if(section == 3){
        if (self.isApplyCode) {
            [self performSegueWithIdentifier:@"AddInformationVC" sender:indexPath];
        }else{
            [self performSegueWithIdentifier:@"pushToAddInformationVC" sender:indexPath];
            
        }
    }
}

///身高第一次显示时出现中间位置
- (void)setPickView:(NSInteger)pickType inRowAtValue:(NSInteger)value inTableViewRow:(NSInteger)tableRow {
    if (tableRow == pickType && value == 0 && !_isNotSelectHeight) {//
        value = 26;
        _pickerSelectRow = 26;
        [_dicPickSelectValues setObject:[NSNumber numberWithInt:value] forKey:_titleContentArray[_selectRow]];
        _isNotSelectHeight = YES;
    }
}

#pragma mark - UISheetViewDelegate
- (void)sheetView:(UISheetView *)sheet didSelectRowAtIndex:(NSInteger)index {
    switch (index) {
        case 0: //照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            imagePicker.mediaTypes = mediaTypes;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
        case 1: //相簿
        {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//            imagePickerVC.navigationBar.barTintColor = [UIColor whiteColor];
//            imagePickerVC.navigationBar.tintColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
//            imagePickerVC.allowPickingVideo = NO;
//            imagePickerVC.allowTakePicture = NO;
//            imagePickerVC.barItemTextFont = NavigationBarRightItemFont;
//            imagePickerVC.oKButtonTitleColorNormal = [UIColor colorWithHexString:HomeDetailViewNameColor];
//            imagePickerVC.oKButtonTitleColorDisabled = [UIColor colorWithHexString:lineLabelBackgroundColor];
//            imagePickerVC.allowPickingOriginalPhoto = YES;
//            imagePickerVC.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
//                
//            };
//            [self presentViewController:imagePickerVC animated:YES completion:^{
//                
//            }];
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            imagePicker.mediaTypes = mediaTypes;
            imagePicker.allowsEditing = YES;
            imagePicker.navigationBar.tintColor = [UIColor blackColor];
            imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
            [imagePicker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
    [_sheetView hidden];
}

#pragma mark - TZImagePickerControllerDelegate
// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的handle
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    
}

- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset
{
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.complyApplyCodeSuccess = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewUser"]) {
        ProfileTableViewCell  *cell = (ProfileTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            
        }
        cell.profilePhoto.imageView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"e7e7e7"] size:CGSizeMake(89, 89)];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///头像上传后再保存到本地 刷新
        [_viewModel uploadImage:[info valueForKey:UIImagePickerControllerEditedImage]  isApplyCode:self.isApplyCode success:^(NSDictionary *object) {
            if ([[object objectForKey:@"success"] boolValue]) {
                if (self.isApplyCode) {
                    NSString *avatar = [[object objectForKey:@"avatar"] stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/750/h/544"]];
                    [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:@"ApplyCodeAvatar"];
                    [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:@"TempAvatar"];
                }else{
                    NSString *avatar = [[object objectForKey:@"avatar"] stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/750/h/544"]];
                    [UserInfo sharedInstance].avatar = avatar;
                }
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [UserInfo synchronize];
            }else{
                [[UITools shareInstance] showMessageToView:self.view message:@"上传失败" autoHide:YES];
            }
        } fail:^(NSDictionary *object) {
            [[UITools shareInstance] showMessageToView:self.view message:@"上传失败" autoHide:YES];
        } loadingString:^(NSString *str) {
            
        }];
    });
    
    [self.navigationController dismissViewControllerAnimated: YES completion:^{
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField setReturnKeyType:UIReturnKeyDone];
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        NSIndexPath *indexPath = cellTextField.indexPath;
        if ((indexPath.section == 0) && (indexPath.row == 6)) {
            [textField setKeyboardType:UIKeyboardTypePhonePad];
            return  YES;
        } else {
            [textField setKeyboardType:UIKeyboardTypeDefault];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_isBaseView) {
        if (textField.tag == RowJobLabel) {
            if ([NSString isHaveSpecialCharacters:textField.text]){
                [EMAlertView showAlertWithTitle:nil message:@"多个职业身份请用空格分隔" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                    
                } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
            }else{
                [self.view endEditing:YES];
//                LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:RowPhoneNumber  inSection:0]];
//                [cell.textField becomeFirstResponder];
            }
        }else if (textField.tag == RowPhoneNumber) {
            if (![NSString isPureInt:textField.text]) {
                [EMAlertView showAlertWithTitle:nil message:@"请输入正确的手机号" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                    
                } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
            }else{
                LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:RowWX_Id  inSection:0]];
                [cell.textField becomeFirstResponder];
            }
        }else if (textField.tag == 1){
            [self.view endEditing:YES];
        }else if (textField.tag == RowWX_Id){
            if (![NSString isWeixinNum:textField.text] && ![textField.text isEqualToString:@""]) {
                [EMAlertView showAlertWithTitle:nil message:@"请输入正确的微信号" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                    
                } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
            }else{
                [self.view endEditing:YES];
            }
        }else{
            [self.view endEditing:YES];
        }
    }
    else{
        if (textField.tag == RowJobLabel) {
            if ([NSString isHaveSpecialCharacters:textField.text]){
                [EMAlertView showAlertWithTitle:nil message:@"多个职业身份请用空格分隔" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                    
                } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
            }else{
                [self.view endEditing:YES];
            }
        }else if (textField.tag == RowPhoneNumber) {
            if (![NSString isPureInt:textField.text]) {
                [EMAlertView showAlertWithTitle:nil message:@"请输入正确的手机号" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                    
                } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
            }else{
                LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7  inSection:0]];
                [cell.textField becomeFirstResponder];
            }
        }else if (textField.tag == 1){
            [self.view endEditing:YES];
        }else if (textField.tag == RowWX_Id){
            if (![NSString isWeixinNum:textField.text] && ![textField.text isEqualToString:@""]) {
                [EMAlertView showAlertWithTitle:nil message:@"请输入正确的微信号" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                    
                } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
            }else{
                [self.view endEditing:YES];
            }
        }else{
            [self.view endEditing:YES];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        [self mappingTextFieldDictionary:cellTextField];
    }
    if (textField.tag == 10000) {
        [UserInfo sharedInstance].job_label = textField.text;
    }
    return YES;
}

- (void)mappingTextFieldDictionary:(CellTextField *)textfield {
//    if (textfield.text == nil || [textfield.text isEqualToString:@""]) {
//        return ;
//    }
    NSIndexPath *indexPath = textfield.indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *dictionKey = @"key";
    if (section == 0) {
        dictionKey = _titleContentArray[row];
    }
    _dicValues[dictionKey] = textfield.text;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView isKindOfClass:[CellTextView class]]) {
        CellTextView *cellTextView = (CellTextView *)textView;
        NSIndexPath *indexPath = cellTextView.indexPath;
        if (indexPath.section == 5 || indexPath.section == 6) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToAddInformationVC"]) {
        AddInformationViewController *addInfom = (AddInformationViewController *)[segue destinationViewController];
        __weak typeof(self) weakSelf = self;
        addInfom.block = ^(NSIndexPath *path, NSString *string, ViewEditType type){
            if (type == ViewTypeAdd) {
                if (path.section == 2){
                    [weakSelf.viewModel addWorkExperent:string success:^(NSDictionary *object) {
                        [_arrayWorkExper addObject:string];
                        [_workeExperId addObject:object[@"wid"]];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                }else{
                    [weakSelf.viewModel addEduExperent:string success:^(NSDictionary *object) {
                        [_arrayEducateExper addObject:string];
                        [_eduExperId addObject:object[@"eid"]];
                        [self updateEduUserFile:[_arrayEducateExper copy] withEduId:[_eduExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                }
            }else if (type == ViewTypeEdit){
                if (path.section == 2){
                    [weakSelf.viewModel updateWorkExperent:string withWorkId:_workeExperId[path.row - 1] success:^(NSDictionary *object) {
                        [_arrayWorkExper replaceObjectAtIndex:path.row - 1 withObject:string];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                }else{
                    [weakSelf.viewModel updateEduExp:string witheduId:_eduExperId[path.row - 1] success:^(NSDictionary *object) {
                        [_arrayEducateExper replaceObjectAtIndex:path.row - 1 withObject:string];
                        [self updateEduUserFile:[_arrayEducateExper copy] withEduId:[_eduExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                }
            }else{
                if (path.section == 2){
                    [weakSelf.viewModel deleteWorkExperent:_workeExperId[path.row - 1] success:^(NSDictionary *object) {
                        [_arrayWorkExper removeObjectAtIndex:path.row - 1];
                        [_workeExperId removeObjectAtIndex:path.row - 1];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                }else{
                    [weakSelf.viewModel deleteEduExperent:_eduExperId[path.row - 1] success:^(NSDictionary *object) {
                        [_arrayEducateExper removeObjectAtIndex:path.row - 1];
                        [_eduExperId removeObjectAtIndex:path.row - 1];
                        [self updateEduUserFile:[_arrayEducateExper copy] withEduId:[_eduExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                    
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
                if (addInfom.indexPath.row == _arrayWorkExper.count + 1 && addInfom.indexPath.section == 2) {
                    
                }else{
                    addInfom.viewType = ViewTypeEdit;
                    if (addInfom.indexPath.section == 2) {
                        addInfom.cachTitles = [_arrayWorkExper objectAtIndex:addInfom.indexPath.row - 1];
                    }else{
                        addInfom.cachTitles = [_arrayEducateExper objectAtIndex:addInfom.indexPath.row -1 ];
                        
                    }
                }
                
            }
        }
    }else if ([segue.identifier isEqualToString:@"ApplyCodePushToAddInformationVC"]) {
        AddInformationViewController *addInfom = (AddInformationViewController *)[segue destinationViewController];
            addInfom.block = ^(NSIndexPath *path, NSString *string, ViewEditType type){
                if (type == ViewTypeAdd) {
                    if (path.section == 2){
                        [_arrayWorkExper addObject:string];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }else{
                        [_arrayEducateExper addObject:string];
                        //                        [_eduExperId addObject:object[@"eid"]];
                        [self updateEduUserFile:[_arrayEducateExper copy] withEduId:[_eduExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }else if (type == ViewTypeEdit){
                    if (path.section == 2){
                        [_arrayWorkExper replaceObjectAtIndex:path.row - 1 withObject:string];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    }else{
                        [_arrayEducateExper replaceObjectAtIndex:path.row - 1 withObject:string];
                        [self updateEduUserFile:[_arrayEducateExper copy] withEduId:[_eduExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }else{
                    if (path.section == 2){
                        [_arrayWorkExper removeObjectAtIndex:path.row - 1];
                        [_workeExperId removeObjectAtIndex:path.row - 1];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    }else{
                        [_arrayEducateExper removeObjectAtIndex:path.row - 1];
                        [_eduExperId removeObjectAtIndex:path.row - 1];
                        [self updateEduUserFile:[_arrayEducateExper copy] withEduId:[_eduExperId copy]];
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
                if (addInfom.indexPath.row == _arrayWorkExper.count + 1 && addInfom.indexPath.section == 2) {
                    
                }else{
                    addInfom.viewType = ViewTypeEdit;
                    if (addInfom.indexPath.section == 2) {
                        addInfom.cachTitles = [_arrayWorkExper objectAtIndex:addInfom.indexPath.row - 1];
                    }else{
                        addInfom.cachTitles = [_arrayEducateExper objectAtIndex:addInfom.indexPath.row -1 ];
                        
                    }
                }
                
            }
        }
    }
}

- (void)updateWorkUserFile:(NSArray *)workArray withId:(NSArray *)workId
{
    NSMutableArray *changeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < workArray.count; i ++) {
        NSArray *array = [[workArray objectAtIndex:i] componentsSeparatedByString:@"-"];
        NSString *workIdString = [workId objectAtIndex:i];
        Work_Expirence *exp = [[Work_Expirence alloc] init];
        exp.company_name = array[0];
        exp.profession = array[1];
        exp.wid = workIdString;
        [changeArray addObject:exp];
    }
    [UserInfo sharedInstance].work_expirence = [changeArray mutableCopy];
//    [UserInfo synchronize];
    
}

- (void)updateEduUserFile:(NSArray *)eduArray withEduId:(NSArray *)eduId
{
    NSMutableArray *changeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < eduArray.count; i ++) {
        NSArray *array = [[eduArray objectAtIndex:i] componentsSeparatedByString:@"-"];
        NSString *eduIdString = [eduId objectAtIndex:i];
        Edu_Expirence *edu = [[Edu_Expirence alloc] init];
        edu.graduated = array[0];
        edu.major = array[1];
        edu.education = [[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"education"] objectForKey:array[2]];
        edu.eid = eduIdString;
        [changeArray addObject:edu];
    }
    [UserInfo sharedInstance].edu_expirence = [changeArray mutableCopy];
    [UserInfo synchronize];
    
}
/**
 *  监测微信号啥的
 *
 *  @return
 */
- (BOOL)chectBaseInfo
{
    BOOL ret = NO;
    NSLog(@"%@",[UserInfo sharedInstance].real_name);
    if ([[UserInfo sharedInstance].avatar isEqualToString:@""] || [UserInfo sharedInstance].avatar == nil) {
        [EMAlertView showAlertWithTitle:nil message:@"头像为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if([[UserInfo sharedInstance].real_name isEqualToString:@""]){
        [EMAlertView showAlertWithTitle:nil message:@"真实姓名为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if([[UserInfo sharedInstance].birthday isEqualToString:@""] || [[UserInfo sharedInstance].birthday isEqualToString:@"未选择"]){
        [EMAlertView showAlertWithTitle:nil message:@"生日为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if([[UserInfo sharedInstance].location isEqualToString:@"0,0"] || [[UserInfo sharedInstance].location isEqualToString:@""]){
        [EMAlertView showAlertWithTitle:nil message:@"工作生活城市为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].mobile_num] isEqualToString:@""]){
        [EMAlertView showAlertWithTitle:nil message:@"手机号为必填内容哦" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else if(![NSString isPureInt:[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].mobile_num]]){
        [EMAlertView showAlertWithTitle:nil message:@"请输入正确的手机号" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:EMAlertViewConfirmTitle otherButtonTitles:nil];
    }else{
        ret = YES;
    }
    return ret;
}

@end
