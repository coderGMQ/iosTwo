//
//  UIImage+category.m
//  XHLEBusiness
//
//  Created by 新货郎 on 17/4/3.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "UIImage+category.h"

@implementation UIImage (category)

//改变图片颜色
+(UIImage *)changeImage:(UIImage *)image color:(UIColor *)color{
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  newImage;
}

//用颜色创建一张图片
+ (UIImage *)createImageWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

    //图片缩放到指定大小尺寸
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{

        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);

        // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];

        // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
    UIGraphicsEndImageContext();

        // 返回新的改变大小后的图片
    return scaledImage;
}

@end
