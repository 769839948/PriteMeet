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
#import "ZHPickView.h"
#import "Masonry.h"
#import "UITools.h"

@interface AddInformationViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate,ZHPickViewDelegate> {
    NSMutableDictionary *_dicValues;
}

@property (nonatomic, strong) ZHPickView *pickerView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *cachTitleArray;
@property (nonatomic, copy) NSArray *pickArray;

@property (nonatomic, copy) NSArray *alertViewMsg;

@property (nonatomic, copy) NSString *leftIetmColor;

@property (nonatomic, copy) NSArray *placeholderTitle;

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *positionName;

@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *major;
@property (nonatomic, copy) NSString *educational;

@end

@implementation AddInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dicValues = [NSMutableDictionary dictionary];
    _cachTitleArray = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_savebt"] style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    NSString *str;
    if (_viewType == ViewTypeEdit) {
        _leftIetmColor = @"202020";
        str = @"";
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    } else if (_viewType == ViewTypeAdd) {
         str = @"添加";
        _companyName = @"";
        _positionName = @"";
        _school = @"";
        _major = @"";
        _educational = @"";
        _leftIetmColor = @"E7E7E7";

    }
    if (_indexPath.section == 2 ) {////work
        _navTitle = [str stringByAppendingString:@"工作经历"];
         NSArray  *array = [_cachTitles componentsSeparatedByString:@"-"];
        [_cachTitleArray addObjectsFromArray:array];
        while (_cachTitleArray.count < 2) {
            [_cachTitleArray addObject:@""];
        }
        _alertViewMsg = @[@"请填写公司信息",@"请填写职位信息"];
        _arrayTitles = @[@"公司",@"职位"];
        _placeholderTitle = @[@"公司简称",@"职位名称"];
    } else if (_indexPath.section == 3) {
        _navTitle = [str stringByAppendingString:@"教育背景"];
        NSArray  *array = [_cachTitles componentsSeparatedByString:@"-"];
        [_cachTitleArray addObjectsFromArray:array];
        while (_cachTitleArray.count < 3) {
            [_cachTitleArray addObject:@""];
        }
        _arrayTitles = @[@"学校",@"专业",@"学历"];
        _placeholderTitle = @[@"学校名称",@"专业名称",@"学历名称"];
        _alertViewMsg = @[@"请填写学校信息",@"请填写专业信息",@"请填写学历信息"];
        _pickArray = @[@"专科", @"本科", @"硕士", @"博士", @"博士后", @"MBA", @"其他"];
    }
    self.title = _navTitle;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:_leftIetmColor];
    //[UIColor colorWithHexString:@"202020"];
}


- (void)pickerViewShow
{
    if (_pickerView == nil) {
        _pickerView = [[ZHPickView alloc] initPickviewWithArray:_pickArray isHaveNavControler:NO];
        _pickerView.delegate = self;
        [_pickerView setTintFont:IQKeyboardManagerFont color:[UIColor colorWithHexString:IQKeyboardManagerTinColor]];
        [_pickerView setSelectRow:1 inComponent:0 animate:YES];
        [_pickerView setToobarCenterTitle:@"学历" color:[UIColor colorWithHexString:IQKeyboardManagerTinColor] font:IQKeyboardManagerplaceholderFont];
        [_pickerView setPickViewColer:[UIColor whiteColor]];
        [_pickerView setToolbarTintColor:[UIColor whiteColor]];
        [_pickerView show];
    }else{
        [_pickerView show];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![_pickerView isHidden]) {
        [_pickerView remove];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveAction:(id)sender {
   
    if (_indexPath.section == 2) {
        if ([_leftIetmColor isEqualToString:@"E7E7E7"]) {
            if ([_companyName isEqualToString:@""] || _companyName == nil) {
                [[UITools shareInstance] showMessageToView:self.view message:_alertViewMsg[0] autoHide:YES];
            }else{
                [[UITools shareInstance] showMessageToView:self.view message:_alertViewMsg[1] autoHide:YES];
            }
        }else{
            if (self.block) {
                NSString *str = @"";
                for (NSInteger i = 0; i < _cachTitleArray.count ; i ++) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    LabelAndTextFieldCell *cell = (LabelAndTextFieldCell *)[self.tableView cellForRowAtIndexPath:path];
                    str = [str stringByAppendingString:cell.textField.text];
                    if (i < _cachTitleArray.count - 1) {
                        str = [str stringByAppendingString:@"-"];
                    }
                }
                self.block(self.indexPath,str,self.viewType);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else{
        if ([_leftIetmColor isEqualToString:@"E7E7E7"]) {
            if ([_school isEqualToString:@""] || _school == nil) {
                [[UITools shareInstance] showMessageToView:self.view message:_alertViewMsg[0] autoHide:YES];
            }else if([_major isEqualToString:@""] || _major == nil){
                [[UITools shareInstance] showMessageToView:self.view message:_alertViewMsg[1] autoHide:YES];
            }else{
                [[UITools shareInstance] showMessageToView:self.view message:_alertViewMsg[2] autoHide:YES];
            }
        }else{
            if (self.block) {
                NSString *str = @"";
                for (NSInteger i = 0; i < _cachTitleArray.count ; i ++) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    LabelAndTextFieldCell *cell = (LabelAndTextFieldCell *)[self.tableView cellForRowAtIndexPath:path];
                    str = [str stringByAppendingString:cell.textField.text];
                    if (i < _cachTitleArray.count - 1) {
                        str = [str stringByAppendingString:@"-"];
                    }
                }
                self.block(self.indexPath,str,self.viewType);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
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
        if (_indexPath.section == 2 ) {
            cell.label.text = @"删除工作经历";
        }else{
            cell.label.text = @"删除教育背景";
        }
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
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
        cell.textField.placeholder = _placeholderTitle[indexPath.row];
        cell.textField.delegate = self;
        cell.tag = indexPath.row;
        cell.textField.tag = indexPath.row;
        if (_indexPath.section == 3 && indexPath.row == 2) {
            cell.textField.enabled = NO;
            if (_viewType == ViewTypeEdit) {
                cell.textField.text = _cachTitleArray[indexPath.row];
            }else{
                cell.textField.text = @"未选择";
            }
            if ([cell.textField.text isEqualToString:@"未选择"]) {
                cell.textField.textColor = [UIColor colorWithHexString:MeViewProfileContentLabelColorLight];
            }else{
                cell.textField.textColor = [UIColor colorWithHexString:MeViewProfileContentLabelColor];
            }
            [cell.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(0);
            }];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell updateConstraintsIfNeeded];
            [cell.lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(10);
            }];
        }
        cell.textField.userInteractionEnabled = YES;
        if (indexPath.row == 0 &&  _viewType == ViewTypeAdd) {
            [cell.textField becomeFirstResponder];
        }
        cell.textField.returnKeyType = UIReturnKeyNext;
        [cell.textField setValue:[UIColor colorWithHexString:MeViewProfileContentLabelColorLight] forKeyPath:@"_placeholderLabel.textColor"];

        return cell;
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_viewType == ViewTypeEdit && indexPath.row == _cachTitleArray.count ) {
        NSString *message = @"";
        if (_indexPath.section == 2){
            message = @"确定删除此段工作经历？";
        }else{
            message = @"确定删除此教育背景吗？";
        }
        [EMAlertView showAlertWithTitle:nil message:message completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
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
    if (_indexPath.section == 3 && indexPath.row == 2) {
        [self.view endEditing:YES];
        [self pickerViewShow];
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
        }else if ((indexPath.section == 0) && (indexPath.row == 2)){
            
            return NO;
        }else {
            [textField setKeyboardType:UIKeyboardTypeDefault];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger tag = textField.tag;
    [textField resignFirstResponder];
    if (_viewType == ViewTypeAdd) {
        if (tag < _arrayTitles.count) {
            tag = tag + 1;
            LabelAndTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag  inSection:0]];
            [cell.textField becomeFirstResponder];
        }else{
            [self.view endEditing:YES];
        }
        
        if (self.indexPath.section == 3 && tag == 2){
            [self pickerViewShow];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.indexPath.section == 2) {
        if (![string isEqualToString:@""]) {
            if (textField.tag == 0) {
                _companyName = [textField.text stringByAppendingString:string];
            }else if (textField.tag == 1){
                _positionName = [textField.text stringByAppendingString:string];
            }
        }else{
            if (textField.tag == 0) {
                if (textField.text.length == 0 || (range.location == 0 && [string isEqualToString:@""])) {
                    if (![string isEqualToString:@""] || ![textField.text isEqualToString:@""]) {
                        _companyName = textField.text;
                    }else{
                        _companyName = @"";
                    }
                }
            }else if (textField.tag == 1){
                if (textField.text.length == 0 || (range.location == 0 && [string isEqualToString:@""])) {
                    if (![string isEqualToString:@""] || ![textField.text isEqualToString:@""]) {
                        _positionName = textField.text;
                    }else{
                        _positionName = @"";
                    }
                }
            }
        }
        if (![_companyName isEqualToString:@""] && ![_positionName isEqualToString:@""]) {
            _leftIetmColor = @"020202";
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:_leftIetmColor];
        }else{
            _leftIetmColor = @"E7E7E7";
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:_leftIetmColor];
        }
    }else{
        if (![string isEqualToString:@""]) {
            if (textField.tag == 0) {
                _school = [textField.text stringByAppendingString:string];
            }else if (textField.tag == 1){
                _major = [textField.text stringByAppendingString:string];
            }else if (textField.tag == 2){
                _educational = [textField.text stringByAppendingString:string];
            }
        }else{
            if (textField.tag == 0) {
                if (textField.text.length == 0 || (range.location == 0 && [string isEqualToString:@""])) {
                    if (![string isEqualToString:@""] || ![textField.text isEqualToString:@""]) {
                        _school = textField.text;
                    }else{
                        _school = @"";
                    }
                }
            }else if (textField.tag == 1){
                if (textField.text.length == 0 || (range.location == 0 && [string isEqualToString:@""])) {
                    if (![string isEqualToString:@""] || ![textField.text isEqualToString:@""]) {
                        _major = textField.text;
                    }else{
                        _major = @"";
                    }
                }
            }else if (textField.tag == 2){
                if (textField.text.length == 0 || (range.location == 0 && [string isEqualToString:@""])) {
                    if (![string isEqualToString:@""] || ![textField.text isEqualToString:@""]) {
                        _educational = textField.text;
                    }else{
                        _educational = @"";
                    }
                }
            }
        }
        [self showNavigationBarItemColor];
    }
    
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


-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    [_pickerView remove];
    LabelAndTextFieldCell *cellTextField = (LabelAndTextFieldCell *)[self.view viewWithTag:2];
    cellTextField.textField.text = resultString;
    cellTextField.textField.textColor = [UIColor colorWithHexString:MeViewProfileContentLabelColor];
    _educational = resultString;
    [self showNavigationBarItemColor];
    
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = _pickArray[row];
    return string;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    self.selectItem = _pickArray[row];
}

- (void)showNavigationBarItemColor
{
    if (![_school isEqualToString:@""] && ![_major isEqualToString:@""] && ![_educational isEqualToString:@""]) {
        _leftIetmColor = @"020202";
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:_leftIetmColor];
    }else{
        _leftIetmColor = @"E7E7E7";
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:_leftIetmColor];
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
