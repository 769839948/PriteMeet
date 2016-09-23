//
//  SetInviteCollectView.m
//  Meet
//
//  Created by Zhang on 7/5/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "SetInviteCollectView.h"
#import "InterestCollectViewCell.h"
#import "UserInviteModel.h"
@implementation SetInviteCollectView


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCollectViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if ([self.selectItems[indexPath.row] isEqualToString:@"true"]) {
        [cell filleCellWithFeed:[self.interstArray objectAtIndex:indexPath.row] type:ItemOriginBacAndWhiteText];
    }else{
        [cell filleCellWithFeed:[self.interstArray objectAtIndex:indexPath.row] type:ItemWhiteBacAndGrateText];
    }
    
    cell.titleLabel.frame = CGRectMake(7, 0, [self cellWidth:self.interstArray[indexPath.row]], 30);
    cell.layer.cornerRadius = 2.0f;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCollectViewCell *cell = (InterestCollectViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.isSelect) {
        [cell filleCellSelect:YES];
        [self.selectItems replaceObjectAtIndex:indexPath.row withObject:@"true"];
    }else{
        [cell filleCellSelect:NO];
        [self.selectItems replaceObjectAtIndex:indexPath.row withObject:@"false"];
    }
    if (self.selectBlock != nil) {
        self.selectBlock(indexPath.row);
    }
}

@end
