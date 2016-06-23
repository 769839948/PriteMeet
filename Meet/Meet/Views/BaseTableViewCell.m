//
//  BaseTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Masonry.h"


@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _showdowView = [[UIView alloc] init];
        _showdowView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        _showdowView.layer.cornerRadius = 5.0;
        [self.contentView addSubview:_showdowView];
        __weak typeof(self) weakSelf = self;
        [_showdowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
        }];
        
        
        
        
    }
    return self;
}

- (void)setWhiteView:(BOOL)isCornerRadius isBottom:(BOOL)isBottom
{
    if (isCornerRadius && isBottom) {
        _whitView = [[UIView alloc] init];
        _whitView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_whitView];
        _whitView.layer.cornerRadius = 5.0;
        __weak typeof(self) weakSelf = self;
        [_whitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.showdowView.mas_bottom).offset(-6);
        }];

    }else if (isCornerRadius && !isBottom){
        _whitView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.contentView.bounds.size.width - 20, 59)];
        _whitView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_whitView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth - 20, 59) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, ScreenWidth - 20, 99);
        maskLayer.path = maskPath.CGPath;
        _whitView.layer.mask = maskLayer;
        __weak typeof(self) weakSelf = self;
        [_whitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
        }];
        
    }else{
        _whitView = [[UIView alloc] init];
        _whitView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_whitView];
        __weak typeof(self) weakSelf = self;
        [_whitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
        }];

    }
}

- (void)setWhiteView:(BOOL)isOnBottom isMoreCell:(BOOL)isMoreCell
{
    _whitView = [[UIView alloc] init];
    _whitView.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_whitView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _whitView.bounds;
    maskLayer.path = maskPath.CGPath;
    _whitView.layer.mask = maskLayer;
    [self.contentView addSubview:_whitView];
    __weak typeof(self) weakSelf = self;    
    [_whitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showdowView.mas_top).offset(0);
        make.left.equalTo(weakSelf.showdowView.mas_left).offset(0);
        make.right.equalTo(weakSelf.showdowView.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.showdowView.mas_bottom).offset(1);
    }];
    
}

- (void)setCircular:(NSArray *)controllerArray
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_showdowView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _showdowView.bounds;
    maskLayer.path = maskPath.CGPath;
    _showdowView.layer.mask = maskLayer;
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
