//
//  UIView+frame.h
//  BQLHProject
//
//  Created by xhl on 16/4/13.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

/*
 *  @view      参考布局view
 *  @spacing   设置的间距 （相对于参考布局view的间距）
 *  @scale     变动宽或者高时，变化的比例
 *  @type      设置布局类型
 *    ( type = 0 )   只有y坐标不同  //x坐标以及高度（h）不同
 *    ( type = 1 )   y坐标和高度（h）不同
 *    ( type = 2 )   只有x坐标不同
 *    ( type = 3 )   x坐标和宽度（w）不同
 *    ( type = 4 )   x坐标和宽度（w）不同以及高度（h）不同
 *    ( type = 5 )   x坐标以及高度（h）不同
 *
 */

+ (CGRect)createFrameWithView:(UIView *_Nullable)view withSpacine:(CGFloat)spacing topSpacine:(CGFloat)topSpacing andType:(NSInteger)type widthOrHeight:(CGFloat)widthOrHeight;

+ (CGRect)viewFrameWithView:(UIView *_Nullable)view isHorizontal:(BOOL)isHorizontal withRightSpacine:(CGFloat)rightSpacing topSpacine:(CGFloat)topSpacing andWidth:(CGFloat)width height:(CGFloat)height;

//获取宽度
- (CGFloat)w;
//获取高度
- (CGFloat)h;
//获取x坐标
- (CGFloat)x;
//获取y坐标
- (CGFloat)y;
//获取宽和x坐标的和
- (CGFloat)l;
//获取高和y坐标的和
- (CGFloat)v;
//获取中心点x坐标
- (CGFloat)c_x;
//获取中心点y坐标
- (CGFloat)c_y;

//查看视图存在当前窗口的位置
- (CGRect)locationInWindow;

//查看视图中心点存在当前窗口的位置
- (CGPoint)locationOfCenterInWindow;

//视图剪切
- (void)cropLayer:(CGFloat)radian;

//剪切边框附加颜色
- (void)borderCutWithColor:(UIColor *_Nullable)color width:(CGFloat)width;

//回收键盘
- (void)recycleKeyBoardWithDelegate:(id)delegate;

//横向线
- (void)createLevel;

//竖向线
- (void)createVertical;

//单击手势添加
- (void)clickWithDelegate:(id)delegate target:(id)target action:(nullable SEL)action;

//阴影样式
- (void)shadowStyle;


/**
 *  切任意角
 */
- (void)cornerWithSize:(CGFloat)width;

//- (void)cornerWithType:(NSNumber *)type;

@property(nonatomic, strong) NSNumber* cornerType;

//修改约束
-(void)updateViewConstraints:(NSLayoutAttribute)attribute constant:(CGFloat)constant;


@end
