//
//  MessageDetailsTableViewCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

//Message Details Table View Cell

@interface MessageDetailsTableViewCell : UITableViewCell


//货物名
@property (weak, nonatomic) IBOutlet UILabel *productName;
//货物数量
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
//货物重量
@property (weak, nonatomic) IBOutlet UILabel *weight;
//货物体积
@property (weak, nonatomic) IBOutlet UILabel *volume;

//异形件
@property (weak, nonatomic) IBOutlet UILabel *unusual;

//税金
@property (weak, nonatomic) IBOutlet UILabel *taxes;

+ (instancetype)messageDetailsTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data;


@end
