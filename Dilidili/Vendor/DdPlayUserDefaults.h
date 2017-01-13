//
//  DdPlayUserDefaults.h
//  Dilidili
//
//  Created by iMac on 2016/12/28.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 播放设置
 */
@interface DdPlayUserDefaults : NSObject

/**
 是否激活后台播放
 */
@property (nonatomic, assign) BOOL activeBackgroundPlayback;

/**
 单例方法
 
 @return 弹幕设置单例
 */
+ (instancetype)sharedInstance;

@end
