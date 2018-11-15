//
//  CarrierProductTableViewCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/8.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarrierProductTableViewCell : UITableViewCell

//编号
@property (weak, nonatomic) IBOutlet UILabel *number;
//运费
@property (weak, nonatomic) IBOutlet UILabel *fee;
//保险
@property (weak, nonatomic) IBOutlet UILabel *insurance;
//时效
@property (weak, nonatomic) IBOutlet UILabel *aging;

@end
