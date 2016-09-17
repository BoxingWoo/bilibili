//
//  BSTimeCalculate.h
//  BSTimeCalculate
//
//  Created by iMac on 16/3/2.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 时间格式化类型
 */
typedef NS_ENUM(NSInteger, BSDateFormatStyle) {
    BSDateFormatDefault = 0,  //默认，完整型(2016-01-01 00:00:00)
    BSDateFormatShort,  //短型(2016-01-01)
    BSDateFormatDescription  //描述型(5分钟前、8小时前、10天前、2个月前)
};

/**
 *  @brief 日期、时间计算类
 */
@interface BSTimeCalculate : NSObject

/**
 *  @brief 获取当前本地时间
 *
 *  @return 当前本地时间
 */
+ (NSDate *)localDate;

/**
 *  @brief 获取本地时间
 *
 *  @param timeInterval 时间戳
 *
 *  @return 本地时间
 */
+ (NSDate *)localDateWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  @brief 获取本地时间
 *
 *  @param dateFormatStr 本地时间格式字符串
 *  @param style         时间格式化类型（不支持BSDateFormatDescription类型）
 *
 *  @return 本地时间
 */
+ (NSDate *)localDateWithDateFormatString:(NSString *)dateFormatStr style:(BSDateFormatStyle)style;

/**
 *  @brief 获取本地时间格式化字符串
 *
 *  @param date  本地时间
 *  @param style 时间格式化类型
 *
 *  @return 本地时间格式化字符串
 */
+ (NSString *)localDateFormatStringWithDate:(NSDate *)date style:(BSDateFormatStyle)style;

/**
 *  @brief 获取本地时间格式化字符串
 *
 *  @param timeInterval 时间戳
 *  @param style        时间格式化类型
 *
 *  @return 本地时间格式化字符串
 */
+ (NSString *)localDateFormatStringWithTimeInterval:(NSTimeInterval)timeInterval style:(BSDateFormatStyle)style;

/**
 *  @brief 获取时间戳
 *
 *  @param date 本地时间
 *
 *  @return 时间戳
 */
+ (NSTimeInterval)timeIntervalWithDate:(NSDate *)date;

/**
 *  @brief 获取时间戳
 *
 *  @param dateFormatStr 本地时间格式字符串
 *  @param style         时间格式化类型（不支持BSDateFormatDescription类型）
 *
 *  @return 时间戳
 */
+ (NSTimeInterval)timeIntervalWithDateFormatString:(NSString *)dateFormatStr style:(BSDateFormatStyle)style;

/**
 *  @brief 获取倒计时时间组合
 *
 *  @param timeInterval 时间戳
 *
 *  @return 时间组合
 */
+ (NSDateComponents *)countDownDateComponentsWithTimeInterval:(NSTimeInterval)timeInterval;

@end

