//
//  MyCustomLogFormatter.m
//  Bosum
//
//  Created by BoxingWoo on 15/11/18.
//  Copyright © 2015年 BoxingWoo. All rights reserved.
//

#import "MyCustomLogFormatter.h"

@implementation MyCustomLogFormatter

#pragma mark 日志输出格式
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel = nil;
    switch (logMessage.flag)
    {
        case DDLogFlagError:
            logLevel = @"[ERROR] > ";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]  > ";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]  > ";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG] > ";
            break;
        default:
            logLevel = @"[VBOSE] > ";
            break;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@%@",
                           logLevel, logMessage.message];
    return formatStr;
}

@end
