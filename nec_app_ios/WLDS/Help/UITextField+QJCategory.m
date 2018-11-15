//
//  UITextField+QJCategory.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/12/28.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "UITextField+QJCategory.h"

#import <objc/runtime.h>

@implementation UITextField (QJCategory)

//重写setter
- (void)setQJBlock:(changeValue)QJBlock{

    objc_setAssociatedObject(self, @selector(QJBlock), QJBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //添加监听
    [self addTarget:self action:@selector(changeVelue:) forControlEvents:(UIControlEventEditingChanged)];
}

//监听事件执行
- (void)changeVelue:(UITextField *)tf{
    
    NSString *before = @"";
    
    NSString *value = @"";
    
    if (tf.text.length > 0) {
        
        before = [tf.text substringToIndex:tf.text.length - 1];
        
        value = [tf.text substringFromIndex:tf.text.length - 1];
    }
    
    BLOCK_EXEC(self.QJBlock,before,value);
}

//重写getter
- (changeValue)QJBlock{
    
    return objc_getAssociatedObject(self, @selector(QJBlock));
}

@end
