//
//  ChooseImageCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/23.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseImageCell : UITableViewCell

//主图
@property (weak, nonatomic) IBOutlet UIImageView *IM;
//标题
@property (weak, nonatomic) IBOutlet UILabel *title;
//中间展位图
@property (weak, nonatomic) IBOutlet UIImageView *midIM;

@end
