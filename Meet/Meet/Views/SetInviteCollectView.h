//
//  SetInviteCollectView.h
//  Meet
//
//  Created by Zhang on 7/5/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "InterestCollectView.h"

typedef void (^InviteCollectViewSelectBlock)(NSInteger selectItem);

@interface SetInviteCollectView : InterestCollectView

@property (nonatomic, strong) InviteCollectViewSelectBlock block;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
