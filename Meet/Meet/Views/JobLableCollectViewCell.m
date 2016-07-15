
//
//  InterestCollectView.m
//  Demo
//
//  Created by Zhang on 5/31/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import "JobLableCollectViewCell.h"
#import "NSString+StringSize.h"
#import "InterestCollectViewCell.h"
#import "UICollectionView+ARDynamicCacheHeightLayoutCell.h"


@interface JobLableCollectViewCell()

@property (nonatomic, assign) BOOL isMeetBlock;
@property (nonatomic, assign) BOOL isNewMeetBlock;

@end

@implementation JobLableCollectViewCell


static NSString * const reuseIdentifier = @"InterstCollectViewCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _interstArray = [[NSMutableArray alloc] init];
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

- (void)setCollectViewData:(NSArray *)array;
{
    _edgX = 0;
    _interstArray = [array mutableCopy];
    [self reloadData];
    //    if (![_interstArray isEqualToArray:array]) {
    //
    //    }
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
    cell.layer.borderColor = [[UIColor blackColor] CGColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderWidth = 1.0;
    cell.titleLabel.frame = CGRectMake(0, 0, [self cellWidth:_interstArray[indexPath.row]], 30);
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.layer.cornerRadius = 2.0f;
    [cell filleCellWithFeed:[_interstArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSInteger i = 0; i < _interstArray.count; i ++)
    {
        if (indexPath.row == i) {
            InterestCollectViewCell *cell = (InterestCollectViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (cell.backgroundColor == [UIColor blackColor]) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.titleLabel.textColor = [UIColor blackColor];
                if (self.block) {
                    self.block(indexPath, NO);
                }
            }else{
                cell.backgroundColor = [UIColor blackColor];
                cell.titleLabel.textColor = [UIColor whiteColor];
                if (self.block) {
                    self.block(indexPath, YES);
                }
            }
        }else{
            InterestCollectViewCell *cell = (InterestCollectViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.textColor = [UIColor blackColor];
        }
    }
    
    
    
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
    return CGSizeMake([self cellWidth:[_interstArray objectAtIndex:indexPath.row]], 30);
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
