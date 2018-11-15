//
//  UIImage+category.h
//  XHLEBusiness
//
//  Created by 新货郎 on 17/4/3.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (category)

//用颜色创建一张图片
+ (UIImage *)createImageWithColor:(UIColor *)color;

//修改图片颜色
+(UIImage *)changeImage:(UIImage *)image color:(UIColor *)color;

    //图片缩放到指定大小尺寸
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

@end
