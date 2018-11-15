//
//  XLCATransAnimation.h
//  DouBan
//
//  Created by lanou3g on 15/8/25.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XLCATransAnimation : NSObject

//切换视图动画
+ (CATransition *)transitionType:(NSString * const)type Subtype:(NSString * const) subtype Delegate:(id) delegate;

@end
