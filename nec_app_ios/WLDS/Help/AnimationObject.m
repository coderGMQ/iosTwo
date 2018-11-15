//
//  AnimationObject.m
//  XHLEBusiness
//
//  Created by 新货郎 on 16/11/12.
//  Copyright © 2016年  zhiyundaohe. All rights reserved.
//

#import "AnimationObject.h"

//动画时间间隔
#define kTimerInterval 0.8f

@implementation AnimationObject

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
}


/**
 *  将某个view或者layer从起点抛到终点
 *
 *  @param obj    被抛的物体
 *  @param start  起点坐标
 *  @param end    终点坐标
 */
- (void)throwView:(UIView *)animationView from:(CGPoint)start to:(CGPoint)end{
    
    //绘制贝泽尔曲线
    UIBezierPath *path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(start.x, start.y)];
    
    [path addCurveToPoint:CGPointMake(end.x, end.y)
            controlPoint1:CGPointMake(start.x, start.y)
            controlPoint2:CGPointMake((start.x + end.x)/2, start.y - 200)];
    
    //基本缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    
    //帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    //基本动画
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //组合动画
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[scaleAnimation,animation,alphaAnimation];
    groups.duration = kTimerInterval;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [animationView.layer addAnimation:groups forKey:@"position scale"];
    
}


#pragma mark ========   动画开始执行   ========
- (void)animationDidStart:(CAAnimation *)anim{
    
}

#pragma mark ========   动画执行完成   ========
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (self.animationOver != nil) {
        
        self.animationOver(YES);
    }
    
}


/*
 
 //透明度变化
 CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
 opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
 opacityAnimation.toValue = [NSNumber numberWithFloat:0.01];
 
 //旋转动画
 CABasicAnimation* rotationAnimation =
 [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
 rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 3];
 rotationAnimation.duration = 0.8f;
 rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出
 
 //缩放动画
 CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
 scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
 scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
 scaleAnimation.duration = 0.8f;
 
 //组合动画
 CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
 animationGroup.duration = 0.8f;
 //    animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
 animationGroup.repeatCount = 1;//HUGE_VALF;     //HUGE_VALF,源自math.h
 [animationGroup setAnimations:[NSArray arrayWithObjects:opacityAnimation,rotationAnimation, scaleAnimation, nil]];
 animationGroup.delegate = self;
 
 //解决动画结束后闪动的问题
 animationGroup.removedOnCompletion = NO;
 
 animationGroup.fillMode = kCAFillModeForwards;
 
 */
- (void)zoomView:(UIView *)view from:(CGPoint)point{
    
    //基本缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.3];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    
    //帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    NSValue *startPoint = [NSValue valueWithCGPoint:point];
    
    point = CGPointMake(point.x, point.y - kFitW(10));
    NSValue *midPoint = [NSValue valueWithCGPoint:point];
    
    point = CGPointMake(point.x + kFitW(5), point.y - kFitW(10));
    NSValue *endPoint = [NSValue valueWithCGPoint:point];
    
    point = CGPointMake(point.x - kFitW(5), point.y - kFitW(10));
    NSValue *lastPoint = [NSValue valueWithCGPoint:point];
    
    point = CGPointMake(point.x + kFitW(5), point.y - kFitW(10));
    NSValue *rePoint = [NSValue valueWithCGPoint:point];

    //添加移动至
    animation.values = @[startPoint,midPoint,endPoint,lastPoint,rePoint];
    animation.rotationMode = kCAAnimationRotateAuto;
    
    //基本动画
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //组合动画
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[scaleAnimation,animation,alphaAnimation];
    groups.duration = kTimerInterval;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"zoomView" forKey:@"animationName"];
    [view.layer addAnimation:groups forKey:@"position scale"];
    
}


@end


