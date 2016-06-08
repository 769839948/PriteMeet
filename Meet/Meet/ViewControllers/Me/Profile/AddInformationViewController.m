//
//  AddInformationViewController.m
//  Meet
//
//  Created by jiahui on 16/5/5.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "AddInformationViewController.h"
#import "LabelAndTextFieldCell.h"
#import "CellTextField.h"
#import "LabelTableViewCell.h"
#import "IQUIView+IQKeyboardToolbar.h"


@interface AddInformationViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate> {
    NSMutableDictionary *_dicValues;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *cachTitleArray;

@end

@implementation AddInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dicValues = [NSMutableDictionary dictionary];
    _cachTitleArray = [NSMutableArray array];
    NSString *str;
    if (_viewType == ViewTypeEdit) {
        str = @"编辑";
    } else if (_viewType == ViewTypeAdd) {
         str = @"添加";
    }
    if (_indexPath.section == 1 ) {////work
        _navTitle = [str stringByAppendingString:@"工作经历"];
         NSArray  *array = [_cachTitles componentsSeparatedByString:@"-"];
        [_cachTitleArray addObjectsFromArray:array];
        while (_cachTitleArray.count < 2) {
            [_cachTitleArray addObject:@""];
        }
        _arrayTitles = @[@"公司",@"职位"];
    } else if (_indexPath.section == 3) {
        _navTitle = [str stringByAppendingString:@"教育背景"];
        NSArray  *array = [_cachTitles componentsSeparatedByString:@"-"];
        [_cachTitleArray addObjectsFromArray:array];
        while (_cachTitleArray.count < 3) {
            [_cachTitleArray addObject:@""];
        }
        _arrayTitles = @[@"学校",@"专业",@"学历"];
    }
    self.navigationItem.title = _navTitle;
//    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
//    [UITools navigationRightBarButtonForController:self action:@selector(saveAction:) normalTitle:@"保存" selectedTitle:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_savebt"] style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"202020"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveAction:(id)sender {
    
    if (self.block) {
        NSString *str = @"";
        for (NSInteger i = 0; i < _cachTitleArray.count ; i ++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            LabelAndTextFieldCell *cell = (LabelAndTextFieldCell *)[self.tableView cellForRowAtIndexPath:path];
            str = [str stringByAppendingString:cell.textField.text];
            if (i < _cachTitleArray.count - 1) {
                str = [str stringByAppendingString:@" - "];
            }
        }
        self.block(self.indexPath,str,self.viewType);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_viewType == ViewTypeAdd) {
        return _arrayTitles.count;
    } else
        return _arrayTitles.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayTitles.count) {
        return 120;
    }
    if (indexPath.row == 0) {
        return 71;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayTitles.count) {
        LabelTableViewCell *cell = (LabelTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil][0];
        if (indexPath.section == 1 ) {
            cell.label.text = @"删除工作经历";
        }else{
            cell.label.text = @"删除教育经历";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        NSString *cellIdentifier = @"profileTextFieldCell";
        LabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = (LabelAndTextFieldCell *)[[[NSBundle mainBundle] loadNibNamed:@"LabelAndTextFieldCell" owner:self options:nil] objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textField.delegate = self;
        }
        cell.titelLabel.text = _arrayTitles[indexPath.row];
        if (_viewType == ViewTypeEdit) {
            cell.textField.text = _cachTitleArray[indexPath.row];
        }
        cell.textField.indexPath = indexPath;
        cell.textField.placeholder = _arrayTitles[indexPath.row];
        //IQKeyboardItem
        [cell.textField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"放弃" rightButtonTitle:@"确定" leftButtonAction:@selector(editDone:) rightButtonAction:@selector(editDone:) shouldShowPlaceholder:YES];
        return cell;
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_viewType == ViewTypeEdit && indexPath.row == _cachTitleArray.count) {
        [EMAlertView showAlertWithTitle:@"提示" message:@"确定删除？" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                    if (self.block) {
                        self.block(_indexPath,@"",ViewTypeDelete);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    break;
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    }
    
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
    return YES;
}

- (void)mappingTextFieldDictionary:(CellTextField *)textfield {
    if (textfield.text == nil || [textfield.text isEqualToString:@""]) {
        return ;
    }
    NSIndexPath *indexPath = textfield.indexPath;
    NSInteger row = indexPath.row;
    NSString *dictionKey = @"key";
    dictionKey = _arrayTitles[row];
    _dicValues[dictionKey] = textfield.text;
}

- (void)editDone:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
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
