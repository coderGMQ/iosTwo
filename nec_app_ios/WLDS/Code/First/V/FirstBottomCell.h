//
//  FirstBottomCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/5/9.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstBottomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *order;

@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (weak, nonatomic) IBOutlet UILabel *logTime;

@property (weak, nonatomic) IBOutlet UILabel *logMessage;

//点击手势
@property (nonatomic,copy) void (^tapCodeBlock) (void);

@end
