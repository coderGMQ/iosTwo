//
//  BindingCheckViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/24.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

//绑定查询结果
@interface BindingCheckViewController : UIViewController


////更新前页数据
//@property (nonatomic,copy) void (^updateBindingBlock) (BOOL success);

@property (nonatomic,strong) NSMutableArray *array;

@end
