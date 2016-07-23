
//
//  InterestCollectView.m
//  Demo
//
//  Created by Zhang on 5/31/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import "InterestCollectView.h"
#import "NSString+StringSize.h"
#import "InterestCollectViewCell.h"
#import "UICollectionView+ARDynamicCacheHeightLayoutCell.h"


@interface InterestCollectView()

@property (nonatomic, assign) BOOL isMeetBlock;
@property (nonatomic, assign) BOOL isNewMeetBlock;

@property (nonatomic, assign) CollectionViewItemStyle style;

@end

@implementation InterestCollectView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _interstArray = [[NSMutableArray alloc] init];
        _selectItems = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[InterestCollectViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.scrollEnabled = NO;
        _isNewMeetBlock = YES;
        _isMeetBlock = YES;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setCollectViewData:(NSArray *)array style:(CollectionViewItemStyle)style;
{
    _edgX = 0;
    _style = style;
    _interstArray = [array mutableCopy];
    [self reloadData];
}

- (void)setCollectViewData:(NSArray *)array andSelectArray:(NSArray *)selectArray
{
    _edgX = 0;
    _interstArray = [array mutableCopy];
    _selectItems = [selectArray mutableCopy];
    [self reloadData];
}

- (CGFloat)interesHeight
{
    return [self.collectionViewLayout collectionViewContentSize].height;

}

- (void)filleCell:(InterestCollectViewCell *)cell withText:(NSString *)text
{
    cell.titleLabel.text = text;
}

- (void)setEdgX:(CGFloat)edgX
{
    _edgX = edgX;
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _interstArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCollectViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.style == ItemWhiteColorAndBlackBoard) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
        cell.layer.borderColor = [[UIColor colorWithHexString:HomeDetailViewNameColor] CGColor];
        cell.layer.borderWidth = 1;
    }else if (self.style == ItemBlackAndWhiteLabelText){
        cell.backgroundColor = [UIColor colorWithHexString:HomeDetailViewNameColor];
        cell.titleLabel.textColor = [UIColor whiteColor];
    }else{
        
    }
    cell.titleLabel.frame = CGRectMake(0, 0, [self cellWidth:_interstArray[indexPath.row]], 27);
    cell.layer.cornerRadius = 2.0f;
    [cell filleCellWithFeed:[_interstArray objectAtIndex:indexPath.row]];
    CGFloat height = [self.collectionViewLayout collectionViewContentSize].height;
    
    if (self.meetInfoBlock && _isMeetBlock) {
        _isMeetBlock = NO;
        self.meetInfoBlock(height);
    }
    if (self.block && _isNewMeetBlock) {
        _isNewMeetBlock = NO;
        self.block(height);
    }
    
    return cell;
}

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self cellWidth:[_interstArray objectAtIndex:indexPath.row]], 27);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (_edgX == 0) {
        return 6;
    }else{
        return _edgX;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}

-(CGFloat)cellWidth:(NSString *)itemString
{
    CGFloat cellWidth;
    cellWidth = [itemString widthWithFont:[UIFont systemFontOfSize:13.0] constrainedToHeight:18] + 18;
    return cellWidth;
}

@end
