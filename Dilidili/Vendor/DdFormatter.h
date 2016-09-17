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

+ (NSString *)stringForCount:(NSUInteger)count;

+ (NSString *)stringForMediaTime:(NSTimeInterval)time;

@end
