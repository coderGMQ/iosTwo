//
//  TapImageView.h
//  XLMusic
//
//  Created by lanou3g on 15/8/31.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapImageView : UIImageView


//是否为剪切圆
@property (nonatomic) BOOL round;

-(instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action;

@end
