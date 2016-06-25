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
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

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
    RowHeight,
    RowWorkLocation,
    RowPhoneNumber,
    RowWX_Id,
    RoWIndustry,
    RowIncome,
    RowState,
    RowHome,
    RowConstellation,
};

@interface MyProfileViewController () <UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISheetViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate> {
    
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
}


@property (weak, nonatomic) IBOutlet UILabel *pickerTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (strong, nonatomic) NSMutableArray *photos;


@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    _titleContentArray = @[@"头像",@"真实姓名",@"性别",@"生日",@"身高",@"工作生活城市",@"手机号码",@"微信号",@"行业",@"年收入",@"情感状态",@"家乡",@"星座"];
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
    [self loadLastUpdate];
    [self setUpTableView];
    [self setNavigationBarItem];
}

- (void)setUpTableView
{
    [self.tableView registerNib:ProfileTableViewCell.self forCellReuseIdentifier:@"ProfilePhotoCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self setNavigationBarItem];
}
/**
 *  设置导航栏标题
 */
- (void)setNavigationBarItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
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
                [_viewModel getUserInfo:[WXUserInfo shareInstance].openid success:^(NSDictionary *object) {
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
        _arrayIndustryPick = @[@"互联网/软件",@"金融",@"重工制造",@"法律/会计/咨询",@"贸易",@"学生",@"电子/硬件",@"轻工制造",@"教育科研",@"零售",@"能源环保水利",@"酒店旅游",@"制药/生物科技",@"医疗",@"生活服务",@"交通运输",@"电信",@"政府/社会组织"];
        _arrayIncomePick = @[@"10W以下",@"10W~20W",@"20W~30W",@"30W~50W",@"50W~100W",@"100W以上"];
        _arrayLovedPick = @[@"单身并享受单身的状态",@"单身但渴望找到另一半",@"已有男女朋友，但未婚",@"已婚",@"离异，寻觅中",@"丧偶，寻觅中"];
        _arrayConstellationPick = @[@"水平座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座"];
       
        ////location
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
    } else if (row == RowHome) {
        locationCity = [UserInfo sharedInstance].hometown;
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
    }else{
        _dicValues[_titleContentArray[RowSex]] = @"女";
    }
    _dicValues[_titleContentArray[RowBirthday]] = [UserInfo sharedInstance].birthday;
    _dicValues[_titleContentArray[RowHeight]] = [NSString stringWithFormat:@"%ldcm",(long)[UserInfo sharedInstance].height];
    _dicValues[_titleContentArray[RowPhoneNumber]] = [UserInfo sharedInstance].mobile_num;
    _dicValues[_titleContentArray[RowWX_Id]] = [UserInfo sharedInstance].weixin_num;
    NSArray *locationArray = [[UserInfo sharedInstance].location componentsSeparatedByString:@","];
    if ([locationArray[0] isEqualToString:@"(null)"] || [locationArray[0] isEqualToString:@"0"]) {
        _dicValues[_titleContentArray[RowWorkLocation]] = @"未选择";
    }else{
        if ([[self valueKey:locationArray[0]] isEqualToString:@""] || [[self valueKey:locationArray[1]] isEqualToString:@""]) {
             _dicValues[_titleContentArray[RowWorkLocation]] = @"未选择";
        }else{
             _dicValues[_titleContentArray[RowWorkLocation]] = [NSString stringWithFormat:@"%@,%@",[self valueKey:locationArray[0]],[self valueKey:locationArray[1]]];
        }
    }
    _dicValues[_titleContentArray[RowIncome]] = [self valueKey:[UserInfo sharedInstance].income colume:@"income"];
    _dicValues[_titleContentArray[RowState]] = [self valueKey:[UserInfo sharedInstance].affection colume:@"affection"];
    NSArray *homeArray = [[UserInfo sharedInstance].hometown componentsSeparatedByString:@","];
    if ([homeArray[0] isEqualToString:@"(null)"] || [homeArray[0] isEqualToString:@"0"]) {
        _dicValues[_titleContentArray[RowHome]] = @"未选择";
    }else{
        _dicValues[_titleContentArray[RowHome]] = [NSString stringWithFormat:@"%@,%@",[self valueKey:homeArray[0]],[self valueKey:homeArray[1]]];
    }
    
    NSString *industry = [NSString stringWithFormat:@"%ld",(long)[UserInfo sharedInstance].industry];
    if ([industry isEqualToString:@"(null)"] || [industry isEqualToString:@"0"]) {
        _dicValues[_titleContentArray[RoWIndustry]] = @"未选择";
    }else{
        _dicValues[_titleContentArray[RoWIndustry]] = [self valueKey:[UserInfo sharedInstance].industry colume:@"industry"];
    }
    
    _dicValues[_titleContentArray[RowConstellation]] = [self valueKey:[UserInfo sharedInstance].constellation colume:@"constellation"];
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
    NSArray *workcity = [_dicValues[_titleContentArray[RowWorkLocation]] componentsSeparatedByString:@","];
    NSString *location = @"";
    if ([workcity[0] isEqualToString:@"未选择"]) {
        location = [NSString stringWithFormat:@"0,0"];
    }else{
        location = [NSString stringWithFormat:@"%@,%@",[self.stateArray objectForKey:workcity[0]],[self.stateArray objectForKey:workcity[1]]];
    }
    NSArray *home = [_dicValues[_titleContentArray[RowHome]] componentsSeparatedByString:@","];
    NSString *hometown = @"";
    if ([home[0] isEqualToString:@"未选择"]) {
        hometown = [NSString stringWithFormat:@"0,0"];
    }else{
        hometown = [NSString stringWithFormat:@"%@,%@",[self.stateArray objectForKey:home[0]],[self.stateArray objectForKey:home[1]]];
    }
    
    NSString *affection = [[locationDic objectForKey:@"affection"] objectForKey:_dicValues[_titleContentArray[RowState]]];
    NSString *rowHeight = _dicValues[_titleContentArray[RowHeight]];
    NSString *height = [rowHeight substringToIndex:rowHeight.length - 2];
    NSString *income = [[locationDic objectForKey:@"income"] objectForKey:_dicValues[_titleContentArray[RowIncome]]];
    NSString *constellation = [[locationDic objectForKey:@"constellation"] objectForKey:_dicValues[_titleContentArray[RowConstellation]]];
    
     NSString *industry = [[locationDic objectForKey:@"industry"] objectForKey:_dicValues[_titleContentArray[RoWIndustry]]];
    
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
    NSLog(@"%@",_dicValues[_titleContentArray[RowSex]]);
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
    if (row == RowSex) {
        return _arraySexPick;
    } else if (row == RowHeight) {
        return _arrayHeightPick;
    } else if (row == RowWorkLocation || row == RowHome) {
        return _arrayWorkLocationPick;
    }else if (row == RoWIndustry) {
        return _arrayIndustryPick;
    } else if (row == RowIncome) {
        return _arrayIncomePick;
    } else if (row == RowState) {
        return _arrayLovedPick;
    } else if (row == RowConstellation) {
        return _arrayConstellationPick;
    }
    return nil;
}

#pragma mark - Action
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction:(id)sender {
    if (_selectRow == 2 && !_chooseView.hidden) {////Sex Item alert
        return ;
    }
    __weak typeof(self) weakSelf = self;
    [self mappingUserInfoWithDicValues];
    [_viewModel updateUserInfo:[UserInfo sharedInstance] withStateArray:[self.stateArray copy] success:^(NSDictionary *object) {
        [[UITools shareInstance] showMessageToView:self.view message:@"保存成功" autoHide:YES];
        /**
         *  更新ME界面回调
         */
        if (self.reloadMeViewBlock) {
            self.reloadMeViewBlock(YES);
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
        [[UITools shareInstance] showMessageToView:self.view message:@"保存失败" autoHide:YES];
    } loadingString:^(NSString *str) {
    }];
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
}

- (IBAction)tureButtonAction:(id)sender {
    [self mappingPickContentInDic];
    [self showChooseViewAnimation:NO];
}

- (void)mappingPickContentInDic {
    NSString *key = _titleContentArray[_selectRow];
    if (_datePicker.hidden) { /////
        if (_selectRow == RowWorkLocation || _selectRow == RowHome) {
            NSInteger fristComponentRow = [_picker selectedRowInComponent:0];
            NSInteger secondComponentRow = [_picker selectedRowInComponent:1];
            NSString *fristValue = _arrayStatesPick[fristComponentRow];
            NSString *secondValue = [self pickViewComponent2Content:fristComponentRow][secondComponentRow];
            [_dicPickLocationValue setObject:@[[NSNumber numberWithInteger:fristComponentRow],[NSNumber numberWithInteger:secondComponentRow]] forKey:_titleContentArray[_selectRow]];
            NSString *locationStr = FORMAT(@"%@,%@",fristValue,secondValue);
            _dicValues[key] = locationStr;
        } else {
            if (self.pickerSelectRow < 0) {
                
            }else{
                NSString *result = [self setPickerViewContentArray:self.selectRow][self.pickerSelectRow];
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
        [_dicPickSelectValues setObject:[NSNumber numberWithInteger:[self getAstroWithDateString:strDate]] forKey:_titleContentArray[RowConstellation]];
        _dicValues[_titleContentArray[RowConstellation]] = constellatinString;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowBirthday inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
        _bottomViewConstraint.constant = -250;
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
                                 [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_selectRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                             }
                         }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _sexAlertView) {
        if (buttonIndex == 1) {
//            [UserInfo shareInstance].modifySex = 1;
//            NSNumber *value = _dicPickSelectValues[_titleContentArray[RowSex]];
//            [UserInfo shareInstance].sex = [NSNumber numberWithInt:value.intValue + 1];
//            [[UserInfoDao shareInstance] updateBean:[UserInfo shareInstance]];
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
    if (_selectRow == RowWorkLocation || _selectRow == RowHome) {
        return 2;
    } else
        return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_selectRow == RowWorkLocation || _selectRow == RowHome) {
        if (component == 0) {
            return  _arrayStatesPick.count;
        } else {
            NSArray *citiesArray = [self pickViewComponent2Content:_tempComponet0Row];
            return citiesArray.count;
        }
    } else
        return [self setPickerViewContentArray:_selectRow].count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_selectRow == RowWorkLocation || _selectRow == RowHome) {
        if (component == 0) {
            return  _arrayStatesPick[row];
        } else {
            NSArray *citiesArray = [self pickViewComponent2Content:_tempComponet0Row];
            return citiesArray[row];
        }
    } else
        return (NSString *)[self setPickerViewContentArray:_selectRow][row];
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_selectRow == RowWorkLocation || _selectRow == RowHome) {
        if (component == 0) {
            _tempComponet0Row = row;
            [pickerView reloadComponent:1];
            return ;
        } else {
            
        }
    }  else
        self.pickerSelectRow = row;
}

- (NSArray *)pickViewComponent2Content:(NSInteger)component0Row {
    NSString *stateName = _arrayStatesPick[component0Row];
    NSArray *citiesArray = _dicCityPick[stateName];
    return citiesArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return  @"工作经历";
    } if (section == 2) {
        return  @"职业标签";
    } if (section == 3) {
        return  @"教育背景";
    } if (section == 4) {
        return  @"您的个人亮点";
    } if (section == 5) {
        return  @"更多个人介绍";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _titleContentArray.count;
    } else if( section == 1) {
        return _arrayWorkExper.count + 1;
    } else if (section == 2) {
        return  _arrayOccupationLable.count;
    } else if (section == 3) {
        return  _arrayEducateExper.count+ 1;
    }else if (section == 4 || section == 5) {
        return  1;
    }
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewUser"]) {
                return 260;
            }else{
                return 82;
            }
        } else
            return 49;
    } else if (indexPath.section == 4 || indexPath.section == 5) {
        return 90;
    }
        return 49;
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
            if ([UserInfo imageForName:@"headImage.jpg"] != nil) {
                [cell.profilePhoto setImage:[UserInfo imageForName:@"headImage.jpg"] forState:UIControlStateNormal];
            }else if ([UserInfo sharedInstance].avatar != nil && ![[UserInfo sharedInstance].avatar isEqualToString:@""]) {
                [cell.profilePhoto sd_setImageWithURL:[NSURL URLWithString:[UserInfo sharedInstance].avatar] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _dicValues[_titleContentArray[0]] = image;
                    [UserInfo saveCacheImage:image withName:@"headImage.jpg"];

                }];
            
            }else{
                [cell.profilePhoto setImage:[UIImage imageNamed:@"me_profile_photo"] forState:UIControlStateNormal];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            NSString *const cellIdentifier = @"profileImageCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
            imageView.layer.cornerRadius = imageView.bounds.size.width/2;
            imageView.layer.masksToBounds = YES;
            imageView.image  = [UserInfo imageForName:@"headImage.jpg"];
            if ([UserInfo imageForName:@"headImage.jpg"] == nil) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo sharedInstance].avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _dicValues[_titleContentArray[0]] = image;
                    imageView.image = image;
                    [UserInfo saveCacheImage:image withName:@"headImage.jpg"];
                }];
            }
            return cell;
        }
    } else if(section == 0) {
        if (row == RowName || row == RowPhoneNumber || row == RowWX_Id) {
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
            }else if (RowPhoneNumber){
                cell.textField.placeholder = @"接受约见后对方可见";
            }else if (RowWX_Id){
                cell.textField.placeholder = @"接受约见后对方可见";
            }else{
                cell.textField.placeholder = _titleContentArray[row];
            }
            cell.textField.indexPath = indexPath;
            if (row == RowPhoneNumber){
                 cell.textField.text = [NSString stringWithFormat:@"%@",_dicValues[_titleContentArray[row]]];
            }else{
                cell.textField.text = _dicValues[_titleContentArray[row]];

            }
            //IQKeyboardItem
//            [cell.textField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"放弃" rightButtonTitle:@"确定" leftButtonAction:@selector(editDone:) rightButtonAction:@selector(editDone:) shouldShowPlaceholder:YES];
            return  cell;
        } else {
            NSString *cellIdentifier = @"profileLabelCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *titlLabel = (UILabel *)[cell viewWithTag:1];
            titlLabel.font = MeViewProfileLabelFont;
            titlLabel.textColor = [UIColor colorWithHexString:MeViewProfileLabelColor];
            titlLabel.text = _titleContentArray[row];
            [titlLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
            }];
            UILabel *contentLabel = (UILabel *)[cell viewWithTag:2];
            contentLabel.text = _dicValues[_titleContentArray[row]];
            contentLabel.font = MeViewProfileLabelFont;
            contentLabel.textColor = [UIColor colorWithHexString:MeViewProfileLabelColor];
            UILabel *lineLabel = [[UILabel alloc] init];
            lineLabel.backgroundColor = [UIColor colorWithHexString:lineLabelBackgroundColor];
            [cell.contentView addSubview:lineLabel];
            [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(20);
                make.right.equalTo(cell.contentView.mas_right).offset(10);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(0);
                make.height.offset(0.5);
            }];
            return  cell;
        }
    } else if (section == 1 || section == 2 || section == 3) {
        NSString * const labelCell =@"defaultCell";
        cell = [tableView dequeueReusableCellWithIdentifier:labelCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCell];
            cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        }
        if (section == 1) {
            if (row < _arrayWorkExper.count) {
                cell.textLabel.text = _arrayWorkExper[row];
                cell.imageView.image = nil;
            } else {
                cell.imageView.image = [UIImage imageNamed:@"imageAdd"];
                cell.textLabel.text =  @"添加工作经历";
            }
        } else if(section == 2) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 49)];
            textField.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            if (![[UserInfo sharedInstance].job_label isEqualToString:@""]) {
                textField.text = [UserInfo sharedInstance].job_label;
            }else if (_arrayWorkExper.count >= 1) {
                NSArray *workArray = [_arrayWorkExper[0] componentsSeparatedByString:@"-"];
                textField.text = [NSString stringWithFormat:@"%@%@",workArray[0],workArray[1]];
                [UserInfo sharedInstance].job_label = textField.text;
            }else{
                textField.placeholder = @"请填写职业标签";
            }
            textField.tag = 10000;
            textField.delegate = self;
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            [cell.contentView addSubview:textField];
        } else if (section == 3) {
            if (row < _arrayEducateExper.count) {
                cell.textLabel.text = _arrayEducateExper[row];
                cell.imageView.image = nil;
            } else {
                cell.imageView.image = [UIImage imageNamed:@"imageAdd"];
                cell.textLabel.text =  @"添加教育背景";
            }
        }
//        NSLog(@"defaultCell section: %d",section);
        return cell;
    } else if (section == 4 || section == 5) {
        NSString *cellIdentifier = @"textViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = @"1 地方不开门地方不开门\n2 好纠结快快快\n3 呵呵几节课\n4 刚好回家";
        return cell;
    }
    return  cell;
}

- (void)editDone:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
}


#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
         _selectRow = row;
        _pickerTitle.text = _titleContentArray[row];
        if (row == 0) {
            if ( !_sheetView) {
                _sheetView = [[UISheetView alloc] initWithContenArray:@[@"拍照",@"相册选择",@"取消"]];
                _sheetView.delegate = self;
            }
            [_sheetView show];
        } else if (row == RowBirthday) {/////date picker
            [self.view endEditing:YES];
            NSString *brithDay =  _dicValues[_titleContentArray[RowBirthday]];
            if (brithDay.length > 8) {
                NSDate *date = [self getDateFromString:brithDay];
                [_datePicker setDate:date animated:NO];
            }
            [self hiddenDatePicker:NO];
            [self showChooseViewAnimation:YES];
        } else if (row == RowSex || row == RowHeight || row == RowWorkLocation || row == RowIncome || row == RowState || row == RowHome || row == RowConstellation|| row == RoWIndustry) {////_pickView
            [self.view endEditing:YES];
            [self hiddenDatePicker:YES];
            [self showChooseViewAnimation:YES];
            if (row == RowWorkLocation || row == RowHome) {
                NSArray *valueArry = _dicPickLocationValue[_titleContentArray[_selectRow]];
                _tempComponet0Row = [valueArry.firstObject intValue];
                
                [_picker selectRow:[valueArry.firstObject intValue] inComponent:0 animated:NO];
                [_picker selectRow:[valueArry.lastObject intValue] inComponent:1 animated:NO];
             
            }else if (row == RowIncome){

                [self setPickView:RowHeight inRowAtValue:26 inTableViewRow:row];
                [_picker selectRow:_pickerSelectRow inComponent:0 animated:NO];
                [_picker selectRow:2 inComponent:0 animated:NO];
            }else if (row == RowState){
                [self setPickView:RowHeight inRowAtValue:26 inTableViewRow:row];
                [_picker selectRow:_pickerSelectRow inComponent:0 animated:NO];
                [_picker selectRow:1 inComponent:0 animated:NO];
            }else  if (row == RoWIndustry){
                [self setPickView:RowHeight inRowAtValue:26 inTableViewRow:row];
                [_picker selectRow:_pickerSelectRow inComponent:0 animated:NO];
                [_picker selectRow:1 inComponent:0 animated:NO];
            }else if (row == RowHeight){
                NSInteger value = [_dicPickSelectValues[_titleContentArray[_selectRow]] intValue];
                _pickerSelectRow = value;
                
                [self setPickView:RowHeight inRowAtValue:26 inTableViewRow:row];
                [_picker selectRow:14 inComponent:0 animated:NO];
            }else{
                NSInteger value = [_dicPickSelectValues[_titleContentArray[_selectRow]] intValue];
                _pickerSelectRow = value;

                [self setPickView:RowHeight inRowAtValue:26 inTableViewRow:row];
                [_picker selectRow:_pickerSelectRow inComponent:0 animated:NO];
            }
        }
    }else if(section == 1 || section == 3 ) {
        [self performSegueWithIdentifier:@"pushToAddInformationVC" sender:indexPath];
    }else if (section == 2){
        
    }else if(section == 5){
        [self performSegueWithIdentifier:@"ModalToMoreProfile" sender:indexPath];
    }else{
        [self performSegueWithIdentifier:@"ModalToAddStar" sender:indexPath];

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
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///头像上传后再保存到本地 刷新
        [_viewModel uploadImage:[info valueForKey:UIImagePickerControllerEditedImage] openId:[WXUserInfo shareInstance].openid success:^(NSDictionary *object) {
            
            if ([[object objectForKey:@"success"] boolValue]) {
                [UserInfo sharedInstance].avatar = [object objectForKey:@"avatar"];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField setReturnKeyType:UIReturnKeyDone];
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        NSIndexPath *indexPath = cellTextField.indexPath;
        if ((indexPath.section == 0) && (indexPath.row == 4 || indexPath.row == 5 )) {
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
            return  YES;
        } else {
            [textField setKeyboardType:UIKeyboardTypeDefault];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
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
    if (textfield.text == nil || [textfield.text isEqualToString:@""]) {
        return ;
    }
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

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToAddInformationVC"]) {
        AddInformationViewController *addInfom = (AddInformationViewController *)[segue destinationViewController];
        __weak typeof(self) weakSelf = self;
        addInfom.block = ^(NSIndexPath *path, NSString *string, ViewEditType type){
            if (type == ViewTypeAdd) {
                if (path.section == 1){
                    [weakSelf.viewModel addWorkExperent:string success:^(NSDictionary *object) {
                        [_arrayWorkExper addObject:string];
                        [_workeExperId addObject:object[@"wid"]];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        NSIndexPath *jobIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
                        [self.tableView reloadRowsAtIndexPaths:@[jobIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
                if (path.section == 1){
                    [weakSelf.viewModel updateWorkExperent:string withWorkId:_workeExperId[path.row] success:^(NSDictionary *object) {
                        [_arrayWorkExper replaceObjectAtIndex:path.row withObject:string];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                }else{
                    [weakSelf.viewModel updateEduExp:string witheduId:_eduExperId[path.row] success:^(NSDictionary *object) {
                        [_arrayEducateExper replaceObjectAtIndex:path.row withObject:string];
                        [self updateEduUserFile:[_arrayEducateExper copy] withEduId:[_eduExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                }
            }else{
                if (path.section == 1){
                    
                    [weakSelf.viewModel deleteWorkExperent:_workeExperId[path.row] success:^(NSDictionary *object) {
                        [_arrayWorkExper removeObjectAtIndex:path.row];
                        [_workeExperId removeObjectAtIndex:path.row];
                        [self updateWorkUserFile:[_arrayWorkExper copy] withId:[_workeExperId copy]];
                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:path.section];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    } fail:^(NSDictionary *object) {
                        
                    } loadingString:^(NSString *str) {
                        
                    }];
                }else{
                    [weakSelf.viewModel deleteEduExperent:_eduExperId[path.row] success:^(NSDictionary *object) {
                        [_arrayEducateExper removeObjectAtIndex:path.row];
                        [_eduExperId removeObjectAtIndex:path.row];
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
        if (addInfom.indexPath.section == 1 || addInfom.indexPath.section == 3) {
            if (addInfom.indexPath.row == _arrayWorkExper.count && addInfom.indexPath.section == 1){
                addInfom.viewType = ViewTypeAdd;
                
            }else if (addInfom.indexPath.row == _arrayEducateExper.count && addInfom.indexPath.section == 3){
                addInfom.viewType = ViewTypeAdd;
            }else{
                addInfom.viewType = ViewTypeEdit;
                if (addInfom.indexPath.section == 1) {
                    addInfom.cachTitles = [_arrayWorkExper objectAtIndex:addInfom.indexPath.row];
                }else{
                    addInfom.cachTitles = [_arrayEducateExper objectAtIndex:addInfom.indexPath.row];
                    
                }
            }
        }
        
    }else if ([segue.identifier isEqualToString:@"ModalToMoreProfile"]) {
//        MoreProfileViewController *moreVC = (MoreProfileViewController *)[segue destinationViewController];
//        moreVC.modifyBlock = ^(){
////            [self checkDocumentGetSmallImages];
//        };
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
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setValue:array[0] forKey:@"company_name"];
//        [dic setValue:array[1] forKey:@"profession"];
//        [dic setValue:workIdString forKey:@"eid"];
//        [dic setValue:@0 forKey:@"income"];
//        [changeArray addObject:dic];
    }
    [UserInfo sharedInstance].work_expirence = [changeArray mutableCopy];
    [UserInfo synchronize];
    
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
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setValue:array[0] forKey:@"graduated"];
//        [dic setValue:array[1] forKey:@"major"];
//        [dic setValue:[[[ProfileKeyAndValue shareInstance].appDic objectForKey:@"education"] objectForKey:array[2]] forKey:@"education"];
//        [dic setValue:eduIdString forKey:@"id"];
        [changeArray addObject:edu];
    }
    [UserInfo sharedInstance].edu_expirence = [changeArray mutableCopy];
    [UserInfo synchronize];
    //    __weak typeof(self) weakSelf = self;
    
}

@end
