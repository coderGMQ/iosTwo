//
//  CellHeaderView.m
//  WLDS
//
//  Created by han chen on 2018/3/22.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CellHeaderView.h"

@implementation CellHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (instancetype)initWithFrame:(CGRect)frame {
//
//    self = [super initWithFrame:frame];
//
//    if (self) {
//
//        self = [[NSBundle mainBundle] loadNibNamed:@"CellHeaderView" owner:self options:nil][0];
//
//        self.frame = frame;// 必须给View的frame赋值
//
//    }
//
//    return self;
//}

+ (instancetype)initStanceView
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"CellHeaderView" owner:self options:nil];

    return [nibView objectAtIndex:0];
}

@end
