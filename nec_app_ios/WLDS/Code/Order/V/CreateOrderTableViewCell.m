//
//  CreateOrderTableViewCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/5.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CreateOrderTableViewCell.h"

@interface CreateOrderTableViewCell ()<UITextFieldDelegate>

@end

@implementation CreateOrderTableViewCell


//文本赋值操作
- (void)textValues:(NSDictionary *)data{
    
    for (int i = 0; i < 4; i++) {
        //获取文本
        UITextField *tf = (UITextField *)[self viewWithTag:433230 + i];
        
        tf.delegate = self;
        
        if (i == 0) {
            //名称
            tf.text = data[@"productName"];
        }else if (i == 1){
            //件数
            tf.text = data[@"goodsNum"];
        }else if (i == 2){
            //体积
            tf.text = data[@"volume"];
        }else if (i == 3){
            //重量
            tf.text = data[@"weight"];
        }
        
    }
}

#pragma mark ========   UITextFieldDelegate   ========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.text = [NSString removeTheSpacesForString:textField.text];
    
    BLOCK_EXEC(self.valueBlock,textField.text,textField.tag - 433230);
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
