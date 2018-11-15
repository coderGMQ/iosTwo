//
//  InfoCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/18.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell

//输入完成回调
@property (nonatomic,copy) void (^endPutBlock) (NSString *value);

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UITextField *tf;

@end
