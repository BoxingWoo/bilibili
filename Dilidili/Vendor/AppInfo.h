//
//  AppInfo.h
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief App相关信息
 */
@interface AppInfo : NSObject


#pragma mark 应用信息

/**
 *  @brief App版本
 *
 *  @return App版本
 */
+ (NSString *)appVersion;

/**
 *  @brief App名称
 *
 *  @return App名称
 */
+ (NSString *)appName;

/**
 *  @brief 当前系统语言
 *
 *  @return 当前系统语言
 */
+ (NSString *)preferredLanguage;


#pragma mark 请求参数

/**
 *  @brief 请求键值
 */
+ (NSString *)actionKey;

/**
 *  @brief 应用键值
 */
+ (NSString *)appkey;

/**
 *  @brief 版本号
 */
+ (NSString *)appver;

/**
 *  @brief 编译号
 */
+ (NSString *)build;

/**
 *  @brief 频道
 */
+ (NSString *)channel;

/**
 *  @brief 设备
 */
+ (NSString *)device;

/**
 *  @brief 移动设备
 */
+ (NSString *)mobi_app;

/**
 *  @brief 平台
 */
+ (NSString *)plat;

/**
 *  @brief 平台系统
 */
+ (NSString *)platform;

/**
 *  @brief 签名
 *
 *  @param parameters 参数
 *  @param timeStamp  时间戳
 */
+ (NSString *)signParameters:(NSDictionary *)parameters byTimeStamp:(NSInteger)timeStamp;

/**
 *  @brief 时间戳
 */
+ (NSInteger)ts;

@end
