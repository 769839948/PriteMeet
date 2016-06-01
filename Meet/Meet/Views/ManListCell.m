//
//  ManListCell.m
//  Meet
//
//  Created by jiahui on 16/4/29.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "ManListCell.h"
#import "InterestCollectView.h"

@interface ManListCell ()
{
    UIView *_personalView;
    UIView *_showdowView;
    UILabel *_nameLabel;
    UIImageView *_photoImage;
    UIButton *_likeBtn;
    UIButton *_ageNumber;
    UILabel *_positionName;
    UILabel *_meetNumber;
    UILabel *_location;
    
    InterestCollectView *_interestView;
    
}

@end

@implementation ManListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpView];
    }
    return self;
}


- (void)setUpView
{
    _showdowView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width - 20, 325)];
    _showdowView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    _showdowView.layer.cornerRadius = 5.0f;
    [self.contentView addSubview:_showdowView];
    
    _personalView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width - 20, 320)];
    _personalView.backgroundColor = [UIColor whiteColor];
    _personalView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:_personalView];
    
    
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _personalView.frame.size.width, 200)];
    //    _photoImage.backgroundColor = [UIColor redColor];
    _photoImage.image = [UIImage imageNamed:@"Pic"];
    [_personalView addSubview:_photoImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, _photoImage.frame.size.height + 14, _personalView.frame.size.width - 28, 30)];
    _nameLabel.font = [UIFont systemFontOfSize:22.55f];
    _nameLabel.text = @"陈涛 美匠科技联合创始人";
    NSArray *textArray = [_nameLabel.text componentsSeparatedByString:@" "];
    NSString *userName = [NSString stringWithFormat:@"%@",[textArray objectAtIndex:0]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_nameLabel.text];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:22.55f] range:NSMakeRange(0, userName.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]} range:NSMakeRange(0, userName.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]} range:NSMakeRange(userName.length, _nameLabel.text.length - userName.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Light" size:22.55f] range:NSMakeRange(userName.length, _nameLabel.text.length - userName.length)];
    _nameLabel.numberOfLines = 0;
    _nameLabel.attributedText = str;
    [_personalView addSubview:_nameLabel];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(_personalView.frame.size.width - 67, 169, 40, 40);
    _likeBtn.layer.cornerRadius = 20;
    [_likeBtn setImage:[UIImage imageNamed:@"Icon_Like"] forState:UIControlStateNormal];
    _likeBtn.layer.shadowOffset = CGSizeMake(0, 1);
    _likeBtn.layer.shadowOpacity = 1.0;
    _likeBtn.layer.shadowRadius = 3;
    _likeBtn.layer.shadowColor = [[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0] CGColor];
    _likeBtn.backgroundColor = [UIColor whiteColor];
    [_personalView addSubview:_likeBtn];
    
    
    _meetNumber = [[UILabel alloc] initWithFrame:CGRectMake(14, _nameLabel.frame.size.height + _nameLabel.frame.origin.y + 1, _personalView.frame.size.width - 28, 17)];
    _meetNumber.font = [UIFont systemFontOfSize:12.0f];
    _meetNumber.textColor = [UIColor lightGrayColor];
    _meetNumber.text = @"62人想见   和你相隔 820M";
    [_personalView addSubview:_meetNumber];
    
    _ageNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    _ageNumber.frame = CGRectMake(_personalView.frame.size.width - 70, 18, 46, 24);
    _ageNumber.layer.cornerRadius = 12;
    
    _ageNumber.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:232.0/255.0 alpha:1.0];
    [_personalView addSubview:_ageNumber];
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _interestView = [[InterestCollectView alloc] initWithFrame:CGRectMake(14, _meetNumber.frame.size.height + _meetNumber.frame.origin.y + 15, _personalView.frame.size.width - 28, 37) collectionViewLayout:flowLayout];
    [_interestView setCollectViewData:@[@"旅行顾问",@"创意总监",@"谈判专家",@"顾问"]];
    [_personalView addSubview:_interestView];
    
    
    
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
