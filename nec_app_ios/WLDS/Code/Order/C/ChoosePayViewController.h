//
//  ChoosePayViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/16.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePayViewController : UIViewController

//订单编号
@property (nonatomic,strong) NSString *orderCode;

//更新前页数据
@property (nonatomic,copy) void (^updatePayBlock) (BOOL success);

@end
