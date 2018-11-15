
//
//  UISegmentedControl+category.m
//  BQBusiness
//
//  Created by xhl on 16/5/28.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "UISegmentedControl+category.h"

@implementation UISegmentedControl (category)

- (void)changeSelectedColor:(UIColor *)selectedColor unSelectedColor:(UIColor *)unSelectedColor titleFont:(CGFloat)fontSize{
    
    //boldSystemFontOfSize  systemFontOfSize
    self.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kFitW(fontSize)],NSForegroundColorAttributeName:selectedColor};
    
    [self setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kFitW(fontSize)],NSForegroundColorAttributeName:unSelectedColor};
    
    [self setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
}


@end
