//
//  InfoChooseCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/18.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoChooseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *sub;

//选中标题和位置
@property (nonatomic,copy) void (^chooseValueBlock) (NSInteger index,NSString *title);


//展示视图
- (void)showWithItems:(NSArray *)items;

//选中图片位置
- (void)chaneImage:(NSInteger)index;

@end
