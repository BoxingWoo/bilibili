//
//  DdDanmakuUserDefaults.h
//  Dilidili
//
//  Created by iMac on 2016/9/26.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BarrageDescriptor;

/**
 弹幕样式
 
 - DdDanmakuWalkR2L:     过场，从右到左
 - DdDanmakuWalkL2R:     过场，从左到右
 - DdDanmakuFloatCenter: 悬浮，居中
 - DdDanmakuFloatBottom: 悬浮，底部
 - DdDanmakuFloatTop:    悬浮，顶部
 */
typedef NS_ENUM(NSInteger, DdDanmakuStyle) {
    DdDanmakuWalkR2L = 1,
    DdDanmakuWalkL2R = 2,
    DdDanmakuFloatCenter = 3,
    DdDanmakuFloatBottom = 4,
    DdDanmakuFloatTop = 5
};

/**
 弹幕颜色
 
 - DdDanmakuWhite:   白色
 - DdDanmakuPurple:  紫色
 - DdDanmakuBule:    蓝色
 - DdDanmakuMagenta: 粉色
 - DdDanmakuCyan:    青色
 - DdDanmakuGreen:   绿色
 - DdDanmakuYellow:  黄色
 - DdDanmakuRed:     红色
 */
typedef NS_ENUM(NSInteger, DdDanmakuColor) {
    DdDanmakuPurple = 6830715,
    DdDanmakuBule = 11890,
    DdDanmakuMagenta = 14811775,
    DdDanmakuCyan = 41194,
    DdDanmakuGreen = 38979,
    DdDanmakuYellow = 16707842,
    DdDanmakuRed = 15138834,
    DdDanmakuWhite = 16777215
};

/**
 弹幕字体大小
 
 - DdDanmakuFontSizeNormal: 正常字号
 - DdDanmakuFontSizeSmall:  小字号
 */
typedef NS_ENUM(NSInteger, DdDanmakuFontSize) {
    DdDanmakuFontSizeNormal = 25,
    DdDanmakuFontSizeSmall = 18
};

/**
 弹幕屏蔽选项
 
 - DdDanmakuShieldingNone:        不屏蔽
 - DdDanmakuShieldingFloatTop:    屏蔽顶部
 - DdDanmakuShieldingFloatBottom: 屏蔽底部
 - DdDanmakuShieldingWalk:        屏蔽过场
 - DdDanmakuShieldingColorful:    屏蔽彩色
 - DdDanmakuShieldingVisitor:     屏蔽游客
 */
typedef NS_ENUM(NSInteger, DdDanmakuShieldingOption) {
    DdDanmakuShieldingNone = 0,
    DdDanmakuShieldingFloatTop = 1 << 0,
    DdDanmakuShieldingFloatBottom = 1 << 1,
    DdDanmakuShieldingWalk = 1 << 2,
    DdDanmakuShieldingColorful = 1 << 3,
    DdDanmakuShieldingVisitor = 1 << 4,
};

/**
 弹幕设置
 */
@interface DdDanmakuUserDefaults : NSObject

/**
 弹幕屏蔽选项
 */
@property (nonatomic, assign) DdDanmakuShieldingOption shieldingOption;
/**
 同屏最大弹幕数
 */
@property (nonatomic, assign) NSUInteger screenMaxlimit;
/**
 弹幕速度
 */
@property (nonatomic, assign) CGFloat speed;
/**
 弹幕透明度
 */
@property (nonatomic, assign) CGFloat opacity;

/**
 弹幕偏好字体大小
 */
@property (nonatomic, assign) DdDanmakuFontSize preferredFontSize;
/**
 弹幕偏好样式
 */
@property (nonatomic, assign) DdDanmakuStyle preferredStyle;
/**
 弹幕偏好文本颜色值
 */
@property (nonatomic, assign) DdDanmakuColor preferredTextColorValue;
/**
 弹幕偏好文本颜色
 */
@property (nonatomic, strong, readonly) UIColor *preferredTextColor;

/**
 单例方法

 @return 弹幕设置单例
 */
+ (instancetype)sharedInstance;

/**
 获取按偏好的弹幕描述模型

 @param text 弹幕文字

 @return 弹幕描述模型实例
 */
- (BarrageDescriptor *)preferredDanmakuDescriptorWithText:(NSString *)text;

@end
