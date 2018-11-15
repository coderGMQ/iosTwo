//
//  AnimationObject.h
//  XHLEBusiness
//
//  Created by 新货郎 on 16/11/12.
//  Copyright © 2016年  zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AnimationObject : NSObject

@property (nonatomic,copy) void (^animationOver)(BOOL finish);


/**
 *  将某个view或者layer从起点抛到终点
 *
 *  @param obj    被抛的物体
 *  @param start  起点坐标
 *  @param end    终点坐标
 */
- (void)throwView:(UIView *)obj from:(CGPoint)start to:(CGPoint)end;

//放大动画
- (void)zoomView:(UIView *)view from:(CGPoint)point;

@end
