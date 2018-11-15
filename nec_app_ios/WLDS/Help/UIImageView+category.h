//
//  UIImageView+category.h
//  XHLEBusiness
//
//  Created by 新货郎 on 16/10/11.
//  Copyright © 2016年  zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (category)

//改变图片颜色
- (void)changeImage:(UIImage *)image color:(UIColor *)color;

//图片缩放到指定大小尺寸
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

@end
