

//
//  NSString+ChangeColor.m
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/21.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "NSString+ChangeColor.h"

#import "sys/utsname.h"

@implementation NSString (ChangeColor)


//改变字符创颜色
+ (NSMutableAttributedString *)changeTextColor:(UIColor *)color forString:(NSString *)string fromLocation:(NSInteger)startLocation toLenth:(NSInteger)lenth
{
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(startLocation, lenth)];
    
    return attString;
}

//改变颜色
+ (NSMutableAttributedString *)changeColor:(UIColor *)color font:(UIFont *)font string:(NSString *)string change:(NSString *)change last:(NSString *)last
{
    
    //拼接前2个字符串
    NSString *needStr = [string stringByAppendingString:change];
    
    //判断是否存在最后的文本
    if (last.length > 0) {
        
        //拼接上最后一个字符串
       needStr = [needStr stringByAppendingString:last];
    }
    
    //获取可变的字符创
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:needStr];
    //改颜色
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(string.length, change.length)];
    
    if (font != nil) {
                
        [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(string.length, change.length)];
    }

    return attString;
}

//改变颜色
+ (NSMutableAttributedString *)changeLineColor:(UIColor *)color string:(NSString *)string change:(NSString *)change last:(NSString *)last{
    
    //拼接前2个字符串
    NSString *needStr = [string stringByAppendingString:change];
    
    //判断是否存在最后的文本
    if (last.length > 0) {
        
        //拼接上最后一个字符串
        needStr = [needStr stringByAppendingString:last];
    }
    
    //获取可变的字符创
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:needStr];
    
    NSRange range = NSMakeRange(string.length, change.length);
    
    //改颜色
    [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    
    
    return attString;
}

//在字符串中间画划线
+ (NSMutableAttributedString *)setLineForString:(NSString *)string fromLocation:(NSInteger)startLocation toLenth:(NSInteger)lenth
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attString addAttribute:NSForegroundColorAttributeName value:kLightGrayColor range:NSMakeRange(startLocation, lenth)];
    
    [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(startLocation, lenth)];
    
    return  attString;
}

//消除字符串中的空格
+ (NSString *)removeTheSpacesForString:(NSString *)string
{
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
}


+ (NSString *)isNullWithString:(NSString *)string
{
    if ([string isEqualToString:@"<null>"]) {
        string = @"";
    }
    return string;
}


//调整label间距
+ (void)adjustLabel:(UILabel *)label  spacing:(CGFloat)spacing{
    
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:label.text];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //    [paragraphStyle setLineSpacing:5];
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    //
    //    label.attributedText = attributedString;
    //    //调节高度
    //    CGSize size = CGSizeMake(label.frame.size.width, 500000);
    //
    //    CGSize labelSize = [label sizeThatFits:size];
    //
    //    [label sizeThatFits:labelSize];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:spacing];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    
    label.attributedText = attributedString;
    
    [label sizeToFit];
 
}

//  timeString = @"14168827120000", formatterStr = @"YYYY-MM-dd"
+ (NSString *)transformDateWithString:(NSString *)timeString  formatter:(NSString *)formatterStr{
    
//    NSString *time = @"14168827120000";
    
    NSInteger num = [timeString integerValue]/1000;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//   formatterStr @"YYYY-MM-dd"
    [formatter setDateFormat:formatterStr];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}


//字符转换
+ (NSString *)transformString:(NSString *)string  useNewString:(NSString *)newStr replaceOldString:(NSString *)oldStr{
    
    if ([string isEqualToString:oldStr]) {
        
        return newStr;
        
    }else{
        
        return string;
    }
    
}


//字符串根据字体大小获取宽度
- (CGFloat)gainWidthWithFont:(UIFont *)font{
    
    CGRect frame = [self boundingRectWithSize:CGSizeMake(100000, 100000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    
    return frame.size.width;
}

//字符串自适应高度
- (CGFloat)gainHeightWithFont:(UIFont *)font width:(CGFloat)width{
    
    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];

    return frame.size.height;
}

//一个字符的宽度
+ (CGFloat)oneCharacterWidthByFont:(UIFont *)font type:(int)type{
    
    NSString *string = @"";
    
    if (1 == type) {
        
        string = @"9";
        
    }else if (2 == type) {
        
        string = @".";
        
    }else{
        
        string = @"汉";
    }
    
    CGRect frame = [string boundingRectWithSize:CGSizeMake(100000, 100000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    
    
    return frame.size.width;
}

//一个字符的高度
+ (CGFloat)oneCharacterHeightByFont:(UIFont *)font{
    
    CGRect frame = [@"汉" boundingRectWithSize:CGSizeMake(10000, 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
        
    return frame.size.height;
}


//根据字符串找出特殊字符
- (BOOL)isContainString:(NSString *)string{
    
    if([self rangeOfString:string].location != NSNotFound){
        
        return YES;
    }else{
        
        return NO;
    }
}


//根据字符串数组找出特殊字符,一旦出现，跳出循环
- (BOOL)isContainSpecialCharactersWithArray:(NSArray *)array{
    
    if (array.count > 0) {
        
        BOOL result = NO;
        
        for (NSString *string in array) {
            
            if([self rangeOfString:string].location != NSNotFound){
                
                result = YES;
                
            }else{
                
                result = NO;
                
                break;
            }
        }
        
        return result;
        
    }else {
        
        return NO;
    }
}

//判断字符创是否全为数字
- (BOOL)isNumbers{
    
    NSScanner* scan = [NSScanner scannerWithString:self];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}


//根据字体、宽度计算字符串所占用高度（高度自适应）
- (CGFloat)calculationHeightByFont:(UIFont *)font width:(CGFloat)width{
    

    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    
    return frame.size.height;
    //    CGSize gainSize = [self boundingRectWithSize:CGSizeMake(width, 100000) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
    //    return gainSize.height;
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)firstCharactor:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

//转JSON对象
+ (NSString *)toJSONObject:(id)obj{
    
    //productIdAndNum
    NSError *parseError = nil;
    
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&parseError];
    
    //验证的json串
    return  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark ========   判断字符串组合类型   ========
-(int)checkIsHaveNumAndLetter{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    if (tNumMatchCount == self.length) {
        //全部符合数字，表示沒有英文
        return 1;
    } else if (tLetterMatchCount == self.length) {
        //全部符合英文，表示沒有数字
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount == self.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return 3;
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
}

#pragma mark ========   删除双引号好   ========
- (NSString *)deleteQuotationMark{
    
    //取出字符串中的双引号
    if (self.length == 0) {
        
        return @"";
    }
    
    return  [self stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
}

#pragma mark ========   删除特殊字符   ========
- (NSString *)deleteSpecial:(NSString *)special{
    
    //取出字符串中的双引号
    
    if (self.length == 0) {
        
        return @"";
    }
    
    return  [self stringByReplacingOccurrencesOfString:special withString:@""];
}

// 将JSON串转化为字典或者数组
+ (id)toArrayOrDictionary:(NSData *)jsonData{
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

//json格式字符串转字典：
- (NSDictionary *)dictionaryWithJsonString{
    
    if (self == nil) {
        
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
                
        return nil;
    }
    
    return dic;
}
//获取设备名称
+ (NSString *)getDeviceName{
    
    // 需要#import "sys/utsname.h"
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    
    return deviceString;
    
}


/**
 手机号码 13[0-9],14[5|7|9],15[0-3],15[5-9],17[0|1|3|5|6|8],18[0-9]
 移动：134[0-8],13[5-9],147,15[0-2],15[7-9],178,18[2-4],18[7-8]
 联通：13[0-2],145,15[5-6],17[5-6],18[5-6]
 电信：133,1349,149,153,173,177,180,181,189
 虚拟运营商: 170[0-2]电信  170[3|5|6]移动 170[4|7|8|9],171 联通
 上网卡又称数据卡，14号段为上网卡专属号段，中国联通上网卡号段为145，中国移动上网卡号段为147，中国电信上网卡号段为149
 */
+(BOOL)isMobilePhone:(NSString *)phoneNum{
    
    NSString * MOBIL = @"^1(3[0-9]|4[579]|5[0-35-9]|7[01356]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if ([regextestmobile evaluateWithObject:phoneNum]) {
        return YES;
    }
    return NO;
}

+(BOOL)checkCarID:(NSString *)carID{
    
    if (carID.length!=7) {
        
        return NO;
    }
    
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carID];
    
    return YES;
}

#pragma mark    核对密码格式,6~24位数字/字母/下划线
+(BOOL)checkPsw:(NSString *)pswStr{
    
    NSString * pattern  =   @"^[A-Za-z0-9_]{6,24}$";
    //    NSString *condition =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    NSPredicate * pred  =   [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:pswStr];
}

//5. 判断字符串是否全为[(数字)OR(数字|字母)OR(字母)OR(汉字)]
//默认都为数字，1表示全部为字母，2表示数字和字母，3表示只能输入汉字
+(BOOL)isAllNumber:(NSString *)string type:(int)type{
    
//    condition = @"^[A-Za-z0-9]{6,16}$";//是否都是字母和数字且长度在[6,16]
    NSString *condition = @"^[0-9]*$";//是否都是数字
    
    if (1 == type) {
        condition = @"^[A-Za-z]+$";//是否都是字母
    }else if (2 == type){
        condition = @"^[A-Za-z0-9]+$";//是否都是字母和数字
    }else if (3 == type){
        condition = @"^[\u4e00-\u9fa5]{0,}$";//只能输入汉字
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",condition];
    return [predicate evaluateWithObject:string];
}
/*邮箱验证 MODIFIED BY HELENSONG*/
- (BOOL)isValidateEmail{
    
    if (self.length == 0) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$"];
    
    NSLog(@" === 邮箱 == 验证结果 == %d",[pred evaluateWithObject:self]);
    return [pred evaluateWithObject:self];
}
//是否符合拨打条件
- (BOOL)callNumber{
    
    //判断是否为手机号
    BOOL call = [NSString isMobilePhone:self];

    //非手机号，判断是否符合固定电话条件
    if (call == NO) {

        //获取截断“-”的值
        NSString *value = [self deleteSpecial:@"-"];

        call = [NSString isAllNumber:value type:0];
        
        if (call == YES) {
            
            //判断是包含划线
            if ([self isContainString:@"-"]) {
                
                if (self.length == 10 || self.length == 11) {
                    call = YES;
                }else{
                    call = NO;
                }
            }else{
                if (self.length == 7 || self.length == 8) {
                    call = YES;
                }else{
                    call = NO;
                }
            }
        }
    }
    //返回
    return call;
}
//获取网络状态
+(NSString *)getNetWorkStates{
    
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    
    NSString *state = @"";
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:{
                    state = @"无网络";
                }
                    break;
                case 1:{
                    state = @"2G";
                }
                    break;
                case 2:{
                    state = @"3G";
                }
                    break;
                case 3:{
                    state = @"4G";
                }
                    break;
                case 5:{
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
            
            //结束循环
            break;
        }
    }
    
    //返回网络状态
    return state;
}

@end
