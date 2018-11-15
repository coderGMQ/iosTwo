//
//  CALayer+JQCategory.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/7.
//Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CALayer+JQCategory.h"

@implementation CALayer (JQCategory)


-(void)setBorderUIColor:(UIColor*)color{
    
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor{
    
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
