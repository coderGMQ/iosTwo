//
//  AppHeader.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/11/21.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#ifndef AppHeader_h
#define AppHeader_h


//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kWidth [UIScreen mainScreen].bounds.size.width // 屏幕的宽
#define kHeight [UIScreen mainScreen].bounds.size.height // 屏幕的高


// ==== 角度和弧度互换 =========
#define KRADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define KDEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)


//以640 * 960的像素尺寸为设计基础
#define kFitW(width) ((width) * kWidth/320.0)
#define kFitH(height) ((height) * kHeight/480.0)


// frame设置
//#define kFitWidth (kWidth/320.0)
//#define kFitHeight (kHeight/667.0)

#define kBounds CGRectMake(0, 0, kWidth, kHeight) // 与屏幕相等的frame
#define kNavigationBounds CGRectMake(0, NAV_HEIGHT, kWidth, kHeight - NAV_HEIGHT - 49) // 出去
#define kScreenBounds  [UIScreen mainScreen].bounds // 屏幕的bounds


//自定义窗口颜色
#define kWindowColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

// 颜色设置
#define kWhiteColor     [UIColor whiteColor]
#define kClearColor     [UIColor clearColor] // 清晰色
#define kRedColor       [UIColor redColor]
#define kBlackColor     [UIColor blackColor]
#define kDarkGrayColor  [UIColor darkGrayColor] //深灰；暗灰；灰黑
#define kLightGrayColor [UIColor lightGrayColor] // 浅灰色
#define kGrayColor      [UIColor grayColor]  // 灰色
#define kGreenColor     [UIColor greenColor]
#define kBlueColor      [UIColor blueColor]
#define kCyanColor      [UIColor cyanColor]  //. 蓝绿色
#define kYellowColor    [UIColor yellowColor]
#define kMagentaColor   [UIColor magentaColor]  //品红；洋红
#define kOrangeColor    [UIColor orangeColor]
#define kPurpleColor    [UIColor purpleColor] //紫色
#define kBrownColor     [UIColor brownColor]
#define kRandomColor    [UIColor colorWithRed:arc4random() % 256/255.0 green:arc4random() % 256/255.0 blue:arc4random() % 256/255.0 alpha:1]

#define kLikeColor [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1]
#define kLikeRedColor [UIColor colorWithRed:0.99 green:0.55 blue:0.14 alpha:1]//黄


//主题色
#define kMainColor [UIColor colorWithHex:(0x007FDE)]

//辅色
#define kAssistColor [UIColor colorWithHex:(0x4be2e5)]

//导航栏统一颜色
#define KNANBC [UIColor colorWithHex:(0x007FDE)]

//主要黑色文本颜色 202019 0x444444
#define  KTEXT_COLOR [UIColor colorWithHex:(0x202019)]



//鸭黄色  fd7a05
#define LIGHT_YELLOW [UIColor colorWithHex:(0xffcc66)]

//设置RGB颜色
#define kHexColor(color) [UIColor colorWithHex:(color)]

//设置RGB颜色

#define kRGBA(r, g, b,c) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(c)]


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//导航条标题的颜色
#define kTitleColor  [UIColor whiteColor]
#define kTitFont [UIFont fontWithName:kThickFont size:18.0]


//控制器背景统一颜色
#define kViewBackgroundColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]


// 字体名称 ArialRoundedMTBold   STXingkai
#define kThickFont @"ArialRoundedMTBold"
#define kSlantFont @"Georgia-Italic"
#define KFontSize10 [UIFont fontWithName:kThickFont size:10.0]
#define KFontSize11 [UIFont fontWithName:kThickFont size:11.0]
#define KFontSize12 [UIFont fontWithName:kThickFont size:12.0]
#define KFontSize13 [UIFont fontWithName:kThickFont size:13.0]
#define KFontSize14 [UIFont fontWithName:kThickFont size:14.0]
#define KFontSize15 [UIFont fontWithName:kThickFont size:15.0]
#define KFontSize16 [UIFont fontWithName:kThickFont size:16.0]
#define KFontSize17 [UIFont fontWithName:kThickFont size:17.0]
#define KFontSize18 [UIFont fontWithName:kThickFont size:18.0]
#define KFontSize20 [UIFont fontWithName:kThickFont size:20.0]
#define KFontSize22 [UIFont fontWithName:kThickFont size:22.0]
#define KFontSize24 [UIFont fontWithName:kThickFont size:24.0]

#define kFontSize(si) [UIFont systemFontOfSize:(si)/1.00 ]

//加粗字体
//#define KFontBold(size) [UIFont fontWithName:@"Helvetica-Bold" size:((CGFloat)size)]

#define kFontBold(s) [UIFont fontWithName:@"Helvetica-Bold" size:(s)/1.00 ]

#define STRING_ISNIL(__POINTER) (__POINTER == NULL || [__POINTER isKindOfClass:[NSNull class]] || [__POINTER isEqual:[NSNull null]] ||__POINTER == nil || [__POINTER isEqualToString:@""] || [__POINTER isEqualToString:@"(null)"] || [__POINTER isEqualToString:@"null"] || [__POINTER isEqualToString:@"(NULL)"] || [__POINTER isEqualToString:@"NULL"] || [__POINTER isEqualToString:@"<null>"])?YES:NO

/* 系统版本 */
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/* 判定字符串是否为空 */
#define STRING_ISNIL(__POINTER) (__POINTER == NULL || [__POINTER isKindOfClass:[NSNull class]] || [__POINTER isEqual:[NSNull null]] ||__POINTER == nil || [__POINTER isEqualToString:@""] || [__POINTER isEqualToString:@"(null)"] || [__POINTER isEqualToString:@"null"] || [__POINTER isEqualToString:@"(NULL)"] || [__POINTER isEqualToString:@"NULL"] || [__POINTER isEqualToString:@"<null>"])?YES:NO


////枚举范例
//typedef enum : NSUInteger {
//    XLMusicDeleteFromTypeDownLoad =0,
//    XLMusicDeleteFromTypeLoved = 1,
//    XLMusicDeleteFromTypeNoeTime = 2,
//    XLMusicDeleteFromTypeOwnPath = 3,
//} XLMusicDeleteFromType;


//取随机数
#define kRandom(a,b) arc4random()%((b) - (a) + 1) +(a)


#import "UIImageView+WebCache.h"

//图片缓存路径
#define kSDWebImageDirectories [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/com.hackemist.SDWebImageCache.default"]



#endif /* AppHeader_h */
