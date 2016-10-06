//
//  UIScrollView+MultiViewControlExtension.h
//
//  Created by BoxingWoo on 15-7-23.
//  Copyright (c) 2015年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MultiViewControlExtension)

/** 同步滑动内容视图数组 */
@property (nonatomic, copy) NSArray *synScrollingContentViews;

/**
 *  @brief 居中式同步滑动方法
 *
 *  @param index    子控件索引
 *  @param pageSize 每页子控件数量
 */
- (void)centerSynScrollByIndexOfSubview:(NSInteger)index andPageSize:(NSInteger)pageSize;


/**
 *  @brief 两边式同步滑动方法
 *
 *  @param index     子控件索引
 *  @param itemSpace 子控件间隔
 */
- (void)edgeSynScrollByIndexOfSubview:(NSInteger)index andItemSpace:(CGFloat)itemSpace;

@end
