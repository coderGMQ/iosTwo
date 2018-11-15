//
//  MineCell.h
//  WLDS
//
//  Created by han chen on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineCellDelegate <NSObject>


- (void)userLogin:(UIButton *)sender;

@end

@interface MineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *loginNameLab;

@property (weak, nonatomic) IBOutlet UIImageView *loginImg;


@property (nonatomic, weak)id <MineCellDelegate> minedelegate;


@end
