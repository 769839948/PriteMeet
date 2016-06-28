//
//  Theme.h
//  Meet
//
//  Created by Zhang on 5/30/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#ifndef Theme_h
#define Theme_h

#pragma mark - 软件的主题颜色
#pragma mark - appThemeCustomColor
#define NavigationBarTintColorCustome  [UIColor whiteColor]
#define NavigationBarTitleColorCustome  [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]
#define OtherBlackFontColor [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]

#define TableViewBackGroundColor @"#FBFBFB"

#define HomeViewNameColor [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]
#define HomeViewPositionColor [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]

#define HomeViewNameFont               [UIFont fontWithName:@"PingFangSC-Regular" size:22.0f]
#define HomeViewPositionFont           [UIFont fontWithName:@"PingFangSC-Thin" size:22.0f]
#define HomeViewWomenColor       @"FF4F4F"
#define HomeViewManColor         @"009FE8"
#define HomeViewAgeFont          [UIFont fontWithName:@"PingFangSC-Semibold" size:10.0]
#define HomeMeetNumberFont           [UIFont fontWithName:@"Helvetica-Light" size:12]
#define HomeMeetNumberColor      @"C9C9C9"

#define HomeDetailViewNameColor        @"202020"
#define HomeDetailViewPositionColor    @"999999"
#define HomeDetailViewMeetNumberColor  @"C9C9C9"
#define HomeViewDetailAboutBtnColor    @"FFFFFF"

#define HomeViewDetailNameFont         [UIFont fontWithName:@"PingFangSC-Regular" size:28.0f]
#define HomeViewDetailPositionFont     [UIFont fontWithName:@"PingFangSC-Light" size:22.0f]
#define HomeViewDetailMeetNumberFont   [UIFont fontWithName:@"PingFangSC-Light" size:12.0f]
#define HomeViewDetailAboutBtnFont     [UIFont fontWithName:@"PingFangSC-Regular" size:10.0f]

#define PlaceholderImage                [UIImage imageWithColor:[UIColor colorWithHexString:@"e7e7e7"] size:CGSizeZero]

#define MeetSectionTitleNameFont [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f]
#define MeetSectionTitleNameColot [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]

#define MeViewProfileLabelFont          [UIFont fontWithName:@"PingFangSC-Light" size:14.0f]
#define MeViewProfileTitleLabelColor         @"202020"
#define MeViewProfileContentLabelColor         @"7F7F7F"


#define MeetDetailLineColor [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]
#define lineLabelBackgroundColor @"E7E7E7"
#define MeInvateFriendsColor     @"FC5154"



#define AboutUsLabelFont [UIFont fontWithName:@"PingFangTC-Light" size:14.0]
#define AboutUsLabelColor @"4D4D4D"

#define SettingViewLabelFont [UIFont fontWithName:@"PingFangTC-Light" size:14.0]


#define TableViewTextColor @"202020"

#define IQKeyboardManagerTinColor @"202020"
#define IQKeyboardManagerplaceholderFont [UIFont fontWithName:@"PingFangSC-Regular" size:14.0]
#define IQKeyboardManagerFont [UIFont fontWithName:@"PingFangSC-Light" size:14.0]

#define EMAlertViewCancelTitle  @"取消"

#define EMAlertViewConfirmTitle  @"朕知道了"
//IQKeyboardManager Color
////Tint color
//[[self appearance] setTintColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]];
//
////Title
////    [[self appearance] setTitleFont:[UIFont fontWithName:@"PingFangSC-Light" size:14.0]];
//
//[[self appearance] setTitlePositionAdjustment:UIOffsetZero forBarMetrics:UIBarMetricsDefault];
//[[self appearance] setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"PingFangSC-Light" size:14.0]} forState:UIControlStateNormal];
//
#endif /* Theme_h */
