//
//  UISegmentedControl+category.h
//  BQBusiness
//
//  Created by xhl on 16/5/28.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (category)

//修改segmented选中和为选中字体颜色 以及字体大小
- (void)changeSelectedColor:(UIColor *)selectedColor unSelectedColor:(UIColor *)unSelectedColor titleFont:(CGFloat)fontSize;

@end
