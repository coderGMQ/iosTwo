//
//  NSDate+category.m
//  BQBusiness
//
//  Created by xhl on 16/5/30.
//  Copyright © 2016年 xhl. All rights reserved.


#import "NSDate+category.h"

@implementation NSDate (category)

//计算距离今天多少天以后的时间
+ (NSString *)afterSineNow:(NSInteger)days{
   
    //现在的时间
    NSDate *nowDate = [NSDate date];
    
    //1天的长度长度
    NSTimeInterval oneDay = 24 * 60 * 60;
    //之后的天数
    NSDate *theDate = [nowDate initWithTimeIntervalSinceNow: + oneDay * days ];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    NSString * currentDateStr = [dateFormatter stringFromDate:theDate];
    
    return [currentDateStr stringByAppendingString:@" 23:59:59"];
}

//计算距离今天多少天以后的时间 (自定义格式)
+ (NSString *)afterSineNow:(NSInteger)days  formatter:(NSString *)formatter{
    
    //现在的时间
    NSDate *nowDate = [NSDate date];
    
    //1天的长度长度
    NSTimeInterval oneDay = 24 * 60 * 60;
    //之后的天数
    NSDate *theDate = [nowDate initWithTimeIntervalSinceNow: + oneDay * days ];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter stringFromDate:theDate];
}

//计算距离今天多少天以前的时间
+ (NSString *)beforeSineNow:(NSInteger)days{
    
    //现在的时间
    NSDate*nowDate = [NSDate date];

    //1天的长度长度
    NSTimeInterval oneDay = 24 * 60 * 60;

    //之前的天数
    NSDate* theDate = [nowDate initWithTimeIntervalSinceNow: - oneDay * days ];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    NSString * currentDateStr = [dateFormatter stringFromDate:theDate];
    
    return [currentDateStr stringByAppendingString:@" 00:00:00"];
}

//计算距离今天多少天以前的时间
+ (NSString *)beforeSineNow:(NSInteger)days formatter:(NSString *)formatter{
    
    //现在的时间
    NSDate*nowDate = [NSDate date];
    
    //1天的长度长度
    NSTimeInterval oneDay = 24 * 60 * 60;
    
    //之前的天数
    NSDate* theDate = [nowDate initWithTimeIntervalSinceNow: - oneDay * days ];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    
    //用[NSDate date]可以获取系统当前时间
    
    return [dateFormatter stringFromDate:theDate];
}

//获取当前的时间 @"YYYY-MM-dd HH:mm:ss"
+(NSString *)getCurrentTimeWithFormat:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:format];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
    
}


/*
 *
 *   time为距离【现在这一时刻时间】的时间间隔（CGFloat型）需要计算精确计算好
 *   time = 0时表示 获取的是当天的日期对象
 *
 ****/
//距离今天的某个时间间隔的
+ (NSDictionary *)getDateWithTimeIntervalSinceNow:(NSTimeInterval)time{
    
    //    time为距离【现在这一时刻时间】的时间间隔（CGFloat型）需要计算精确计算好
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:time];
    
    //获取时间对象
    return   [NSDate getDateObjectWithDate:now];
}

/*
 * count:表示所取天数
 * isAfter 为YES 则表示距离当前时间向后延续count天日期 为NO，则表示距离当前时间向前获取count天日期
 * 返回的NSArray这表示，存放已经获取的日期对象
 *
 **/
//距离今天的某个时间间隔的
+ (NSArray *)getDaysWithCount:(NSInteger)count after:(BOOL)after{
    //
    NSMutableArray *needArray = [[NSMutableArray alloc] init];
    
    NSInteger time = 0;
    
    for (int i = 0; i < count; i++) {
        
        
        if (after == YES) {
            
            time = time + 86400;
            
        }else{
            
            time = time - 86400;
        }
        
        //转换成时间
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:time];

        //获取时间对象
       NSDictionary *dict=  [NSDate getDateObjectWithDate:now];
        
        if (after == YES) {

            [needArray addObject:dict];
            
        }else{
            
            [needArray insertObject:dict atIndex:0];
        }
        
    }
    
    return needArray;
    
}


//当前时间属于一周的周几
+ (NSInteger)checkWeekdayForNow{

    NSCalendar *gregorian = [NSCalendar  currentCalendar];
    
    NSDate *date = [NSDate date];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    
    return [weekdayComponents weekday];
}

//根据具体的某一天查看属于一周的周几
+ (NSInteger)checkWeekdayWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year{
    
    //1-7 对应 周日-周六
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:day];
    
    [components setMonth:month];
    
    [components setYear:year];
    
    NSCalendar *gregorian = [NSCalendar  currentCalendar];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    
    return [weekdayComponents weekday];
}



//根据年月日检索日期属性
+ (NSDictionary *)getDateWithDay:(NSInteger)days month:(NSInteger)months year:(NSInteger)years{
    //1-7 对应 周日-周六
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:days];
    
    [components setMonth:months];
    
    [components setYear:years];
    
    NSCalendar *gregorian = [NSCalendar  currentCalendar];
    
    NSDate *now = [gregorian dateFromComponents:components];
    
    return [NSDate getDateObjectWithDate:now];

}


//根据一个日期获取日期属性对象
+ (NSDictionary *)getDateObjectWithDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //选择市区
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitWeekday;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [dateComponent year];
    
    NSInteger month = [dateComponent month];
    
    NSInteger day = [dateComponent day];
    
    NSInteger weekday = [dateComponent weekday];
    
    NSString *monthStr = @"";
    
    NSString *dayStr = @"";
    
    if (month < 10) {
        
        monthStr = [NSString stringWithFormat:@"0%ld",(long)month];
        
    }else{
        
        monthStr = [NSString stringWithFormat:@"%ld",(long)month];
    }
    
    if (day < 10) {
        
        dayStr = [NSString stringWithFormat:@"0%ld",(long)day];
    }else{
        
        dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    }
    
    //周天转换
    NSString *weekStr = [NSDate chineseWeek:weekday];

    //获取对象
    NSDictionary *dict = @{@"year":[NSString stringWithFormat:@"%ld",(long)year],@"month":monthStr,@"day":dayStr,@"month_day":[NSString stringWithFormat:@"%@-%@",monthStr,dayStr],@"year_month_day":[NSString stringWithFormat:@"%ld-%@-%@",(long)year,monthStr,dayStr],@"weekday":weekStr,@"week":[NSString stringWithFormat:@"%ld",weekday]};
    
    return dict;
    
}

//获取当前时间（包含在内的）一周时间
+ (NSArray *)getTheCurrentDateOfTheWeek{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDictionary *today = [NSDate getDateWithTimeIntervalSinceNow:0];
    
    NSInteger beforeDays = 0;
    
    NSInteger week = [DICT_QUERY(today, @"week") integerValue];
    
    switch (week) {
        case 1:
        {//周日
            
            [array addObjectsFromArray:[NSDate getDaysWithCount:6 after:YES]];
            
        }
            break;
        case 2:
        {//周一
            beforeDays = 1;
        }
            break;
        case 3:
        {//周二
            beforeDays = 2;
        }
            break;
        case 4:
        {//周三
            beforeDays = 3;
        }
            break;
        case 5:
        {//周四
            beforeDays = 4;
        }
            break;
        case 6:
        {//周五
            beforeDays = 5;
        }
            break;
        case 7:
        {//周六
            [array addObjectsFromArray:[NSDate getDaysWithCount:6 after:NO]];
        }
            break;
            
        default:
            break;
    }
    
    if (beforeDays > 0) {
        
        [array addObjectsFromArray:[NSDate getDaysWithCount:beforeDays after:NO]];
        [array addObjectsFromArray:[NSDate getDaysWithCount:(6 - beforeDays) after:YES]];
    }
    
    [array insertObject:today atIndex:week - 1];
    
    return array;
    
}

//将美国一周的样式转换成中国的样式
+ (NSString *)chineseWeek:(NSInteger)week{
    
    NSString *weekStr = @"";
    switch (week) {
        case 1:
        {
            weekStr = @"星期日";
        }
            break;
        case 2:
        {
            weekStr = @"星期一";
        }
            break;
        case 3:
        {
            weekStr = @"星期二";
        }
            break;
        case 4:
        {
            weekStr = @"星期三";
        }
            break;
        case 5:
        {
            weekStr = @"星期四";
        }
            break;
        case 6:
        {
            weekStr = @"星期五";
        }
            break;
        case 7:
        {
            weekStr = @"星期六";
        }
            break;
            
        default:
            break;
    }
    
    return weekStr;
}

//根据字符串获取时间(2014-01-01)
+ (NSDate *)gainDateWithString:(NSString *)string{
    if (![string isContainString:@":"]) {
        string = [NSString stringWithFormat:@"%@ 00:00:00",string];
    }
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    inputFormatter.timeZone = [NSTimeZone localTimeZone];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *inputDate = [inputFormatter dateFromString:string];
    
    return inputDate;
}

/*
 * @ 时间转换 （秒钟）
 *
 */
+ (NSDictionary*)changeDateString:(NSString *)second{
    
     NSDate *date = [NSDate dateWithTimeIntervalSince1970:[second doubleValue]/1000];
    
    return [NSDate getDateObjectWithDate:date];
}


//根据时间戳的格式，将时间转换成字符串 @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)dateForString:(NSDate *)date format:(NSString *)format{
    
    NSDateFormatter *dFT = [[NSDateFormatter alloc] init];//格式化
    
    [dFT setDateFormat:format];
    
    NSString * timeStr = [dFT stringFromDate:date];
    
    return  timeStr;
}

+ (NSString *)timeWithSecond:(NSInteger)second format:(NSString *)format{
    
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:second];

    NSDateFormatter *dFT = [[NSDateFormatter alloc] init];//格式化
    
    [dFT setDateFormat:format];
    
    NSString * timeStr = [dFT stringFromDate:date];
    
    return  timeStr;
}

//比较时间戳的间隔
+ (double)timeInterval:(NSString *)one other:(NSString *)other{
    //创建日期格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //制定时间戳格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //判断时间戳的长度
    if (one.length < 12) {
        
        one = [NSString stringWithFormat:@"%@ 00:00:00",one];
    }
    //时间戳转换
    NSDate *firstDate = [formatter dateFromString:one];

    
    //判断时间戳的长度
    if (other.length < 12) {
        
        other = [NSString stringWithFormat:@"%@ 00:00:00",other];
    }
    
    //时间戳转换
    NSDate *nextDate = [formatter dateFromString:other];
    
    //计算2个时间戳的时间差值
    NSTimeInterval timeInterval = [firstDate timeIntervalSinceDate:nextDate];
    
    return timeInterval;
}

//比较时间戳的间隔(精确到毫秒)
//+ (double)timeMsecInterval:(NSString *)one other:(NSString *)other{
//    //创建日期格式
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    //制定时间戳格式
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss:sss"];
//    
//    //判断时间戳的长度
//    if (one.length < 12) {
//        
//        one = [NSString stringWithFormat:@"%@ 00:00:00:000",one];
//    }
//    //时间戳转换
//    NSDate *firstDate = [formatter dateFromString:one];
//    
//    
//    //判断时间戳的长度
//    if (other.length < 12) {
//        
//        other = [NSString stringWithFormat:@"%@ 00:00:00:000",other];
//    }
//    
//    //时间戳转换
//    NSDate *nextDate = [formatter dateFromString:other];
//    
//    //计算2个时间戳的时间差值
//    NSTimeInterval timeInterval = [firstDate timeIntervalSinceDate:nextDate];
//    //    
//    return timeInterval;
//}

//计时格式
+ (NSString *)timeWithSecond:(NSInteger)time{
 
    int days = time / (24.0 * 60 * 60);
    
    int hours = (time - days * (24.0 * 60 * 60))/3600;
    
    int minute = (time - days * (24.0 * 60 * 60) - hours * (60 * 60))/60;
    
    int second = (time - days * (24.0 * 60 * 60) - hours * (60 * 60) - minute * 60 );

    NSString *needMinuteStr = @"";
    NSString *needSecondStr = @"";
    
    //分钟
    if (minute < 10) {
        
        needMinuteStr = [NSString stringWithFormat:@"0%i",minute];
        
    }else {
        
        needMinuteStr = [NSString stringWithFormat:@"%i",minute];
    }
    
    //秒
    if (second < 10) {
        
        needSecondStr = [NSString stringWithFormat:@"0%i",second];
        
    }else {
        
        needSecondStr = [NSString stringWithFormat:@"%i",second];
    }

   
   return [NSString stringWithFormat:@"%@ : %@",needMinuteStr,needSecondStr];
}

/***********************************************************************
 * 方法名称： calculateWeek
 * 功能描述： 将日期（NSDate）转换成(NSString)格式
 * 输入参数：
 * 输出参数：
 * 返 回 值：
 * 其它说明：
 ***********************************************************************/
+ (NSString *)calculateChineseWeek:(NSString *)date{
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//
//    [inputFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//
//    NSDate *formatterDate = [inputFormatter dateFromString:date];
//
//    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
//
//    NSString *weekFormal = [inputFormatter stringFromDate:formatterDate];
    
    if (date.length > 10) {
        
        date = [date substringToIndex:10];
    }
    
    return date;
}

@end
