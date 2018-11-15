
//
//  TapLabel.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/9/11.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "TapLabel.h"

@implementation TapLabel


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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
