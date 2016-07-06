//
//  InterestCollectView.h
//  Demo
//
//  Created by Zhang on 5/31/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EqualSpaceFlowLayout.h"

typedef void (^ReturnSelectIndexPath)(NSIndexPath *indexPath, BOOL isSelect);

@interface JobLableCollectViewCell : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,EqualSpaceFlowLayoutDelegate>


@property (nonatomic, copy) NSMutableArray *interstArray;

@property (nonatomic, strong) ReturnSelectIndexPath block;

@property (nonatomic, assign) CGFloat edgX;

- (void)setCollectViewData:(NSArray *)array;

- (CGFloat)interesHeight;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
