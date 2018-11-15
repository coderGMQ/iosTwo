//
//  UIViewController+AnimationMake.h
//  TestAnimation
//
//  Created by lanou3g on 15/9/19.
//  Copyright (c) 2015年 QiJiaJia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,AnimationSubType){
    //Left Bottom Right Top
    AnimationSubTypeLeft,//从左边开始
    AnimationSubTypeBottom,//从下边开始
    AnimationSubTypeRight,//从右边开始
    AnimationSubTypeTop,//从上边开始
};

//动画类型枚举
typedef NS_ENUM(NSUInteger, AnimationType) {
    
    AnimationTypeFade = 1,                   //淡入淡出
    
    AnimationTypePush = 2,                       //推挤
    
    AnimationTypeReveal = 3,                     //揭开
    
    AnimationTypeMoveIn = 4,                     //覆盖
    
    AnimationTypeCube = 5,                       //立方体
    
    AnimationTypeSuckEffect = 6,                 //吮吸
    
    AnimationTypeOglFlip = 7,                    //翻转
    
    AnimationTypeRippleEffect = 8,               //波纹
    
    AnimationTypePageCurl = 9,                   //翻页
    
    AnimationTypePageUnCurl = 10,                 //反翻页
    
    AnimationTypeCameraIrisHollowOpen = 11,       //开镜头
    
    AnimationTypeCameraIrisHollowClose = 12,      //关镜头
    
    AnimationTypeCurlDown = 13,                   //下翻页
    
    AnimationTypeCurlUp = 14,                     //上翻页
    
    AnimationTypeFlipFromLeft = 15,               //左翻转
    
    AnimationTypeFlipFromRight = 16,              //右翻转
    
} ;

@interface UIViewController (AnimationMake)


@property(nonatomic, strong) UIView *emptyView;

//视图控制器调用该方法
- (void)setAnimationWithSubtype:(AnimationSubType)subtype andAnimationType:(AnimationType)animationType animateWithDuration:(CGFloat)duration;


//导航栏添加自定义标题
- (void)giveColor:(UIColor *)color andFontSize:(CGFloat)fontSize forNavigationItemTitle:(NSString *)title;

//模态跳转加导航控制器
- (void)modalPresentToVC:(UIViewController *)controller;

//导航控制器跳转
- (void)pushToVC:(UIViewController *)controller;

//为导航控制器加标题及夜色
- (void)setFont:(UIFont *)font color:(UIColor *)color title:(NSString *)title;

//正在建设中
- (void)buildindNow;

#pragma mark ========   提示框   ========
- (void)waringShow:(NSString *)msg;

#pragma mark ========   提示框   ========
- (void)waringShow:(NSString *)msg over:(void (^)(BOOL response))over;

//根据总数以及单页数量，计算所需分页总数
- (NSInteger)allRowsWithTotal:(NSInteger)total  count:( NSInteger)count;

//返货指定页
- (void)backToViewController:(Class)vc;

//去登录页面
- (void)toLogin:(void (^)(BOOL response))back;

//去登录页面(取消回调)
- (void)toLogin:(void (^)(BOOL response))back cancel:(void (^)(BOOL response))cancel;

//监听键盘
- (void)monitorFromKeyboard;

@end
