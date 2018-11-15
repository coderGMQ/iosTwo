//
//  NSDate+category.h
//  BQBusiness
//
//  Created by xhl on 16/5/30.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (category)


//计算距离今天多少天以前的时间
+ (NSString *)beforeSineNow:(NSInteger)days;

//根据格式获取
+ (NSString *)beforeSineNow:(NSInteger)days formatter:(NSString *)formatter;

//计算距离今天多少天以后的时间
+ (NSString *)afterSineNow:(NSInteger)days;

//计算距离今天多少天以后的时间 (自定义格式)
+ (NSString *)afterSineNow:(NSInteger)days  formatter:(NSString *)formatter;

//获取当前的时间 @"YYYY-MM-dd HH:mm:ss"
+(NSString *)getCurrentTimeWithFormat:(NSString *)format;

//当前时间属于一周的周几
+ (NSInteger)checkWeekdayForNow;

//距离今天的某个时间间隔的
+ (NSDictionary *)getDateWithTimeIntervalSinceNow:(NSTimeInterval)time;

//距离今天的某个时间间隔的(向前或者向后)
+ (NSArray *)getDaysWithCount:(NSInteger)count after:(BOOL)after;

//根据具体的某一天查看属于一周的周几
+ (NSInteger)checkWeekdayWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;

//根据年月日检索日期属性
+ (NSDictionary *)getDateWithDay:(NSInteger)days month:(NSInteger)months year:(NSInteger)years;

//根据一个日期获取日期属性对象
+ (NSDictionary *)getDateObjectWithDate:(NSDate *)date;

//获取当前时间（包含在内的）一周时间
+ (NSArray *)getTheCurrentDateOfTheWeek;

//将美国一周的样式转换成中国的样式
+ (NSString *)chineseWeek:(NSInteger)week;

//根据字符创获取时间（string：2014-01-01）
+ (NSDate *)gainDateWithString:(NSString *)string;

//根据秒钟计算时间戳
+ (NSDictionary*)changeDateString:(NSString *)second;

//根据时间戳的格式，将时间转换成字符串 @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)dateForString:(NSDate *)date format:(NSString *)format;


//比较时间戳的间隔(精确到秒)
+ (double)timeInterval:(NSString *)one other:(NSString *)other;

////比较时间戳的间隔(精确到毫秒)
//+ (double)timeMsecInterval:(NSString *)one other:(NSString *)other;

+ (NSString *)timeWithSecond:(NSInteger)second format:(NSString *)format;

//计时格式
+ (NSString *)timeWithSecond:(NSInteger)time;

//转换日期格式
+ (NSString *)calculateChineseWeek:(NSString *)date;
@end
