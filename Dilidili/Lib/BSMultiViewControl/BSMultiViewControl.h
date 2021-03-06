//
//  BSMultiViewControl.h
//
//  Created by BoxingWoo on 15/6/27.
//  Copyright (c) 2015年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSMultiViewControlButtonCell.h"

/**
 *  @brief 复合视图控制器样式
 */
typedef NS_ENUM(NSInteger, BSMultiViewControlStyle) {
    BSMultiViewControlFixedSpace = 0,  //横向固定按钮间距式
    BSMultiViewControlFixedPageSize,  //横向固定每页按钮个数式
    BSMultiViewControlVertical  //竖向列表式
};

@protocol BSMultiViewControlDataSource;
@protocol BSMultiViewControlDelegate;
/**
 *  @brief 复合视图控制器
 */
@interface BSMultiViewControl : UIView

/** 数据源 */
@property (nonatomic, weak) IBOutlet id<BSMultiViewControlDataSource> dataSource;

/** 代理 */
@property (nonatomic, weak) IBOutlet id<BSMultiViewControlDelegate> delegate;

/** 父视图控制器 */
@property (nonatomic, weak) IBOutlet UIViewController *parentViewController;

/** 子视图控制器数组 */
@property (nonatomic, copy, readonly) NSArray <UIViewController *> *viewControllers;

/** 标题按钮数组 */
@property (nonatomic, copy, readonly) NSArray <UIButton *> *buttons;

/** 复合视图控制器样式 */
@property (nonatomic, assign) IBInspectable NSInteger style;

/** 标题选中态索引 */
@property (nonatomic, assign) IBInspectable NSUInteger selectedIndex;

/** 标题栏背景颜色 */
@property (nonatomic, strong) IBInspectable UIColor *listBarBackgroundColor;

/** 标题栏宽度 */
@property (nonatomic, assign) IBInspectable CGFloat listBarWidth;

/** 标题栏高度 */
@property (nonatomic, assign) IBInspectable CGFloat listBarHeight;


/* 横向滚动式 */
/** 按钮间距，用于横向固定按钮间距式风格，默认值为12.0 */
@property (nonatomic, assign) IBInspectable CGFloat fixedSpace;

/** 每页按钮个数，用于横向固定每页按钮个数式风格，默认值为5 */
@property (nonatomic, assign) IBInspectable NSUInteger fixedPageSize;

/** 标题选中态下划线颜色，用于横向滚动式风格，默认为不填充颜色，即不显示 */
@property (nonatomic, strong) IBInspectable UIColor *selectedButtonBottomLineColor;

/** 是否显示标题栏与内容滚动视图的分割线，用于横向滚动式风格，默认为YES */
@property (nonatomic, assign) IBInspectable BOOL showSeparatedLine;

/** 是否显示下拉标题框，用于横向滚动式风格，默认为NO */
@property (nonatomic, assign) IBInspectable BOOL showButtonListBox;

/** 是否允许标题栏滚动视图弹簧效果，用于横向滚动式风格，默认为YES */
@property (nonatomic, assign) IBInspectable BOOL bounces;

/** 是否允许内容滚动视图滚动，用于横向滚动式风格，默认为YES */
@property (nonatomic, assign) IBInspectable BOOL scrollEnabled;


/* 竖向滚动式 */
/** 标题按钮单元格数组，用于竖向列表式风格 */
@property (nonatomic, copy, readonly) NSArray <BSMultiViewControlButtonCell *> *buttonCells;

/** 标题单元格高度，用于竖向列表式风格，默认值为44.0 */
@property (nonatomic, assign) IBInspectable CGFloat buttonCellRowHeight;

/** 标题单元格线条颜色，用于竖向滚动式风格，默认为浅灰色 */
@property (nonatomic, strong) IBInspectable UIColor *buttonCellLineColor;

/** 标题选中态单元格线条颜色，用于竖向滚动式风格，默认为浅灰色 */
@property (nonatomic, strong) IBInspectable UIColor *selectedButtonCellLineColor;


/**
 *  @brief 构造方法
 *
 *  @param frame                位置与大小
 *  @param style                复合视图控制器样式
 *  @param parentViewController 父视图控制器
 */
- (instancetype)initWithFrame:(CGRect)frame andStyle:(BSMultiViewControlStyle)style owner:(UIViewController *)parentViewController;

/**
 *  @brief 重新加载数据
 */
- (void)reloadData;

/**
 更新视图

 @param duration   动画时间，如果为0则不使用动画
 @param updates    更新内容Block
 @param completion 更新完成回调Block
 */
- (void)performUpdatesWithAnimateDuration:(NSTimeInterval)duration updates:(void (^)(BSMultiViewControl *multiViewControl))updates completion:(void (^)())completion;

@end

/**
 *  @brief BSMultiViewControl数据源协议
 */
@protocol BSMultiViewControlDataSource <NSObject>
@required

/**
 *  @brief 子视图控制器数量
 *
 *  @param multiViewControl 复合视图控制器
 *
 *  @return 子视图控制器数量
 */
- (NSUInteger)numberOfItemsInMultiViewControl:(BSMultiViewControl *)multiViewControl;

/**
 *  @brief 标题按钮
 *
 *  @param multiViewControl 复合视图控制器
 *  @param index            索引
 *
 *  @return 标题按钮
 */
- (UIButton *)multiViewControl:(BSMultiViewControl *)multiViewControl buttonAtIndex:(NSUInteger)index;

/**
 *  @brief 子视图控制器
 *
 *  @param multiViewControl 复合视图控制器
 *  @param index            索引
 *
 *  @return 子视图控制器
 */
- (UIViewController *)multiViewControl:(BSMultiViewControl *)multiViewControl viewControllerAtIndex:(NSUInteger)index;

@end

/**
 *  @brief BSMultiViewControl代理协议
 */
@protocol BSMultiViewControlDelegate <NSObject>
@optional

/**
 *  @brief 选中子视图控制器代理方法，子视图控制器可在此方法中进行数据请求操作
 *
 *  @param multiViewControl 复合视图控制器
 *  @param vc               子视图控制器
 *  @param index            索引
 */
- (void)multiViewControl:(BSMultiViewControl *)multiViewControl didSelectViewController:(UIViewController *)vc atIndex:(NSUInteger)index;

@end
