
//
//  UIColor+changColor.m
//  BQLHProject
//
//  Created by xhl on 16/4/4.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "UIColor+changColor.h"

@implementation UIColor (changColor)

+ (UIColor *)colorWithHex:(long long)hex{
        
    NSString *str   = [NSString stringWithFormat:@"%llx",hex];
    CGFloat alpha   = str.length>6?((hex & 0xFF000000 ) >> 24) / 255.0F : 1.0;
    CGFloat red     = (( hex & 0xFF0000 ) >> 16 ) / 255.0F;
    CGFloat green   = (( hex & 0xFF00 ) >> 8 ) / 255.0F;
    CGFloat blue    = (( hex & 0xFF ) >> 0 ) / 255.0F;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
