//
//  BSScreenAdaptation.h
//
//  Created by mac on 16/7/30.
//  Copyright (c) 2016年 BoxingWoo. All rights reserved.
//

//适配实现界面以iphone5s作为基准
#define DesignWidth 320.0
#define DesignHeight 568.0

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @brief 屏幕适配工具类
 */
@interface BSScreenAdaptation : NSObject

/**
 *  @brief 扩展函数适配Rect
 *
 *  @param x      x坐标
 *  @param y      y坐标
 *  @param width  宽
 *  @param height 高
 *
 *  @return CGRect
 */
CGRect CGRectMakeEx(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

/**
 *  @brief 扩展函数适配Size
 *
 *  @param width  宽
 *  @param height 高
 *
 *  @return CGSize
 */
CGSize CGSizeMakeEx(CGFloat width, CGFloat height);

/**
 *  @brief 扩展函数适配Point
 *
 *  @param x x坐标
 *  @param y y坐标
 *
 *  @return CGPoint
 */
CGPoint CGPointMakeEx(CGFloat x, CGFloat y);

/**
 *  @brief 拓展函数适配宽度
 *
 *  @param width 宽
 *
 *  @return CGFloat
 */
CGFloat widthEx(CGFloat width);

/**
 *  @brief 拓展函数适配高度
 *
 *  @param height 高
 *
 *  @return CGFloat
 */
CGFloat heightEx(CGFloat height);

@end
