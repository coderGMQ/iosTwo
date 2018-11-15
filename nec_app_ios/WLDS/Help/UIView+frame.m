
//
//  UIView+frame.m
//  BQLHProject
//
//  Created by xhl on 16/4/13.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "UIView+frame.h"


@implementation UIView (frame)

//单击手势添加
- (void)clickWithDelegate:(id)delegate target:(id)target action:(nullable SEL)action{
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    
    //判断是否存在代理设置
    if (delegate) {
        
        tap.delegate = delegate;
    }

    //判断是否打开了交互
    if (self.userInteractionEnabled == NO) {
        
        self.userInteractionEnabled = YES;
    }
    
    [self addGestureRecognizer:tap];
    
}

+ (CGRect)createFrameWithView:(UIView *)view withSpacine:(CGFloat)spacing topSpacine:(CGFloat)topSpacing andType:(NSInteger)type widthOrHeight:(CGFloat)widthOrHeight{
    
    CGRect  rect;
    
    CGFloat x = view.frame.origin.x;
    
    CGFloat y = view.frame.origin.y;
    
    CGFloat w = view.frame.size.width;
    
    CGFloat h = view.frame.size.height;
    /*
     *
     *  ( type = 0 )  只有y坐标不同
     *  ( type = 1 )  y坐标和高度（h）不同
     *  ( type = 2 )  只有x坐标不同
     *  ( type = 3 )  x坐标和宽度（w）不同
     *  ( type = 4 )  x坐标和宽度（w）不同以及高度（h）不同
     *
     */
    switch (type) {
        case 0:
        {//只有y坐标不同
            rect = CGRectMake(x, y + h + topSpacing, w, h);
            
        }
            break;
        case 1:
        {//y坐标和高度（h）不同 高度不同（widthOrHeight）
            rect = CGRectMake(x, y + h + topSpacing, w,widthOrHeight);
            
        }
            break;
        case 2:
        {//只有x坐标不同
            if (x + w + spacing > kWidth/2) {
                
                rect = CGRectMake(x + w + spacing, y,kWidth - (x + w + spacing), h);
                
            }else
            {
              rect = CGRectMake(x + w + spacing, y, w, h);
            }
            
        }
            break;
        case 3:
        {//x坐标和宽度（w）不同
            rect = CGRectMake(x + w + spacing, y, kWidth - (2 * x + w + spacing), h);
            
        }
            break;
        case 4:
        {//x坐标和宽度（w）不同以及高度（h）不同
            rect = CGRectMake(x + w + spacing, y, kWidth - (2 * x + w + spacing),widthOrHeight);
            
        }
            break;
            
        case 5:
        {//x坐标以及高度（h）不同
            rect = CGRectMake(spacing,y + h + topSpacing, kWidth - 2 * spacing,widthOrHeight);
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    return rect;
    
}


+ (CGRect)viewFrameWithView:(UIView *)view isHorizontal:(BOOL)isHorizontal withRightSpacine:(CGFloat)rightSpacing topSpacine:(CGFloat)topSpacing andWidth:(CGFloat)width height:(CGFloat)height 
{
    
    if (isHorizontal) {
        
       return CGRectMake(view.frame.origin.x + view.frame.size.width + rightSpacing, view.frame.origin.y + topSpacing, width, height);
    }else
    {
       return CGRectMake(view.frame.origin.x + rightSpacing, view.frame.origin.y + view.frame.size.height + topSpacing, width, height);
    }

    
    
}


//获取宽度
- (CGFloat)w{
    
    return  self.frame.size.width;
}
//获取高度
- (CGFloat)h{
    
    return  self.frame.size.height;
}
//获取x坐标
- (CGFloat)x{
    
    return self.frame.origin.x;
}
//获取y坐标
- (CGFloat)y{
    
    return self.frame.origin.y;
}
//获取宽和x坐标的和
- (CGFloat)l{
    
    return self.frame.origin.x + self.frame.size.width;
}
//获取高和y坐标的和
- (CGFloat)v{
    
    return self.frame.origin.y + self.frame.size.height;
}

//获取中心点x坐标
- (CGFloat)c_x{
    
    return self.center.x;
}
//获取中心点y坐标
- (CGFloat)c_y{
    return self.center.y;
}


//查看视图存在当前窗口的位置
- (CGRect)locationInWindow{
    
    //获取在窗口上的位置
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    
    return [self convertRect:self.bounds toView:window];
}

//查看视图中心点存在当前窗口的位置
- (CGPoint)locationOfCenterInWindow{
    
    //获取在窗口上的位置
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    
    return [self convertPoint:self.center toView:window];
}

//视图剪切
- (void)cropLayer:(CGFloat)radian{
    
    self.layer.masksToBounds = YES;
    
    self.layer.cornerRadius = radian;
}

//剪切边框附加颜色
- (void)borderCutWithColor:(UIColor *)color width:(CGFloat)width{
    
    self.layer.borderColor = color.CGColor;
    
    self.layer.borderWidth = width;
}


//回收键盘
- (void)recycleKeyBoardWithDelegate:(id)delegate{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packUpInController)];
    
    if (delegate) {
        
        tap.delegate = delegate;
    }
    
    [self addGestureRecognizer:tap];
}

//执行回收键盘
- (void)packUpInController{
    
    kKeyBoardHiden;
}

//横向线
- (void)createLevel{
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,(self.h - 1.0)/2, self.w, 1.0)];
    line.backgroundColor = kRedColor;
    [self addSubview:line];
    
}

//竖向线
- (void)createVertical{
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake((self.w - 1.0)/2,0, 1.0,self.h)];
    line.backgroundColor = kRedColor;
    [self addSubview:line];
    
}

//阴影样式
- (void)shadowStyle{
    
    //阴影的颜色
    self.layer.shadowColor = kBlackColor.CGColor;
    //阴影的透明度
    self.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    self.layer.shadowRadius = 2.f;
    //阴影偏移量
    self.layer.shadowOffset = CGSizeMake(3,3);
}

/**
 *  裁边的可选项
 typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 UIRectCornerAllCorners  = ~0UL
 };
 */
- (void)cornerWithSize:(CGFloat)width{
    
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = nil;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerBottomLeft cornerRadii:size];
    maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(width, width)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
}

- (void)setCornerType:(NSNumber *)cornerType{
    
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = nil;
    //    maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerBottomLeft cornerRadii:size];
    
    switch (cornerType.intValue) {
        case 0:{
            
            maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        }
            break;
        case 1:{
            
            maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
        }
            break;
        case 2:{
            
            maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopRight |  UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
        }
            break;
        case 3:{
            
            maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft |  UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
        }
            break;
        default:{
            
            maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3, 3)];
        }
            break;
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
}

-(void)updateViewConstraints:(NSLayoutAttribute)attribute constant:(CGFloat)constant{
    
    
    NSArray *constrains = self.constraints;
    
    for(NSLayoutConstraint *constraint in constrains){
        
        if(constraint.firstAttribute == attribute){
            
            constraint.constant = constant;
        }
        
        //        if(constraint.firstAttribute ==NSLayoutAttributeHeight){
        //
        //            constraint.constant = constant;
        //        }
    }
}

@end
