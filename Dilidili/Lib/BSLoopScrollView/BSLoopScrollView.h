//
//  BSLoopScrollView.h
//  BSLoopScrollViewDemo
//
//  Created by BoxingWoo on 15/10/28.
//  Copyright © 2015年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 循环滚动视图页面控制位置
 */
typedef NS_ENUM(NSInteger, BSPageControlPosition) {
    BSPageControlPositionNone = 0,  // 不显示页面控制
    BSPageControlPositionLeft = 1,  // 左下
    BSPageControlPositionMiddle = 2,  // 中间
    BSPageControlPositionRight = 3  // 右下
};

@protocol BSLoopScrollViewDataSource;
@protocol BSLoopScrollViewDelegate;
/**
 *  @brief 循环滚动视图
 */
@interface BSLoopScrollView : UIView

/** 数据源 */
@property (nonatomic, weak) IBOutlet id<BSLoopScrollViewDataSource> dataSource;
/** 代理 */
@property (nonatomic, weak) IBOutlet id<BSLoopScrollViewDelegate> delegate;
/** 内容视图数组 */
@property (nonatomic, copy, readonly) NSArray *contentViews;
/** 页面控制位置，默认为BSPageControlPositionNone */
@property (nonatomic, assign) IBInspectable NSInteger pageControlPosition;
/** 页面控制指示点颜色 */
@property (nonatomic, strong) IBInspectable UIColor *pageIndicatorTintColor;
/** 页面控制当前指示点颜色 */
@property (nonatomic, strong) IBInspectable UIColor *currentPageIndicatorTintColor;
/** 自动滚动时间间隔，如果<=0或内容视图数量=1，不自动滚动，默认为0 */
@property (nonatomic, assign) IBInspectable double autoScrollDuration;
/** 内容视图是否响应触摸事件，默认为YES */
@property (nonatomic, assign) IBInspectable BOOL shouldAllowTouch;


/**
 *  @brief 加载数据
 */
- (void)reloadData;

@end

/**
 *  @brief 循环滚动视图数据源协议
 */
@protocol BSLoopScrollViewDataSource <NSObject>
@required

/**
 *  @brief 内容视图数量，如果<=1，禁用滚动
 *
 *  @param loopScrollView 循环滚动视图
 *
 *  @return 内容视图数量
 */
- (NSUInteger)numberOfItemsInLoopScrollView:(BSLoopScrollView *)loopScrollView;

/**
 *  @brief 内容视图
 *
 *  @param loopScrollView 循环滚动视图
 *  @param index          索引
 *
 *  @return 内容视图
 */
- (UIView *)loopScrollView:(BSLoopScrollView *)loopScrollView contentViewAtIndex:(NSUInteger)index;

@end

/**
 *  @brief 循环滚动视图代理协议
 */
@protocol BSLoopScrollViewDelegate <NSObject>
@optional

/**
 *  @brief 触摸内容视图代理方法
 *
 *  @param loopScrollView 循环滚动视图
 *  @param contentView    内容视图
 *  @param index          索引
 */
- (void)loopScrollView:(BSLoopScrollView *)loopScrollView didTouchContentView:(UIView *)contentView atIndex:(NSUInteger)index;

/**
 *  @brief 循环滚动停止手动滚动代理方法
 *
 *  @param loopScrollView 循环滚动视图
 *  @param index          索引
 */
- (void)loopScrollViewDidEndDecelerating:(BSLoopScrollView *)loopScrollView atIndex:(NSUInteger)index;

@end
