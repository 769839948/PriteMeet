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
//    if ([UserInviteModel isFake]) {
//        cell.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelect];
//        cell.titleLabel.textColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
//        cell.isSelect = NO;
//    }else{
    if ([self.selectItems[indexPath.row] isEqualToString:@"true"]) {
        cell.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.isSelect = YES;
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelect];
        cell.titleLabel.textColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelectColor];
        cell.isSelect = NO;
    }
//    }
    
    cell.titleLabel.frame = CGRectMake(7, 0, [self cellWidth:self.interstArray[indexPath.row]], 30);
    cell.layer.cornerRadius = 2.0f;
    [cell filleCellWithFeed:[self.interstArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCollectViewCell *cell = (InterestCollectViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.isSelect) {
        cell.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
        cell.titleLabel.textColor = [UIColor whiteColor];
        [self.selectItems replaceObjectAtIndex:indexPath.row withObject:@"true"];
        cell.isSelect = YES;
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelect];
        cell.titleLabel.textColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelectColor];
        [self.selectItems replaceObjectAtIndex:indexPath.row withObject:@"false"];
        cell.isSelect = NO;
    }
    if (self.selectBlock != nil) {
        self.selectBlock(indexPath.row);
    }
}

@end
