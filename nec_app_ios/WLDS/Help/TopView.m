//
//  TopView.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/9/12.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "TopView.h"

@interface TopView ()

//右侧按钮
@property (nonatomic,strong) UIButton *rightBtn;

//左侧按钮
@property (nonatomic,strong) UIButton *leftBtn;

//标题文本
@property (nonatomic,strong) UILabel *label;


@end

@implementation TopView

/**
 *
 * @ 标题文本懒加载
 *
 **/
- (UILabel *)label{
    
    if (!_label) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - kFitW(150)) / 2, 20, kFitW(150), self.h - 20)];
        _label.font = kTitFont;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
    }
    
    return _label;
}

//标题赋值
- (void)setTitle:(NSString *)title{
    
    if (title.length > 0) {
        
        //标题赋值
        self.label.text = title;
    }
}

//标题颜色赋值
- (void)setColor:(UIColor *)color{
    
    self.label.textColor = color;
}
/**
 *
 * @ 懒加载右侧按钮
 *
 **/
- (UIButton *)rightBtn{
    
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rightBtn.frame = CGRectMake(self.w - 35 - 10,20 + (44 - 35) / 2.0, 35, 35);
        [self addSubview:_rightBtn];
        //添加监听事件
        [_rightBtn addTarget:self action:@selector(rightButton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _rightBtn.backgroundColor = kRedColor;
        
    }
    return _rightBtn;
}

//右侧图片
- (void)setRIM:(UIImage *)rIM{
    
    [self.rightBtn setImage:rIM forState:(UIControlStateNormal)];
}

#pragma mark ========   右侧按钮标题   ========
- (void)setRight:(NSString *)right{
    
    if (right.length > 0) {
        
        //设置标题
        [self.rightBtn setTitle:right forState:(UIControlStateNormal)];
        
        CGFloat width = [right gainWidthWithFont:self.rightBtn.titleLabel.font] + 10;
        
        self.rightBtn.frame = CGRectMake(self.w - width - 10, self.rightBtn.y,width , self.rightBtn.h);
    }
}

#pragma mark ========   右侧按钮点击实现   ========
- (void)rightButton:(UIButton *)button{
    
    if (_delegate != nil) {
        
        //执行代理传值
        [_delegate clickRightView:button];
    }
}
/**
 *
 * @ 懒加载右侧按钮
 *
 **/
- (UIButton *)leftBtn{
    
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_leftBtn];
        _leftBtn.frame = CGRectMake(10,20 + (44 - 35) / 2.0, 35, 35);
        //添加监听事件
        [_leftBtn addTarget:self action:@selector(leftButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBtn;
}

//左侧图片
- (void)setLeIM:(UIImage *)leIM{
    
    [self.leftBtn setImage:leIM forState:(UIControlStateNormal)];
}

#pragma mark ========   右侧按钮标题   ========
- (void)setLeft:(NSString *)left{
    
    if (left.length > 0) {
        
        //设置标题
        [self.leftBtn setTitle:left forState:(UIControlStateNormal)];
        
        self.leftBtn.frame = CGRectMake(self.leftBtn.x, self.leftBtn.y, [left gainWidthWithFont:self.rightBtn.titleLabel.font] + 10, self.leftBtn.h);
    }
}

#pragma mark ========   左侧按钮点击实现   ========
- (void)leftButton:(UIButton *)button{
    
    if (_delegate != nil) {
        
        //执行代理传值
        [_delegate clickLeftView:button];
    }
}

//初始化方法
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        //默认设置frame
        self.frame = CGRectMake(0, 0, kWidth, 64);
        
        //设置背景色
        self.backgroundColor = kMainColor;

    }
    return self;
}
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //设置背景色
        self.backgroundColor = kMainColor;
    }
    
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
