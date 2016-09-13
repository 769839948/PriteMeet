//
//  UIImage+Crop.m
//  Meet
//
//  Created by Zhang on 9/12/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

+ (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height
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
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
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

@end
