//
//  ServeDetailsCollectionReusableView.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/3.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ServeDetailsCollectionReusableView.h"

@implementation ServeDetailsCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        //文本信息
        _title = [[UILabel alloc] initWithFrame:CGRectMake(kFitW(10),kFitW(10), kWidth - kFitW(20), kFitW(40))];
        _title.textColor = KTEXT_COLOR;
        _title.font = kFontSize(kFitW(15));
        [self addSubview:_title];
        
        //文本信息
        _content = [[UILabel alloc] initWithFrame:CGRectMake(_title.x,_title.v,_title.w, kFitW(20))];
        _content.textColor = kGrayColor;
        _content.font = kFontSize(kFitW(15));
        [self addSubview:_content];
    }
    
    return self;
}

@end
