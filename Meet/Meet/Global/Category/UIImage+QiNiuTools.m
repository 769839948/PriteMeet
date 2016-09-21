//
//  UIImage+QiNiuTools.m
//  Meet
//
//  Created by Zhang on 21/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "UIImage+QiNiuTools.h"
#import <Qiniu/QiniuSDK.h>
#import "sys/utsname.h"

typedef void(^Success)(NSDictionary *successDic);

@implementation UIImage (QiNiuTools)

+ (NSString *)imageWithUrl:(NSString *)url newImage:(CGSize)size
{
    NSDictionary *imageInfo = [UIImage requestWithImageUrl:url];
    NSString *imageStr = [UIImage imageSize:imageInfo newImageSize:size];
    return imageStr;
}

+ (NSDictionary *)requestWithImageUrl:(NSString *)imageUrl
{
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"1924da6a-546f-ee30-2b51-81cda02bc6b9" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageInfo",imageUrl]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:6.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    return [UIImage toArrayOrNSDictionary:responseData];
}


+ (NSString *)imageSize:(NSDictionary *)imageInfo newImageSize:(CGSize)imageSize
{
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    //这里判断原图片的高度和宽度是否比显示图片的宽度高度的比例大小，决定已那一边进行裁剪
    if (imageSize.width / imageSize.height < [[imageInfo objectForKey:@"width"] integerValue]/[[imageInfo objectForKey:@"height"] integerValue]) {
        if (scale_screen * imageSize.height < [[imageInfo objectForKey:@"height"] integerValue]){
            return [NSString stringWithFormat:@"?imageView2/1/w/%d/h/%d",(int)(scale_screen * imageSize.width),(int)(scale_screen * imageSize.height)];
        }else{
            return [NSString stringWithFormat:@"?imageView2/1/w/%d/h/%@",(int)([[imageInfo objectForKey:@"height"] intValue] * imageSize.width / imageSize.height),[imageInfo objectForKey:@"height"]];
        }
    }else{
        if (scale_screen * imageSize.width < [[imageInfo objectForKey:@"width"] integerValue]){
            return [NSString stringWithFormat:@"?imageView2/1/w/%d/h/%d",(int)(scale_screen * imageSize.width),(int)(scale_screen * imageSize.height)];
        }else{
            return [NSString stringWithFormat:@"?imageView2/1/w/%@/h/%d",[imageInfo objectForKey:@"width"],(int)([[imageInfo objectForKey:@"width"] intValue] * imageSize.height / imageSize.width)];
        }
    }
}

// 将JSON串转化为字典或者数组
+ (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

@end
