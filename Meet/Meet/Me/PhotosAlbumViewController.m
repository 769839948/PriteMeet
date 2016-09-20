//
//  PhotosAlbumViewController.m
//  Meet
//
//  Created by Zhang on 20/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "PhotosAlbumViewController.h"
#import "Meet-Swift.h"

@interface PhotosAlbumViewController ()

@end

@implementation PhotosAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)delegate {
    PhotosAlbumCollectionView *_albumPickerVc = [[PhotosAlbumCollectionView alloc] init];
    _albumPickerVc.block = ^(UIImage *image){
        if (self.block != nil) {
            self.block(image);
        }
    };
    self = [super initWithRootViewController:_albumPickerVc];
    if (self) {
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9; // Default is 9 / 默认最大可选9张图片
        self.pickerDelegate = delegate;
        self.selectedModels = [NSMutableArray array];
        
        // Allow user picking original photo and video, you also can set No after this method
        // 默认准许用户选择原图和视频, 你也可以在这个方法后置为NO
        self.allowPickingOriginalPhoto = YES;
        self.allowPickingVideo = YES;
        self.allowPickingImage = YES;
        self.allowTakePicture = YES;
        self.timeout = 15;
        self.photoWidth = 828.0;
        self.photoPreviewMaxWidth = 600;
        self.sortAscendingByModificationDate = YES;
        self.autoDismiss = YES;
        self.barItemTextFont = [UIFont systemFontOfSize:15];
        self.barItemTextColor = [UIColor whiteColor];
        [self initImageAlbum];
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

@interface PhotosAlbumCollectionView()<FusumaDelegate>

@end

@implementation PhotosAlbumCollectionView

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FusumaViewController *fusuma = [[FusumaViewController alloc] init];
    fusuma.delegate = self;
    TZAlbumModel *model = [self.albumArr objectAtIndex:indexPath.row];
    fusuma.images = model.result;
    [self.navigationController pushViewController:fusuma animated:YES];
}


- (void)fusumaImageSelected:(UIImage * _Nonnull)image
{
    if (self.block != nil) {
        self.block(image);
    }
}

- (void)fusumaDismissedWithImage:(UIImage * _Nonnull)image
{
    
}

- (void)fusumaVideoCompletedWithFileURL:(NSURL * _Nonnull)fileURL
{
    
}

- (void)fusumaCameraRollUnauthorized
{
    
}


- (void)fusumaClosed
{
    
}

@end
