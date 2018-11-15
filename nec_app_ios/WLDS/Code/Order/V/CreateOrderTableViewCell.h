//
//  CreateOrderTableViewCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/5.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderTableViewCell : UITableViewCell

@property (nonatomic,copy) void (^valueBlock) (NSString *text,NSInteger index);

//文本赋值操作
- (void)textValues:(NSDictionary *)data;

@end
