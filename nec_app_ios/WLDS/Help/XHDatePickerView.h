//
//  XHDatePickerView.h
//  XHDatePicker
//
//  Created by XH_J on 2016/10/25.
//  Copyright © 2016年 XHJCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    DateStyleShowYearMonthDayHourMinute  = 0,//format = @"yyyy-MM-dd HH:mm";
    DateStyleShowMonthDayHourMinute,// format = @"MM-dd HH:mm";
    DateStyleShowYearMonthDay,//format = @"yyyy-MM-dd";
    DateStyleShowMonthDay,//format = @"MM-dd";
    DateStyleShowHourMinute//format = @"HH:mm";

    
}XHDateStyle;

typedef enum{
    DateTypeStartDate,
    DateTypeEndDate
    
}XHDateType;

@interface XHDatePickerView : UIView

//展示类型
@property (nonatomic) int type;

@property (nonatomic,assign) XHDateStyle datePickerStyle;

@property (nonatomic,assign)XHDateType dateType;

@property (nonatomic,strong)UIColor *themeColor;

@property (nonatomic, retain) NSDate *maxLimitDate;//限制最大时间（没有设置默认2049）
@property (nonatomic, retain) NSDate *minLimitDate;//限制最小时间（没有设置默认1970）

-(instancetype)initWithCompleteBlock:(void(^)(NSDate *,NSDate *))completeBlock;

/**
 *   设置打开选择器时的默认时间，
 *   minLimitDate < currentDate < maxLimitDate  显示 currentDate;
 *   currentDate < minLimitDate ||  currentDate > maxLimitDate   显示minLimitDate;
 */
-(instancetype)initWithCurrentDate:(NSDate *)currentDate CompleteBlock:(void(^)(NSDate *,NSDate *))completeBlock;

-(void)show;

@end
