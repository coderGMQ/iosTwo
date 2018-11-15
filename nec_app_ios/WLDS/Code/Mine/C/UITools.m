//
//  UITools.m
//  WLDS
//
//  Created by han chen on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "UITools.h"

@implementation UITools

+ (NSMutableAttributedString *)setAttributeStr:(NSString *)rowContengStr titleStrLeng:(int)rowTitleStrLeng
{
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:rowContengStr];

    [str3 addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, rowTitleStrLeng)];

    return str3;
}

+ (BOOL)judgeIDCard:(NSString *)IDCard{
    /**
     *身份证号码 17位加最后一位^\\d{17}(\\d|X)$
     */
    NSString *phoneRegex = @"^\\d{17}(\\d|X)$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:IDCard];
}

+ (NSString *)cardNoFromStr:(NSString *)cardNo{
    if (cardNo.length < 4) {
        return cardNo;
    }
    
    if(cardNo.length <= 8&&cardNo.length > 4){
        cardNo =[NSString stringWithFormat:@"****%@",[cardNo substringFromIndex:cardNo.length-4]];
    }
    else{
        cardNo =[NSString stringWithFormat:@"%@****%@",[cardNo substringToIndex:4],[cardNo substringFromIndex:cardNo.length-4]];
    }
    return cardNo;
}

+(BOOL)judgeTheIDCardLastCharacter:(NSString *)IDCard{

    NSString *last = nil;

    if([UITools judgeIDCard:IDCard])
        {
        NSInteger sum = 0;

        NSMutableString *str1 = [NSMutableString stringWithString:IDCard];

        [str1 deleteCharactersInRange:NSMakeRange(17, 1)];

        for(NSInteger i=0;i<17;i++){

            NSString *strs = [NSString stringWithFormat:@"%c",[str1 characterAtIndex:16-i]];
            NSInteger ai = [strs integerValue];
            sum += (NSInteger)ai*pow(2, i+1);
        }

        NSInteger num = (NSInteger)sum%11;


        switch (num)
            {
                case 0:last = @"1";break;
                case 1:last = @"0";break;
                case 2:last = @"X";break;
                case 3:last = @"9";break;
                case 4:last = @"8";break;
                case 5:last = @"7";break;
                case 6:last = @"6";break;
                case 7:last = @"5";break;
                case 8:last = @"4";break;
                case 9:last = @"3";break;
                case 10:last = @"2";break;
                default:break;
            }
        NSString *strs = [NSString stringWithFormat:@"%c",[IDCard characterAtIndex:17]];

        if([last isEqualToString:strs])
            {

            return YES;
            }

        }
    return NO;
}


/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$"];
    
    NSLog(@" === 邮箱 == 验证结果 == %d",[pred evaluateWithObject:email]);
    return [pred evaluateWithObject:email];
}


+ (void)changeBackground:(UILabel *)targetLab{

    NSString *title = targetLab.text;

    if ([title isEqualToString:@"待接收"]) {
        targetLab.textColor = kHexColor(0xef8b00);
        targetLab.backgroundColor = kHexColor(0xfdfbe8);
        targetLab.layer.borderColor=[kHexColor(0xf2ba73) CGColor];
    }
    else if ([title isEqualToString:@"已接收"] || [title isEqualToString:@"已认证"]) {
        targetLab.textColor = kHexColor(0x37a0cd);
        targetLab.backgroundColor = kHexColor(0xebf6fb);
        targetLab.layer.borderColor=[kHexColor(0x569fd1) CGColor];
    }
    else if ([title isEqualToString:@"已拒绝"] || [title isEqualToString:@"有异常"]) {
        targetLab.textColor = kHexColor(0xcd0000);
        targetLab.backgroundColor = kHexColor(0xf9e7e8);
        targetLab.layer.borderColor=[kHexColor(0xd47c7d) CGColor];
    }
    else if ([title isEqualToString:@"已确认"]) {
        targetLab.textColor = kHexColor(0x61b554);
        targetLab.backgroundColor = kHexColor(0xf1f8f0);
        targetLab.layer.borderColor=[kHexColor(0x75bd6c) CGColor];
    }
    else if ([title isEqualToString:@"已撤回"]) {
        targetLab.textColor = [UIColor whiteColor];
        targetLab.backgroundColor = kHexColor(0x7A7A7A);
        targetLab.layer.borderColor=[kHexColor(0x878889) CGColor];
    }else if ([title isEqualToString:@"已撤销"]) {
        targetLab.textColor = [UIColor whiteColor];
        targetLab.backgroundColor = kHexColor(0x7A7A7A);
        targetLab.layer.borderColor=[kHexColor(0x878889) CGColor];
    }

}


@end
