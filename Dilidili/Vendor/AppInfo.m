//
//  AppInfo.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

#pragma mark App版本
+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

#pragma mark App名称
+ (NSString *)appName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

#pragma mark 当前系统语言
+ (NSString *)preferredLanguage
{
    NSArray *allLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *preferredLanguage = allLanguages.firstObject;
    return preferredLanguage;
}

#pragma mark 是否允许推送
+ (BOOL)isAllowedNotification
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types != UIUserNotificationTypeNone) {
        return YES;
    }
    return NO;
}

#pragma mark 请求键值
+ (NSString *)actionKey
{
    return @"appkey";
}

#pragma mark 应用键值
+ (NSString *)appkey
{
    return @"27eb53fc9058f8c3";
}

#pragma mark 版本号
+ (NSString *)appver
{
    return @"3870";
}

#pragma mark 编译号
+ (NSString *)build
{
    return @"3870";
}

#pragma mark 标识号
+ (NSString *)buvid
{
    return @"E25A38CE-0436-44C9-AC81-7D82A7CDA6985936infoc";
}

#pragma mark 频道
+ (NSString *)channel
{
    return @"appstore";
}

#pragma mark 设备
+ (NSString *)device
{
    return @"phone";
}

#pragma mark 移动设备
+ (NSString *)mobi_app
{
    return @"iphone";
}

#pragma mark 平台
+ (NSString *)plat
{
    return @"1";
}

#pragma mark 平台系统
+ (NSString *)platform
{
    return @"ios";
}

#pragma mark 签名
+ (NSString *)sign
{
    return @"";
}

#pragma mark 时间戳
+ (NSInteger)ts
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return (NSInteger)timeInterval;
}

@end
