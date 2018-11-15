//
//  RegisterCell.m
//  WLDS
//
//  Created by han chen on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "RegisterCell.h"

@implementation RegisterCell
@synthesize registerdelegate;

- (void)awakeFromNib {
    [super awakeFromNib];



    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark 拍照
- (IBAction)userTakePhoto:(UIButton *)sender{
    if (self.registerdelegate && [self.registerdelegate respondsToSelector:@selector(userTakePhoto:)]) {
        [self.registerdelegate userTakePhoto:sender];
    }
}


#pragma mark 获取验证码
- (IBAction)getVerCode:(UIButton *)sender{
    if (self.registerdelegate && [self.registerdelegate respondsToSelector:@selector(getVerCode:)]) {
        [self.registerdelegate getVerCode:sender];
    }
}

#pragma mark   证件类型选择
- (IBAction)selectCertType:(UIButton *)sender{

    if (self.registerdelegate && [self.registerdelegate respondsToSelector:@selector(selectCertType:)]) {

        [self.registerdelegate selectCertType:sender];
    }
}
@end
