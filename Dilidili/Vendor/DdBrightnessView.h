//
//  DdBrightnessView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/23.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 dilidili亮度视图
 */
@interface DdBrightnessView : UIVisualEffectView

/**
 单例方法

 @return 单例对象
 */
+ (instancetype)sharedBrightnessView;

/**
 展示
 */
+ (void)show;

/**
 移除

 @param animate 是否使用动画
 */
+ (void)hide:(BOOL)animate;

@end
