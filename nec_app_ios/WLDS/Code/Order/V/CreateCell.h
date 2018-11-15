//
//  CreateCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/16.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCell : UITableViewCell

@property (nonatomic,copy) void(^tapChooseBlock) (NSInteger index);
//货物名称
@property (weak, nonatomic) IBOutlet UILabel *name;
//货物信息描述
@property (weak, nonatomic) IBOutlet UILabel *notice;


//厂单类型
@property (weak, nonatomic) IBOutlet UILabel *order;
//支付方式
@property (weak, nonatomic) IBOutlet UILabel *pay;
//提货方式
@property (weak, nonatomic) IBOutlet UILabel *pick;
//送货方式
@property (weak, nonatomic) IBOutlet UILabel *send;

//代收金额
@property (weak, nonatomic) IBOutlet UILabel *collection;
//投保
@property (weak, nonatomic) IBOutlet UILabel *insure;


//货物详情描述
@property (weak, nonatomic) IBOutlet UILabel *detail;




//赋值操作
- (void)giveValueWithDict:(NSDictionary *)dict;

@end
