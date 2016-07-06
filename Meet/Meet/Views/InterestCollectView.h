//
//  InterestCollectView.h
//  Demo
//
//  Created by Zhang on 5/31/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EqualSpaceFlowLayout.h"

typedef void (^ReturnColloctHeight)(CGFloat height);
typedef void (^ReturnMeetInfoHeight)(CGFloat height);

static NSString * const reuseIdentifier = @"InterstCollectViewCell";


@interface InterestCollectView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,EqualSpaceFlowLayoutDelegate>


@property (nonatomic, copy) NSMutableArray *interstArray;

@property (nonatomic, copy) NSMutableArray *selectItems;

@property (nonatomic, strong) ReturnColloctHeight block;
@property (nonatomic, strong) ReturnMeetInfoHeight meetInfoBlock;

@property (nonatomic, assign) CGFloat edgX;

- (void)setCollectViewData:(NSArray *)array;


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)interesHeight;

-(CGFloat)cellWidth:(NSString *)itemString;

- (void)setCollectViewData:(NSArray *)array andSelectArray:(NSArray *)selectArray;

@end
