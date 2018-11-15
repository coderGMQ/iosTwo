//
//  HistoryTableViewCell.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/11/27.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

//删除数据
@property (nonatomic,copy) void (^removeBlock) (BOOL success);


@property (nonatomic,strong) UILabel *title;

//自定义初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width height:(CGFloat)height bottom:(CGFloat)bottom;


@end
