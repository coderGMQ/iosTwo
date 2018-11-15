//
//  UIResponder+Category.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/27.
//Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "UIResponder+Category.h"

static __weak id currentFirstResponder;

@implementation UIResponder (Category)


+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
