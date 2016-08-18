//
//  CompayTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//
#import "CompayTableViewCell.h"
#import "Masonry.h"

#define imageWidth 52
#define imageHeight 50

@interface CompayTableViewCell()

@property (nonatomic, strong) UILabel *lineLabel;


@property (nonatomic, strong) UIImageView *nameAut;
@property (nonatomic, strong) UIImageView *comapyAut;
@property (nonatomic, strong) UIImageView *photoAut;

@end

@implementation CompayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showdowView.hidden = YES;
        [self setWhiteView:NO isBottom:NO];
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 40, 0.5)];
    _lineLabel.backgroundColor = MeetDetailLineColor;
    [self.contentView addSubview:_lineLabel];
    
    float orginX = ((ScreenWidth - 20) - imageWidth * 3)/6;
    _nameAut = [[UIImageView alloc] init];
    _nameAut.image = [UIImage imageNamed:@"home_name_unselect"];
    _nameAut.frame = CGRectMake(orginX + 10, 26, imageWidth, imageHeight);
    [self.contentView addSubview:_nameAut];
    
    _comapyAut = [[UIImageView alloc] init];
    _comapyAut.image = [UIImage imageNamed:@"home_job_unselect"];
    _comapyAut.frame = CGRectMake(orginX * 3 + imageWidth  + 10, 26, imageWidth, imageHeight);
    [self.contentView addSubview:_comapyAut];
    
    _photoAut = [[UIImageView alloc] init];
    _photoAut.image = [UIImage imageNamed:@"home_phone_unselect"];
    _photoAut.frame = CGRectMake(orginX * 5 + imageWidth * 2  + 10, 26, imageWidth, imageHeight);
    [self.contentView addSubview:_photoAut];
    
    
}


- (void)configCell:(NSString *)auto_info
{
    NSArray *auto_infoArray = [auto_info componentsSeparatedByString:@","];
    for (NSString *autoInfo in auto_infoArray) {
        if ([autoInfo isEqualToString:@"1"]) {
            _nameAut.image = [UIImage imageNamed:@"home_name_select"];
        }else if ([autoInfo isEqualToString:@"2"]){
            _comapyAut.image = [UIImage imageNamed:@"home_job_select"];
        }else if ([autoInfo isEqualToString:@"3"]){
            _photoAut.image = [UIImage imageNamed:@"home_phone_select"];
        }
    }
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
