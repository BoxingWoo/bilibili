//
//  DdViewModelNavigation.h
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DdViewModelNavigation : NSObject

+ (instancetype)sharedInstance;

/**
 *  返回当前控制器
 */
- (UIViewController*)currentViewController;

/**
 *  返回当前的导航控制器
 */
- (UINavigationController*)currentNavigationViewController;


+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace;
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

+ (void)popTwiceViewControllerAnimated:(BOOL)animated;
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;
+ (void)popToRootViewControllerAnimated:(BOOL)animated;

+ (void)dismissTwiceViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)animated completion:(void (^)(void))completion;
+ (void)dismissToRootViewControllerAnimated: (BOOL)animated completion:(void (^)(void))completion;

@end
