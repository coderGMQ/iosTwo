//
//  HaulageOperatorTableViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/8.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

//货物承运公司
@interface HaulageOperatorTableViewController : UITableViewController

@property (nonatomic,strong) NSMutableDictionary *data;

//合作运力数据
@property (nonatomic,strong) NSMutableArray *array;

//回传运力
@property (nonatomic,copy) void (^chooseOrgBlock) (NSDictionary *obj);

@end
