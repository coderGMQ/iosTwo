//
//  UIButton+Adaptive.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/24.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (Adaptive)

//button文本自适应宽度
+ (CGRect)returnWidthForButton:(UIButton *)button fromLeft:(CGFloat)left andRight:(CGFloat)right;

//button设置文本及颜色大小（正常状态）
- (void)giveTitileColor:(UIColor *)color withFont:(UIFont *)font andTitile:(NSString *)titile;

//修剪button的边角（个颜色时有默认的边角宽度）
- (void)cutButtonWithDenom:(NSInteger)denom andColor:(UIColor *)color;


//获取赋值及设置字体大小后的button的宽度
- (CGFloat)getButtonWidth;

//设置正常和高亮状态下的图片
- (void)setNormal:(UIImage *)image;

//设置正常和高亮状态下的图片
- (void)setImageNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;

//设置正常和高亮状态下的背景图片
- (void)setBackgroundImageNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;

//根据颜色设置正常和高亮状态下的背景图片
- (void)setBackgroundNormal:(UIColor *)normal highlighted:(UIColor *)highlighted;


//设置正常和高亮状态下的标题
- (void)setNormal:(UIColor *)normal highlighted:(UIColor *)highlighted title:(NSString *)title;

//设置正常和高亮状态下的标题
- (void)setTwoStateTitle:(NSString *)title;

//设置正常和高亮状态下的标题亚瑟
- (void)setHighlighted:(UIColor *)highlighted normal:(UIColor *)normal;

//修改选中
- (void)changeButtonStatue:(NSArray *)array view:(UIView *)view;


@end
