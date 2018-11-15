//
//  FirstBottomCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/5/9.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "FirstBottomCell.h"

@implementation FirstBottomCell

//手势点击
- (IBAction)tapNumber:(UITapGestureRecognizer *)sender {
    
    if (self.tapCodeBlock) {
        self.tapCodeBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
