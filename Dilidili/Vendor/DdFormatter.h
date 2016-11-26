//
//  DdFormatter.h
//  Dilidili
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief dilidili格式化输出
 */
@interface DdFormatter : NSObject

/**
 次数格式化

 @param count 次数
 @return 格式化字符串
 */
+ (NSString *)stringForCount:(NSUInteger)count;

/**
 媒体时间格式化

 @param time 时间
 @return 格式化字符串
 */
+ (NSString *)stringForMediaTime:(NSTimeInterval)time;

@end
