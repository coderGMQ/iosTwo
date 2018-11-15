//
//  CodeFiltrateViewController.h
//  BNZY
//
//  Created by zhiyundaohe on 2018/1/13.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

//运单筛选
@interface CodeFiltrateViewController : UIViewController

//是否为时间选择
@property (nonatomic) BOOL checkTime;

//查询标题
@property (nonatomic,strong) NSString *name;

//查询状态结合
@property (nonatomic,strong) NSMutableArray *statueArray;

//新的筛选条件
@property (nonatomic,copy) void (^codeFiltrateStatueData) (NSString *number,NSString *start,NSString *end,NSString *statue);

@end
