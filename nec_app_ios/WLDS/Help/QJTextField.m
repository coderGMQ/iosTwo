//
//  QJTextField.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/12/28.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "QJTextField.h"

@implementation QJTextField

//重写父类初始化方法
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        //添加监听事件
        [self addTarget:self action:@selector(changedQJTextField:)
          forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addTarget:self action:@selector(changedQJTextField:)
          forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedQJTextField:(QJTextField *)tf{
    
    //数据变化
    BLOCK_EXEC(self.valueChange,tf.text);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
