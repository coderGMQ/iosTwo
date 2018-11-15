//
//  UITools.h
//  WLDS
//
//  Created by han chen on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITools : NSObject

//改变--颜色
+ (NSMutableAttributedString *)setAttributeStr:(NSString *)rowContengStr titleStrLeng:(int)rowTitleStrLeng;

+ (BOOL)judgeIDCard:(NSString *)IDCard;

+ (NSString *)cardNoFromStr:(NSString *)cardNo;

+(BOOL)judgeTheIDCardLastCharacter:(NSString *)IDCard;

+ (void)changeBackground:(UILabel *)targetLab;

+ (BOOL)isValidateEmail:(NSString *)email;


@end
