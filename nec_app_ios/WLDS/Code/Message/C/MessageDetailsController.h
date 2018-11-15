//
//  MessageDetailsController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailsController : UIViewController

//回调数据
@property (nonatomic,copy) void (^ _Nullable backMessageBlock)(BOOL success);

//订单编号
@property (nonatomic,strong) NSString *orderCode;


@end
