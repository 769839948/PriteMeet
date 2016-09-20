//
//  PhotosAlbumViewController.h
//  Meet
//
//  Created by Zhang on 20/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "TZImagePickerController.h"

typedef void  (^ImagePickerSelectImage)(UIImage *image);


@interface PhotosAlbumViewController : TZImagePickerController

@property (nonatomic, strong) ImagePickerSelectImage block;


@end

typedef void  (^AlbumCollectionViewImage)(UIImage *image);

@interface PhotosAlbumCollectionView : TZAlbumPickerController

@property (nonatomic, strong) AlbumCollectionViewImage block;

@end
