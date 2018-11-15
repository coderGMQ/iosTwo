//
//  DiscountsTableViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/28.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountsTableViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,copy) void (^chooseDataBlock) (NSDictionary *obj);
//
//// Province City Region Street Address
//@property (nonatomic,copy) void (^chooseBlock) (NSString *name,NSString *Id);

@end
