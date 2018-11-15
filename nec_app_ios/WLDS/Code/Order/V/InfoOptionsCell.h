//
//  InfoOptionsCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/18.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoOptionsCell : UITableViewCell

//选中的位置记录（避免多次重复点击）
@property (nonatomic) NSInteger location;
//子项区域宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subWidth;

//位置
@property (nonatomic,copy) void (^chooseBlock) (NSInteger index);

@property (weak, nonatomic) IBOutlet UILabel *title;

//根据标题默认选择
- (void)chooseWithTitle:(NSString *)title;

//修改约束及标题位置(默认选中位置)
- (void)witdth:(CGFloat)width titles:(NSArray *)titles index:(NSInteger)index;

@end
