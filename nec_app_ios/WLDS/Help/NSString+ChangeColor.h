   //
//  NSString+ChangeColor.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/21.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ChangeColor)

//改变字符创颜色
+ (NSMutableAttributedString *)changeTextColor:(UIColor *)color forString:(NSString *)string fromLocation:(NSInteger)startLocation toLenth:(NSInteger)lenth;

//改变颜色
+ (NSMutableAttributedString *)changeColor:(UIColor *)color font:(UIFont *)font string:(NSString *)string change:(NSString *)change last:(NSString *)last;

//划线颜色
+ (NSMutableAttributedString *)changeLineColor:(UIColor *)color string:(NSString *)string change:(NSString *)change last:(NSString *)last;

//在字符串中间画划线
+ (NSMutableAttributedString *)setLineForString:(NSString *)string fromLocation:(NSInteger)startLocation toLenth:(NSInteger)lenth;

//消除字符串中的空格
+ (NSString *)removeTheSpacesForString:(NSString *)string;

//判断字符是不是为“<null>”
+ (NSString *)isNullWithString:(NSString *)string;

//调整label间距
+ (void)adjustLabel:(UILabel *)label  spacing:(CGFloat)spacing;


//根据字符串转换时间格式   formatterStr @"YYYY-MM-dd"
+ (NSString *)transformDateWithString:(NSString *)timeString  formatter:(NSString *)formatterStr;

//字符转换
+ (NSString *)transformString:(NSString *)string  useNewString:(NSString *)newStr replaceOldString:(NSString *)oldStr;

//字符串根据字体大小获取宽度
- (CGFloat)gainWidthWithFont:(UIFont *)font;

//字符串自适应高度
- (CGFloat)gainHeightWithFont:(UIFont *)font width:(CGFloat)width;

//一个字符的宽度
+ (CGFloat)oneCharacterWidthByFont:(UIFont *)font type:(int)type;

//一个字符的高度
+ (CGFloat)oneCharacterHeightByFont:(UIFont *)font;


//判断是否包含字符串（根据字符串查找）
- (BOOL)isContainString:(NSString *)string;

//根据字符串数组找出特殊字符（根据数组参照）
- (BOOL)isContainSpecialCharactersWithArray:(NSArray *)array;

//判断字符创是否全为数字
- (BOOL)isNumbers;

//根据字体、宽度计算字符串所占用高度（高度自适应）
- (CGFloat)calculationHeightByFont:(UIFont *)font width:(CGFloat)width;

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)firstCharactor:(NSString *)aString;

//转JSON对象
+ (NSString *)toJSONObject:(id)obj;

#pragma mark ========   判断字符串组合类型   ========
-(int)checkIsHaveNumAndLetter;


#pragma mark ========   删除双引号好   ========
- (NSString *)deleteQuotationMark;


#pragma mark ========   删除特殊字符   ========
- (NSString *)deleteSpecial:(NSString *)special;

// 将JSON串转化为字典或者数组
+ (id)toArrayOrDictionary:(NSData *)jsonData;

//json格式字符串转字典：
- (NSDictionary *)dictionaryWithJsonString;

//获取设备名称
+ (NSString *)getDeviceName;

//校验手机号
+(BOOL)isMobilePhone:(NSString *)phoneNum;
//是否符合拨打条件
- (BOOL)callNumber;
/*邮箱验证 MODIFIED BY HELENSONG*/
- (BOOL)isValidateEmail;
//校验车牌号
+(BOOL)checkCarID:(NSString *)carID;

#pragma mark    核对密码格式,6~24位数字/字母/下划线
+(BOOL)checkPsw:(NSString *)pswStr;

//默认都为数字，1表示全部为字母，2表示数字和字母，3表示只能输入汉字
+(BOOL)isAllNumber:(NSString *)string type:(int)type;

//获取网络状态
+(NSString *)getNetWorkStates;

@end
