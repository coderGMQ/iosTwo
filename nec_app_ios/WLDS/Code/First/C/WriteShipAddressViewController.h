//
//  WriteShipAddressViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

//填写发货地址
@interface WriteShipAddressViewController : UIViewController

//更新前页数据
@property (nonatomic,copy) void (^updateBlock) (BOOL success);

//信息
@property (nonatomic,strong) NSMutableDictionary *info;

// Province City Region Street Address
@property (nonatomic,copy) void (^writeAddressBlock) (NSDictionary *data);

// Province City Region Street Address Name Phone
@property (nonatomic,copy) void (^writeInfoBlock) (NSDictionary *data);


@end
