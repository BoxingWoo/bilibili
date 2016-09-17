//
//  BSTimeCalculate.m
//  BSTimeCalculate
//
//  Created by iMac on 16/3/2.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BSTimeCalculate.h"

@implementation BSTimeCalculate

#pragma mark 获取当前本地时间
+ (NSDate *)localDate
{
    return [[NSDate date] dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];
}

#pragma mark 获取本地时间
+ (NSDate *)localDateWithTimeInterval:(NSTimeInterval)timeInterval
{
    return [[NSDate dateWithTimeIntervalSince1970:timeInterval] dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];
}

#pragma mark 获取本地时间
+ (NSDate *)localDateWithDateFormatString:(NSString *)dateFormatStr style:(BSDateFormatStyle)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (style == BSDateFormatDescription) {
        NSAssert(NO, @"Unsupported format style!");
    }else if (style == BSDateFormatDefault) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if (style == BSDateFormatShort) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *date = [dateFormatter dateFromString:dateFormatStr];
    return [date dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];
}

#pragma mark 获取本地时间格式化字符串
+ (NSString *)localDateFormatStringWithDate:(NSDate *)date style:(BSDateFormatStyle)style
{
    return [self localDateFormatStringWithTimeInterval:[self timeIntervalWithDate:date] style:style];
}

#pragma mark 获取本地时间格式化字符串
+ (NSString *)localDateFormatStringWithTimeInterval:(NSTimeInterval)timeInterval style:(BSDateFormatStyle)style
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if (style == BSDateFormatDescription) {
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date toDate:[NSDate date] options:0];
        NSString *dateContent = nil;
        
        if (dateComponents.month != 0) {
            dateContent = [NSString stringWithFormat:@"%li个月前", (long)dateComponents.month];
        }else if (dateComponents.day != 0) {
            dateContent = [NSString stringWithFormat:@"%li天前", (long)dateComponents.day];
        }else if (dateComponents.hour != 0) {
            dateContent = [NSString stringWithFormat:@"%li小时前", (long)dateComponents.hour];
        }else if (dateComponents.minute != 0) {
            dateContent = [NSString stringWithFormat:@"%li分钟前", (long)dateComponents.minute];
        }else {
            dateContent = @"刚刚";
        }
        return dateContent;
        
    }else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (style == BSDateFormatDefault) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }else if (style == BSDateFormatShort) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        return [dateFormatter stringFromDate:date];
    }
}

#pragma mark 获取时间戳
+ (NSTimeInterval)timeIntervalWithDate:(NSDate *)date
{
    date = [date dateByAddingTimeInterval:-[[NSTimeZone systemTimeZone] secondsFromGMT]];
    return [date timeIntervalSince1970];
}

#pragma mark 获取时间戳
+ (NSTimeInterval)timeIntervalWithDateFormatString:(NSString *)dateFormatStr style:(BSDateFormatStyle)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (style == BSDateFormatDescription) {
        NSAssert(NO, @"Unsupported format style!");
    }else if (style == BSDateFormatDefault) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if (style == BSDateFormatShort) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *date = [dateFormatter dateFromString:dateFormatStr];
    return [date timeIntervalSince1970];
}

#pragma mark 获取倒计时时间组合
+ (NSDateComponents *)countDownDateComponentsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *currentDate = [NSDate date];
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:currentDate toDate:endDate options:0];
}

@end
