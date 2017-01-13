//
//  DdViewModelRouter.h
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+DdViewModel.h"

@interface DdViewModelRouter : NSObject

/**
 *  @brief 单例方法
 *
 *  @return 单例对象
 */
+ (instancetype)sharedInstance;

#pragma mark --------  拿到导航控制器 和当前控制器 --------

/** 返回当前控制器 */
+ (UIViewController*)currentViewController;

/** 返回当前控制器的导航控制器 */
+ (UINavigationController*)currentNavigationViewController;

#pragma mark --------  push viewModel --------
/**
 *  push
 *
 *  @param viewModel 视图模型
 */
+ (void)pushViewModel:(DdBasedViewModel *)viewModel animated:(BOOL)animated;

/**
 *  push
 *
 *  @param viewModel 视图模型
 *  @param replace   如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.
 */
+ (void)pushViewModel:(DdBasedViewModel *)viewModel animated:(BOOL)animated replace:(BOOL)replace;

/**
 *  push
 *
 *  @param urlString 自定义URL
 */
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated;

/**
 *  push
 *
 *  @param urlString 自定义URL
 *  @param params    存放参数
 *  @param replace   如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.
 */
+ (void)pushURLString:(NSString *)urlString params:(NSDictionary *)params animated:(BOOL)animated replace:(BOOL)replace;

#pragma mark --------  pop控制器 --------

/** pop掉一层控制器 */
+ (void)popViewControllerAnimated:(BOOL)animated;
/** pop掉两层控制器 */
+ (void)popTwiceViewControllerAnimated:(BOOL)animated;
/** pop掉times层控制器 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;
/** pop到根层控制器 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated;

#pragma mark --------  modal viewModel --------

/**
 *  modal
 *
 *  @param viewModel 视图模型
 */
+ (void)presentViewModel:(DdBasedViewModel *)viewModel animated: (BOOL)animated completion:(void (^)(void))completion;

/**
 *  modal
 *
 *  @param urlString 自定义URL
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *  modal
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param params     存放参数
 */
+ (void)presentURLString:(NSString *)urlString params:(NSDictionary *)params animated:(BOOL)animated completion:(void (^)(void))completion;

#pragma mark --------  dismiss控制器 --------
/** dismiss掉1层控制器 */
+ (void)dismissViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion;
/** dismiss掉2层控制器 */
+ (void)dismissTwiceViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion;
/** dismiss掉times层控制器 */
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)animated completion: (void (^)(void))completion;
/** dismiss到根层控制器 */
+ (void)dismissToRootViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion;

@end
