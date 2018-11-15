//
//  BindingCheckCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/24.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "BindingCheckCell.h"

@implementation BindingCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//绑定按钮
- (IBAction)bindingButton:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"绑定"]) {
        
        BLOCK_EXEC(self.bindingBlock);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
