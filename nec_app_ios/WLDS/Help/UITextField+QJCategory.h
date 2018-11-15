//
//  UITextField+QJCategory.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/12/28.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^changeValue)(NSString *before,NSString *value);

@interface UITextField (QJCategory)

@property (nonatomic,copy) changeValue QJBlock;

@end
