//
//  TapImageView.m
//  XLMusic
//
//  Created by lanou3g on 15/8/31.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//通过手势给视图增加触发事件(taget 一般是调用视图的控制器)
-(instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:taget action:action];
        
        [self addGestureRecognizer:tap];
        
        //打开交互
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

//是否为圆
- (void)setRound:(BOOL)round{
    
    if (round == YES) {
        
        self.layer.masksToBounds = YES;
        
        self.layer.cornerRadius = self.h / 2;
    }
}


@end
