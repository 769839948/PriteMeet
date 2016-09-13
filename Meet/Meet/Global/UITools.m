//
//  UITools.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/19.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "UITools.h"
#import "MBProgressHUD.h"
#import "NSString+StringSize.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#define IOS_9LAST ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0)?1:0
#define CustomViewWidth 190
#define CustomViewFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Medium" size:14.0f]:[UIFont systemFontOfSize:14]
#define TextLabelMarger 20
@interface HUDCustomView : UIView

+ (id)customViewWidthMessage:(NSString *)message;

@end

@implementation HUDCustomView

+ (id)customViewWidthMessage:(NSString *)message
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width - CustomViewWidth) / 2, ([[UIScreen mainScreen] bounds].size.height - 60) / 2, CustomViewWidth, 60)];

    CGFloat messageHeight = [message heightWithFont:CustomViewFont constrainedToWidth:CustomViewWidth - TextLabelMarger * 2];
    CGRect frame = customView.frame;
    if (messageHeight > 60) {
        frame.size.height = messageHeight;
        frame.origin.y = ([[UIScreen mainScreen] bounds].size.height - messageHeight) / 2;
    }else{
        frame.size.height = 60;
    }
    customView.frame = frame;
    customView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [customView addSubview:[HUDCustomView setUpLabel:frame text:message]];
    return customView;
}

+ (UILabel *)setUpLabel:(CGRect)frame text:(NSString *)text
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CustomViewWidth - TextLabelMarger * 2, frame.size.height)];
    textLabel.font = CustomViewFont;
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = text;
    return textLabel;
}

@end


@implementation UITools

static UITools *tools = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [UITools new];
    });
    return tools;
}

+ (void)customNavigationBackButtonAndTitle:(NSString *)title forController:(UIViewController *)controller{
    controller.navigationItem.title = title;
    controller.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    controller.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

+ (void)customNavigationLeftBarButtonForController:(UIViewController *)controller action:(SEL)select {
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbutton_back"] style:UIBarButtonItemStylePlain target:controller action:select];
    item.tintColor = [UIColor whiteColor];
    controller.navigationItem.leftBarButtonItem = item;
}

- (void)customNavigationLeftBarButtonForController:(UIViewController *)controller {
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbutton_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    controller.navigationItem.leftBarButtonItem = item;
}

+ (void)customNavigationBackButtonForController:(UIViewController *)controller action:(SEL)select normalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:controller action:select forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectImage forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 40, 40);
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain target:controller action:select];
//    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (void)navigationRightBarButtonForController:(UIViewController *)controller action:(SEL)select normalTitle:(NSString *)normal selectedTitle:(NSString *)selected
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:controller action:select forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:normal forState:UIControlStateNormal];
    [button setTitle:selected forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 40, 40);
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (void)navigationRightBarButtonForController:(UIViewController *)controller action:(SEL)select normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:controller action:select forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 40, 40);
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)popViewController:(UIBarButtonItem *)item{
//    [[SHARE_APPDELEGATE getCurrentNavigationController] popViewControllerAnimated:YES];
}

//- (void)showMessageToView:(UIView *)view message:(NSString *)message {
//    [self showMessageToView:view message:message autoHide:YES];
//}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHideTime:(NSTimeInterval )interval {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [HUDCustomView customViewWidthMessage:message];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:interval];
    return hud;
}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = CustomViewFont;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    if (autoHide) {
        [hud hideAnimated:YES afterDelay:1.0f];

    }
    return hud;
}

+ (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = CustomViewFont;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    if (autoHide) {
        [hud hideAnimated:YES afterDelay:1.0f];
    }
    return hud;
}

- (MBProgressHUD *)showLoadingViewAddToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
     hud.label.text = message;
    
    if (autoHide) {
        [hud hideAnimated:YES afterDelay:1.5f];
    }
    return hud;
}

- (MBProgressHUD *)showLoadingViewAddToView:(UIView *)view autoHide:(BOOL)autoHide {
    
    MBProgressHUD *hud = [[UITools shareInstance] showLoadingViewAddToView:view message:nil autoHide:autoHide];
    return hud;
}

//获取自适应字的高度？？？
+ (float)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt {
    float fPadding = 16.0;
    //    CGSize constraint = CGSizeMake(txtView.contentSize.width - 10 - fPadding, CGFLOAT_MAX);
    //    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:0];
    //    float fHeight = size.height + 16.0;
    //    return fHeight;
    
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGSize size = [txt boundingRectWithSize:CGSizeMake(txtView.contentSize.width -  10 - fPadding, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dic
                                    context:nil].size;/////自适应高度
    return size.height;
}

+ (CGFloat)getTextWidth:(UIFont *)font textContent:(NSString *)text {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    return size.width + text.length *2;
}

+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
     // Create a graphics image context
     UIGraphicsBeginImageContext(newSize);
     // Tell the old image to draw in this new context, with the desired
     // new size
     [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
     // Get the new image from the context
     UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     // End the context
     UIGraphicsEndImageContext();// Return the new image.
     return newImage;
 }

- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

@end
