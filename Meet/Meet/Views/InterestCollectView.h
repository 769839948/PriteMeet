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

@interface InterestCollectView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,EqualSpaceFlowLayoutDelegate>


@property (nonatomic, copy) NSMutableArray *interstArray;

@property (nonatomic, strong) ReturnColloctHeight block;
@property (nonatomic, strong) ReturnMeetInfoHeight meetInfoBlock;

@property (nonatomic, assign) CGFloat edgX;

- (void)setCollectViewData:(NSArray *)array;


- (CGFloat)interesHeight;

@end
