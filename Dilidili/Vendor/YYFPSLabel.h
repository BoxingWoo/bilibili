//
//  YYFPSLabel.h
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 帧速率标签
 */
@interface YYFPSLabel : UILabel

/**
 单例方法

 @return 单例对象
 */
+ (instancetype)sharedFPSLabel;

/**
 展示
 */
+ (void)show;

/**
 移除
 */
+ (void)dismiss;

@end
