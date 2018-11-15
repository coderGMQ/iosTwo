//
//  TapLabel.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/9/11.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapLabel : UILabel

-(instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action;

@end
