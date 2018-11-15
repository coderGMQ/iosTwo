//
//  CreateInputViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/17.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

//创建输入
@interface CreateInputViewController : UIViewController

//数据
@property (nonatomic,strong) NSMutableDictionary *request;

//输入页面类型
@property (nonatomic) NSInteger type;
//数据回传
@property (nonatomic,copy) void (^dataBlock) (NSDictionary *data);


@end
