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
    
    float orginX = ([[UIScreen mainScreen] bounds].size.width - 20 - imageWidth * 3)/6;
    _nameAut = [[UIImageView alloc] init];
    _nameAut.image = [UIImage imageNamed:@"meetdetail_namaaut"];
    _nameAut.frame = CGRectMake(orginX, 26, imageWidth, imageHeight);
    //    _learnMore.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_nameAut];
    
    _comapyAut = [[UIImageView alloc] init];
    _comapyAut.image = [UIImage imageNamed:@"meetdetail_companyaut"];
    _comapyAut.frame = CGRectMake(orginX * 3 + imageWidth, 26, imageWidth, imageHeight);
    //    _learnMore.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_comapyAut];
    
    _photoAut = [[UIImageView alloc] init];
    //    _learnMore.backgroundColor = [UIColor redColor];
    _photoAut.image = [UIImage imageNamed:@"meetdetail_photoaut"];
    _photoAut.frame = CGRectMake(orginX * 5 + imageWidth * 2, 26, imageWidth, imageHeight);
    [self.contentView addSubview:_photoAut];
    
    
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
