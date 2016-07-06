//
//  SetInviteCollectView.m
//  Meet
//
//  Created by Zhang on 7/5/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "SetInviteCollectView.h"
#import "InterestCollectViewCell.h"

@implementation SetInviteCollectView


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCollectViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSLog(@"%@---",self.selectItems[indexPath.row]);
    if ([self.selectItems[indexPath.row] boolValue]) {
        cell.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.isSelect = YES;
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelect];
        cell.titleLabel.textColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
        cell.isSelect = NO;
    }
    cell.titleLabel.frame = CGRectMake(0, 0, [self cellWidth:self.interstArray[indexPath.row]], 27);
//    cell.titleLabel.textColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
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
        cell.isSelect = YES;
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:MeProfileCollectViewItemUnSelect];
        cell.titleLabel.textColor = [UIColor colorWithHexString:MeProfileCollectViewItemSelect];
        cell.isSelect = NO;
    }
}

@end
