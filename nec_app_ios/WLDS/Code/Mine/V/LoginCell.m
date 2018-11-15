//
//  LoginCell.m
//  WLDS
//
//  Created by han chen on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)codeAction:(UIButton *)sender{

    
    if (self.secureText == YES) {
        
        sender.selected = !sender.selected;
        
        if (sender.selected == YES) {
            
            
            self.tf.secureTextEntry =  NO;
        }
        else{
            
            self.tf.secureTextEntry =  YES;
        }
        
//        if (sender.isSelected) {
//
//            sender.selected = NO;
//
//            self.tf.secureTextEntry =  NO;
//        }
//        else{
//            sender.selected = YES;
//
//            self.tf.secureTextEntry =  YES;
//        }
        
    }
    
}

@end
