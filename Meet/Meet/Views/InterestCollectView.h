//
//  InterestCollectView.h
//  Demo
//
//  Created by Zhang on 5/31/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EqualSpaceFlowLayout.h"

@interface InterestCollectView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,EqualSpaceFlowLayoutDelegate>

@property (nonatomic, copy) NSMutableArray *interstArray;

@property (nonatomic, assign) CGFloat edgX;

- (void)setCollectViewData:(NSArray *)array;

@end
