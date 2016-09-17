//
//  BSCentralButton.h
//  BSTabBarDemo
//
//  Created by BoxingWoo on 15/8/9.
//  Copyright (c) 2015年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 图文垂直居中分布按钮
 */
@interface BSCentralButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat contentSpace;

/**
 *  @brief 类构造方法
 *
 *  @param buttonType 按钮类型
 *  @param space      图文间距
 *
 *  @return 按钮实例
 */
+ (id)buttonWithType:(UIButtonType)buttonType andContentSpace:(CGFloat)space;

/**
 *  @brief 快速构造方法
 *
 *  @param frame  位置和大小
 *  @param space  图文间隔
 *  @param target 目标
 *  @param action 点击响应事件
 *
 *  @return 按钮实例
 */
- (instancetype)initWithFrame:(CGRect)frame andContentSpace:(CGFloat)space target:(id)target action:(SEL)action;

@end
