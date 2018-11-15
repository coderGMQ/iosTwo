//
//  MineCell.m
//  WLDS
//
//  Created by han chen on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.loginBtn.layer.cornerRadius = 18;

    self.loginBtn.layer.masksToBounds=YES;

    self.loginBtn.layer.borderColor=[[UIColor colorWithRed:0.08 green:0.51 blue:0.86 alpha:1] CGColor];

    self.loginBtn.layer.borderWidth= 1;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/***********************************************************************
 * 方法名称： userLogin
 * 功能描述：
 * 输入参数：
 * 输出参数：
 * 返 回 值： 空
 * 其它说明：
 ***********************************************************************/
- (IBAction)userLogin:(UIButton *)sender{
    if (self.minedelegate && [self.minedelegate respondsToSelector:@selector(userLogin:)]) {
        [self.minedelegate userLogin:sender];
    }
}


@end
