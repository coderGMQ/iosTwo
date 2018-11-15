//
//  OrderListCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/9.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *code;

@property (weak, nonatomic) IBOutlet UILabel *statue;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *goodsInfo;


@property (weak, nonatomic) IBOutlet UILabel *personInfo;

@property (weak, nonatomic) IBOutlet UILabel *address;


@end
