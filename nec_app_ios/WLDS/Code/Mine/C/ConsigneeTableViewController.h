//
//  ConsigneeTableViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/9.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

//收发货人管理
@interface ConsigneeTableViewController : UITableViewController

//选择回传参数
@property (nonatomic,copy) void (^chooseConsigneeBlock) (NSDictionary *data);

@end
