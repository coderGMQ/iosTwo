//
//  UILabel+Adaptive.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/24.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Adaptive)

@property (nonatomic, strong) NSDictionary *data;//这是添加的属性数组

//改变字符创颜色
- (void)changeLabelTextColor:(UIColor *)color string:(NSString *)string other:(NSString *)other;

- (CGFloat)changeWidthForLabelWithFont:(UIFont *)font andText:(NSString *)text;

//调整label的行间距
+ (void)adjustThePositionForLabel:(UILabel *)label withLineSpacing:(CGFloat)spacing;

//获取label文本的字体大小
- (CGFloat)fontSize;

//自适应Label的文本宽度并设置frame
- (void)fitWidthWithX:(CGFloat)x Y:(CGFloat)y font:(UIFont *)font Text: (NSString *)text;

//自适应Label的文本高度并设置frame
- (void)fitHeightWithX:(CGFloat)x Y:(CGFloat)y width:(CGFloat)width font:(UIFont *)font Text: (NSString *)text;

//自适应Label的文本宽度并设置frame
- (void)fitWidthWithText:(NSString *)text;
//自适应Label的文本高度并设置frame
- (void)fitHeightWithText:(NSString *)text;

//获取该文本的宽度
- (CGFloat)gainWidthByText:(NSString *)text;

//在字符串中间画划线
- (void)setLineForString:(NSString *)string other:(NSString *)other;

//根据颜色，字体大小华删除线
- (void)setLineForString:(NSString *)string other:(NSString *)other color:(UIColor *)color font:(UIFont *)font;

//修改中间字符创的颜色颜色
- (void)changeColor:(UIColor *)color prep:(NSString *)prep middle:(NSString *)middle last:(NSString *)last;

//设置文本颜色、字体、文本
- (void)setTitleColor:(UIColor *)color font:(UIFont *)fon title:(NSString *)title;

//运单状态颜色赋值
- (void)waybillStatueColor;

//筛选字符串进行拨打多个电话号码
-(void)distinguishPhoneNum:(NSString *)string filtrate:(BOOL)filtrate;

//本身文本作为电话号码进行拨打电话
- (void)phoneOwnText;

//本身文本作为电话号码进行拨打电话(过滤与否)
- (void)phoneOwnTextFiltrate:(BOOL)filtrate;

@end
