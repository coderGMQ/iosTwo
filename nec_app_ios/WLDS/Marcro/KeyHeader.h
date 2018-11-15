
//  KeyHeader.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/11/21.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#ifndef KeyHeader_h
#define KeyHeader_h


//预编译weakSelf
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };  

//// 宏定义之后的用法
//BLOCK_EXEC(completionBlock, arg1, arg2);

//预编译weakSelf
#ifndef WEAKSEL

#define WEAKSELF  typeof(self) __weak weakSelf = self;

#endif



//预编译字典取出数据
#define DICT_QUERY(dict,key) [dict objectForKey:key]


#define kDictString(dict,key) [NSString stringWithFormat:@"%@",[dict objectForKey:key]]

//键盘回收
#define kKeyBoardHiden [[[UIApplication sharedApplication] keyWindow] endEditing:YES]


//获取屏幕宽度与高度
#define kScreenWidth \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

#define kScreenHeight \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

#define kScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)


//判断是否为iPhone X
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//设备导航栏高度
#define NAV_HEIGHT (kDevice_Is_iPhoneX == YES ? 88.0:64.0)

//状态栏高度
#define TOP_HEIGHT (kDevice_Is_iPhoneX == YES ? 44.0:20.0)

//标题栏高度
#define SAFETY_HEIGHT (kDevice_Is_iPhoneX == YES ? 20.0:0)

//安全区高度
#define BAR_HEIGHT (kDevice_Is_iPhoneX == YES ? 83.0:49.0)


#endif /* KeyHeader_h */

