
//
//  PriceCheckTableViewCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/1.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "PriceCheckTableViewCell.h"

@interface PriceCheckTableViewCell ()<UITextFieldDelegate>


@end

@implementation PriceCheckTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = 0;
        
        for (int i = 0; i < 6; i++) {
            
            //文本信息
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,i * kFitW(40), 15 * 4.5, kFitW(40))];
            label.textColor = KTEXT_COLOR;
            label.font = kFontSize(15);
            [self addSubview:label];
            
            //输入文本框
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.l, label.y, kWidth - label.l - label.x,label.h)];
            tf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
            tf.font = label.font;
            tf.textAlignment = NSTextAlignmentRight;
            tf.delegate = self;
            tf.tag = 2343540 + i;
            [self addSubview:tf];
            
            switch (i) {
                case 0:{
                    
                    label.text = @"货物名称";
                    tf.placeholder = @"请填写货物的名称";
                }
                    break;
                case 1:{
                    
                    label.text = @"货物重量";
                    tf.placeholder = @"请填写货物的重量(单位:吨)";
                    tf.keyboardType = UIKeyboardTypeDecimalPad;
                }
                    break;
                case 2:{
                    
                    label.text = @"货物体积";
                    tf.placeholder = @"请填写货物的体积(单位m3)";
                    tf.keyboardType = UIKeyboardTypeDecimalPad;
                }
                    break;
                case 3:{
                    label.text = @"货物件数";
                    tf.placeholder = @"请填写货物件数";
                    tf.keyboardType = UIKeyboardTypeNumberPad;
                    
                }
                    break;
   
                case 4:{
                    label.text = @"代收货款";
                    tf.placeholder = @"请输入代收货款(单位元)";
                    tf.keyboardType = UIKeyboardTypeDecimalPad;
                    
                }
                    break;
                case 5:{
                    label.text = @"回单";
                    tf.placeholder = @"请输入回单份数";
                    tf.keyboardType = UIKeyboardTypeNumberPad;
                }
                    break;
                    
                default:
                    break;
            }
            //底部细线
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,label.y, kWidth, 1.0)];
            [self addSubview:line];
            line.backgroundColor = kLikeColor;
        }
    }
    return self;
}

#pragma mark ========   UITextFieldDelegate   ========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.text = [NSString removeTheSpacesForString:textField.text];
    
    BLOCK_EXEC(self.inputValueBlock,textField.text,textField.tag - 2343540);
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
