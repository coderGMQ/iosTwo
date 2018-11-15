//
//  QJTextField.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/12/28.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QJTextField : UITextField

//实时监听数据变化
@property (nonatomic,copy) void (^valueChange) (NSString *value);


@end
