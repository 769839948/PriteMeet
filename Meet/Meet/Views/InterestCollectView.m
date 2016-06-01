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

@implementation InterestCollectView


static NSString * const reuseIdentifier = @"InterstCollectViewCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _interstArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[InterestCollectViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setCollectViewData:(NSArray *)array;
{
    if (_interstArray.count == 0) {
        _interstArray = [array mutableCopy];
        [self reloadData];
    }
    float height = [self.collectionViewLayout collectionViewContentSize].height;
    NSLog(@"---------%f",height);
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return 10;
    return _interstArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCollectViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        NSLog(@"---");
    }
    cell.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0];
    cell.layer.cornerRadius = 2.0f;
    cell.titleLabel.text = [_interstArray objectAtIndex:indexPath.row];
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
    return 6;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}

-(CGFloat)cellWidth:(NSString *)itemString
{
    CGFloat cellWidth;
    cellWidth = [itemString widthWithFont:[UIFont systemFontOfSize:18.0] constrainedToHeight:27];
    return cellWidth;
}

@end
