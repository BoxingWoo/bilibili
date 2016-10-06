//
//  DdDanmakuModel.h
//  Dilidili
//
//  Created by iMac on 2016/9/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdDanmakuUserDefaults.h"

/**
 弹幕模型
 */
@interface DdDanmakuModel : NSObject

/**
 弹幕ID
 */
@property (nonatomic, copy) NSString *danmuku_id;
/**
 弹幕媒体时间
 */
@property (nonatomic, assign) NSTimeInterval delay;
/**
 弹幕样式
 */
@property (nonatomic, assign) DdDanmakuStyle style;
/**
 弹幕文字
 */
@property (nonatomic, copy) NSString *text;
/**
 弹幕颜色值
 */
@property (nonatomic, assign) NSInteger textColorValue;
/**
 弹幕颜色
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 弹幕字体大小
 */
@property (nonatomic, assign) CGFloat fontSize;
/**
 弹幕创建时间
 */
@property (nonatomic, assign) NSTimeInterval ctime;

@end
