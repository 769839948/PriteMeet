//
//  UIImage+Crop.m
//  Meet
//
//  Created by Zhang on 9/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

+ (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height originX:(CGFloat)originX originY:(CGFloat)originY
{
    CGSize newSize = CGSizeMake(width, height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(originX,originY,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)imageByCroppingWithStyle:(XYCropImageStyle)style
{
    CGRect rect;
    switch(style){
        caseXYCropImageStyleLeft:
            rect=CGRectMake(0,0,self.size.width/2,self.size.height);
            break;
        caseXYCropImageStyleCenter:
            rect=CGRectMake(self.size.width/4,0,self.size.width/2,self.size.height);
            break;
        caseXYCropImageStyleRight:
            rect=CGRectMake(self.size.width/2,0,self.size.width/2,self.size.height);
            break;
        caseXYCropImageStyleLeftOneOfThird:
            rect=CGRectMake(0,0,self.size.width/3,self.size.height);
            break;
        caseXYCropImageStyleCenterOneOfThird:
            rect=CGRectMake(self.size.width/3,0,self.size.width/3,self.size.height);
            break;
        caseXYCropImageStyleRightOneOfThird:
            rect=CGRectMake(self.size.width/3*2,0,self.size.width/3,self.size.height);
            break;
        caseXYCropImageStyleLeftQuarter:
            rect=CGRectMake(0,0,self.size.width/4,self.size.height);
            break;
        caseXYCropImageStyleCenterLeftQuarter:
            rect=CGRectMake(self.size.width/4,0,self.size.width/4,self.size.height);
            break;
        caseXYCropImageStyleCenterRightQuarter:
            rect=CGRectMake(self.size.width/4*2,0,self.size.width/4,self.size.height);
            break;
        caseXYCropImageStyleRightQuarter:
            rect=CGRectMake(self.size.width/4*3,0,self.size.width/4,self.size.height);
            break;
        default:
            break;
    }
    CGImageRef imageRef = self.CGImage;
    CGImageRef imagePartRef=CGImageCreateWithImageInRect(imageRef,rect);
    UIImage*cropImage=[UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return cropImage;
}


//图片裁剪
+ (UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect
{
    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
     //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
         CGImageRef imageRef = superImage.CGImage;
         CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
         UIGraphicsBeginImageContext(subImageSize);
         CGContextRef context = UIGraphicsGetCurrentContext();
         CGContextDrawImage(context, subImageRect, subImageRef);
         UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
         UIGraphicsEndImageContext(); //返回裁剪的部分图像
         return returnImage;
}

+ (UIImage *)imageCompressWithSimple:(UIImage *)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//截取部分图像
- (UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGFloat scale = MAX(self.scale, 1.0f);
    CGRect scaledBounds = CGRectMake(bounds.origin.x * scale, bounds.origin.y * scale, bounds.size.width * scale, bounds.size.height * scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], scaledBounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
//- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
//          transparentBorder:(NSUInteger)borderSize
//               cornerRadius:(NSUInteger)cornerRadius
//       interpolationQuality:(CGInterpolationQuality)quality {
//    
//    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
//                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
//                                         interpolationQuality:quality];
//    
//    
//    // Crop out any part of the image that's larger than the thumbnail size
//    // The cropped rect must be centered on the resized image
//    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
//    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
//                                 round((resizedImage.size.height - thumbnailSize) / 2),
//                                 thumbnailSize,
//                                 thumbnailSize);
//    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
//    
//    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
//    
//    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
//}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    switch ( self.imageOrientation )
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
        default:
            drawTransposed = NO;
    }
    
    CGAffineTransform transform = [self transformForOrientation:newSize];
    
    return [self resizedImage:newSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat scale = MAX(1.0f, self.scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width*scale, newSize.height*scale));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Fix for a colorspace / transparency issue that affects some types of
    // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8, /* bits per channel */
                                                (newRect.size.width * 4), /* 4 channels per pixel * numPixels/row */
                                                colorSpace,
                                                kCGImageAlphaPremultipliedLast
                                                );
    CGColorSpaceRelease(colorSpace);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:UIImageOrientationUp];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

@end
