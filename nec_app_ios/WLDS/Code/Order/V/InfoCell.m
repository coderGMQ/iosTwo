//
//  InfoCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/18.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "InfoCell.h"

@interface InfoCell ()<UITextFieldDelegate>

@end

@implementation InfoCell

#pragma mark ========   UITextFieldDelegate   ========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.text = [NSString removeTheSpacesForString:textField.text];
    
    BLOCK_EXEC(self.endPutBlock,textField.text);
}

//约束小数点位置
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //判断是否为小数点键盘
    if (textField.keyboardType == 8){
        
        BOOL isHaveDian = NO;;
        
        if ([textField.text rangeOfString:@"."].location != NSNotFound){
            
            isHaveDian = YES;
        }
        //大于0表示添加数据
        if (string.length > 0){
            
            //首字母不能为0和小数点
            if(textField.text.length > 0){
                
                //是否含有小数点
                if (isHaveDian == YES){
                    
                    if([string isEqualToString:@"."]){
                        
                        return NO;
                        
                    }else{
                        //截取小数点所在位置
                        NSRange range = [textField.text rangeOfString:@"."];
                        
                        //截取掉小数点之后的字符串
                        NSString *sub = [textField.text substringFromIndex:range.location];
                        
                        if (sub.length > 4){
                            
                            return NO;
                        }
                    }
                }
            }
        }
        
    }else{
        
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
        
        if (![string isEqualToString:tem]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tf.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
