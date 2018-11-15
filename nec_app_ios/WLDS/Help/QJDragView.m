//
//  QJDragView.m
//  SlideDemo
//
//  Created by 新货郎 on 16/10/13.
//  Copyright © 2016年 新货郎. All rights reserved.
//

#import "QJDragView.h"

@interface QJDragView ()

//标题
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation QJDragView

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //默认回弹系数为0.5
        self.factor = 0.50;
        
        //设置默认最小值
        self.minimumValue = 0.00;
        
        //设置默认最大值
        self.maximumValue = 1.00;

    }
    
    return self;
}

#pragma mark ========   标题文本   ========
/*
 *
 * @ 懒加载标题文本
 *
 **/
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        //穿件文本
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height / 2.0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.masksToBounds = YES;
//        _titleLabel.layer.cornerRadius = _titleLabel.frame.size.height / 2.0;
        _titleLabel.layer.cornerRadius = _titleLabel.frame.size.height * 0.15;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

//设置文本字体
- (void)setFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

//设置标题
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

//标题文本颜色
- (void)setColor:(UIColor *)color
{
    self.titleLabel.textColor = color;
}

//标题文本背景颜色
- (void)setBackColor:(UIColor *)backColor
{
    self.titleLabel.backgroundColor = backColor;
}

#pragma mark ========   重写父类方法【进度条高度及滑块大小】   ========
//调整高度
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    // 必须通过调用父类的trackRectForBounds获取一个bounds值，否则Autolayout会失效，UISlider的位置会跑偏。
//    bounds =
    [super trackRectForBounds:bounds];
    
    // 这里面的h即为你想要设置的高度。
    return CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
}

//调整圆形滑块
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    
//    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value];
//    
//    return CGRectInset ([super thumbRectForBounds:CGRectMake(bounds.origin.x, bounds.origin.y, self.frame.size.height * 2, self.frame.size.height * 2) trackRect:rect value:value],0 ,0);
//    
//}

////调整圆形滑块
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    rect.origin.x = rect.origin.x + self.frame.size.height/2.0;
//    
//    rect.size.width = rect.size.width - self.frame.size.height/2;
//    
//    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], -self.frame.size.height/2.0 ,0);
//}

#pragma mark ========   触摸事件【代理传值】   ========
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //判断值范围【起到回弹效果】
    if (self.value > self.factor * self.maximumValue) {
        
        self.value = self.maximumValue;
    }else
    {
        self.value = self.minimumValue;
    }
    
    if (self.delegate != nil) {
        
        [self.delegate didTouchesEndedValue:self.value];
    }
}


@end
