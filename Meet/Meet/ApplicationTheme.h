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
#define NavigationBarTintColorCustome  @"202020"
#define NavigationBarTitleColorCustome  @"202020"
#define NavigationBarTintDisColorCustom  @"E7E7E7"

#define OtherBlackFontColor [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]

#define HomeCellBackShowdownColor [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]

#define TableViewBackGroundColor @"#F6F6F6"

#define HomeTableViewBackGroundColor  @"#FBFBFB"

#define HomeViewNameColor [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]
#define HomeViewPositionColor [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]

#define IOS_9LAST ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0)?1:0


#define HomeViewNameFont             (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Regular" size:22.0f]:[UIFont systemFontOfSize:22]

#define AboutJobLabelTextFont             (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:12.0f]:[UIFont systemFontOfSize:12]

#define AllInfoLabelFont             (IOS_9LAST)?[UIFont fontWithName:@"PingFangTC-Light" size:14.0]:[UIFont systemFontOfSize:14]

#define InterestCollectItemFont             (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:13.0f]:[UIFont systemFontOfSize:13]


#define HomeViewPositionFont           (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Thin" size:22.0f]:[UIFont systemFontOfSize:22]
#define HomeViewAgeFont          (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Semibold" size:10.0f]:[UIFont systemFontOfSize:10]
#define HomeMeetNumberFont           (IOS_9LAST)?[UIFont fontWithName:@"Helvetica-Light" size:12.0f]:[UIFont systemFontOfSize:12]

#define HomeViewDetailNameFont         (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Regular" size:28.0f]:[UIFont systemFontOfSize:28]
#define HomeViewDetailPositionFont     (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Thin" size:22.0f]:[UIFont systemFontOfSize:22]
#define HomeViewDetailMeetNumberFont   (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:12.0f]:[UIFont systemFontOfSize:12]
#define HomeViewDetailAboutBtnFont     (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Regular" size:10.0f]:[UIFont systemFontOfSize:10]
#define ImagePickerFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:18.0]:[UIFont systemFontOfSize:18]

#define NavigationBarTitleFont          (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:18.0f]:[UIFont systemFontOfSize:18]
#define NavigationBarRightItemFont     (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:16.0f]:[UIFont systemFontOfSize:16]

#define MeetSectionTitleNameFont      (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Regular" size:14.0f]:[UIFont systemFontOfSize:14]

#define MeViewProfileLabelFont          (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:14.0f]:[UIFont systemFontOfSize:14]

#define AboutUsLabelFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Thin" size:14.0f]:[UIFont systemFontOfSize:14]


#define HomeDetailAboutUsTitleLabelFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Medium" size:19.0f]:[UIFont systemFontOfSize:19]

#define HomeDetailAboutUsLabelFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Thin" size:14.0f]:[UIFont systemFontOfSize:14]


#define SettingViewLabelFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:14.0f]:[UIFont systemFontOfSize:14]

#define ReportViewCellFont   (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:14.0f]:[UIFont systemFontOfSize:14]

#define IQKeyboardManagerplaceholderFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Regular" size:14.0f]:[UIFont systemFontOfSize:14]

#define IQKeyboardManagerFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:14.0f]:[UIFont systemFontOfSize:14]

#define KeyBoardToobarTitleFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:14.0f]:[UIFont systemFontOfSize:14]

#define ImagePickerVCOKButtonFont (IOS_9LAST)?[UIFont fontWithName:@"PingFangSC-Light" size:16.0f]:[UIFont systemFontOfSize:16]


#define HomeViewWomenColor       @"FF8161"
#define HomeViewManColor         @"4ED6C4"

#define HomeMeetNumberColor      @"C9C9C9"

#define AboutUsCellTitleColor    @"4D4D4D"

#define HomeDetailViewNameColor        @"202020"
#define HomeDetailViewPositionColor    @"999999"
#define HomeDetailViewMeetNumberColor  @"C9C9C9"
#define HomeViewDetailAboutBtnColor    @"FFFFFF"

#define CancelInfoBackGroundColor      @"4ED6C4"

#define AppointMentBackGroundColor    @"FB9158"


#define AppointMentBeginBackGroundColor    @"FB9754"
#define AppointMentEndBackGroundColor      @"FF8160"

#define EmptyDataColor           @"C9C9C9"

#define HomeViewDetailMeetButtonBack   @"FF8161"
#define HomeViewDetailMeetButtonHightBack   @"FB9854"


#define PlaceholderImage                [UIImage imageWithColor:[UIColor colorWithHexString:@"e7e7e7"] size:CGSizeZero]

#define PlaceholderImageColor          @"E7E7E7"

#define MeetSectionTitleNameColot [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]

#define MeViewProfileTitleLabelColor         @"202020"
#define MeViewProfileContentLabelColor       @"7F7F7F"
#define MeViewProfileContentLabelColorLight  @"E7E7E7"

#define EmptyDataTitleColor                  @"C9C9C9"

#define PlaceholderTextViewColor             @"C9C9C9"


#define MeViewProfileBackGroundColor         @"F2F2F2"

#define MeetDetailLineColor [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]

#define lineLabelBackgroundColor @"E7E7E7"
#define MeInvateFriendsColor     @"FC5154"

#define MeProfileCollectViewItemSelect     @"FF8161"
#define MeProfileCollectViewItemUnSelect   @"F6F6F6"
#define MeProfileCollectViewItemUnSelectColor @"7F7F7F"

#define OrderFlowTitleCnacel               @"4ED6C4"


#define AboutUsLabelColor @"4D4D4D"

#define OrderTipsLabelColor @"4D4D4D"

#define OrderApplyMeetTitleColor  @"C9C9C9"
#define OrderBaseCancelBtnColor   @"C8C8C8"

#define TableViewTextColor @"202020"

#define IQKeyboardManagerTinColor @"202020"

#define ApplyCodeFont [UIFont systemFontOfSize:18.0]
#define ApplyCodeNextBtnColorDis       @"E7E7E7"
#define ApplyCodeNextBtnColorEn        @"202020"

#define EMAlertViewCancelTitle  @"取消"

#define EMAlertViewConfirmTitle  @"朕知道了"


#define HomeDetailMoreInfoImageSize ScreenWidth > 375.0 ? @"?imageView2/1/w/177/h/177":@"?imageView2/1/w/118/h/118"
#define HomeCoverImageSize ScreenWidth > 375.0 ? @"?imageView2/1/w/1065/h/600":@"?imageView2/1/w/710/h/400"

#define ImageThum ScreenWidth > 375.0 ? @"?imageView2/1/w/177/h/177":@"?imageView2/1/w/118/h/118"




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
