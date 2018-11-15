//
//  QJDragView.h
//  SlideDemo
//
//  Created by 新货郎 on 16/10/13.
//  Copyright © 2016年 新货郎. All rights reserved.
//

#import <UIKit/UIKit.h>


//自定义协议（必须实现的方法）
@protocol QJDragViewDelegate <NSObject>

//触摸结束完成后
- (void)didTouchesEndedValue:(CGFloat)value;

@end


@interface QJDragView : UISlider

/*
 *  @ 百分比系数
 *  @ 取值范围 0 - 1.0
 **/
@property (nonatomic) CGFloat  factor;

//标题颜色
@property (nonatomic,strong) UIFont *font;

//标题
@property (nonatomic,strong) NSString *title;

//标题文本颜色
@property (nonatomic,copy) UIColor *color;

//标题文本背景颜色
@property (nonatomic,copy) UIColor *backColor;

//代理设定
@property (nonatomic)  id<QJDragViewDelegate> delegate;


@end

