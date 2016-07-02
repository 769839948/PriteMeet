//
//  AddJobLabelTableViewCell.m
//  Meet
//
//  Created by Zhang on 7/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "AddJobLabelTableViewCell.h"
#import "JobLableCollectViewCell.h"
#import "InterestCollectView.h"
#import "EqualSpaceFlowLayout.h"
#import "NSString+StringSize.h"
#import "Masonry.h"

@interface AddJobLabelTableViewCell()<UITextFieldDelegate>

@property (nonatomic, strong) JobLableCollectViewCell *jobLabel;

@property (nonatomic, strong) EqualSpaceFlowLayout *flowLayout;

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, assign) BOOL isSelectItem;

@property (nonatomic, assign) NSInteger selectItemRow;

@property (nonatomic, copy) NSMutableArray *interestArray;


@end

@implementation AddJobLabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
        _interestArray = [NSMutableArray array];
    }
    return self;
}

- (void)setUpView
{
    //确定是水平滚动，还是垂直滚动
    __weak typeof(self) weakSelf = self;
    _flowLayout = [[EqualSpaceFlowLayout alloc] init];
    _jobLabel = [[JobLableCollectViewCell alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _flowLayout.delegate = _jobLabel;
    _jobLabel.block = ^(NSIndexPath *indexPath, BOOL isSelect){
        weakSelf.isSelectItem = isSelect;
        weakSelf.selectItemRow = indexPath.row;
    };
    [self.contentView addSubview:_jobLabel];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:leftView.frame];
    leftImage.image = [UIImage imageNamed:@"me_profile_addjoblabel"];
    [leftView addSubview:leftImage];
    
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.leftView = leftView;
    _textField.font = [UIFont fontWithName:@"PingFangSC-Light" size:12.0];
    _textField.leftViewMode = UITextFieldViewModeUnlessEditing;
    _textField.placeholder = @"添加职业标签";
    [self.contentView addSubview:_textField];
    [self updateConstraints];

}


- (void)configCell:(NSArray *)array
{
    _interestArray = [[NSMutableArray alloc] initWithArray:array.mutableCopy];
    [self setData:_interestArray];
}

- (void)reloadData
{
    [self setData:_interestArray];
}

- (void)setData:(NSArray *)array
{
    if (array.count == 0) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.jobLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(20);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.textField.mas_top).offset(-20);
            make.height.offset(0);
        }];
        
        [weakSelf.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(24);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-24);
            make.height.mas_offset(15);
        }];
    }else{
        [_jobLabel setCollectViewData:_interestArray.copy];
        __weak typeof(self) weakSelf = self;
        [weakSelf.jobLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(24);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.textField.mas_top).offset(-24);
            make.height.offset([weakSelf cellHeight:_interestArray.copy]);
        }];
        
        [weakSelf.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.jobLabel.mas_bottom).offset(24);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-24);
            make.height.mas_offset(15);
        }];
    }
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];

}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        __weak typeof(self) weakSelf = self;
        [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(20);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.textField.mas_top).offset(-10);
        }];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.jobLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-30);
            make.height.mas_offset(15);
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (CGFloat)cellHeight:(NSArray *)interArray
{
    CGFloat yOffset = 31;
    CGFloat allSizeWidth = 0;
    for (NSInteger idx = 0; idx < interArray.count; idx++) {
        CGSize itemSize = CGSizeMake([self cellWidth:[interArray objectAtIndex:idx]], 31);
        allSizeWidth = allSizeWidth + itemSize.width + 10;
        if (allSizeWidth > ScreenWidth - 40) {
            yOffset = yOffset + 38;
            allSizeWidth = itemSize.width + 10;
        }
    }
    return yOffset;
}

- (CGFloat)cellWidth:(NSString *)itemString
{
    CGFloat cellWidth;
    cellWidth = [itemString widthWithFont:[UIFont systemFontOfSize:13.0] constrainedToHeight:18];
    return cellWidth + 18;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        [_interestArray addObject:textField.text];
    }
    textField.text = @"";
    if (self.block) {
        self.block(_interestArray);
    }
    [self reloadData];
    return  YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""] && [textField.text isEqualToString:@""]) {
        if (_isSelectItem) {
            [_interestArray removeObjectAtIndex:_selectItemRow];
            [self reloadData];
            _isSelectItem = NO;
        }else{
            [_jobLabel collectionView:_jobLabel didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:_interestArray.count - 1 inSection:0]];
        }
    }
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
