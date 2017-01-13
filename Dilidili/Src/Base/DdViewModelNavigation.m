//
//  DdViewModelNavigation.m
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdViewModelNavigation.h"

@implementation DdViewModelNavigation

+ (instancetype)sharedInstance
{
    static DdViewModelNavigation *nav = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nav = [[self alloc] init];
    });
    return nav;
}

- (UIViewController*)currentViewController
{
    UIViewController* rootViewController = self.applicationDelegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

- (UINavigationController *)currentNavigationViewController
{
    UIViewController* currentViewController = self.currentViewController;
    return currentViewController.navigationController;
}

- (id<UIApplicationDelegate>)applicationDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace
{
    if (!viewController) {
        return;
    } else {
        if([viewController isKindOfClass:[UINavigationController class]]) {
            [self setRootViewController:viewController];
        } // 如果是导航控制器直接设置为根控制器
        else {
            UINavigationController *navigationController = [[self sharedInstance] currentNavigationViewController];
            if (navigationController) { // 导航控制器存在
                if (replace) {
                    NSArray *viewControllers = [navigationController.viewControllers subarrayWithRange:NSMakeRange(0, navigationController.viewControllers.count-1)];
                    [navigationController setViewControllers:[viewControllers arrayByAddingObject:viewController] animated:animated];
                } // 切换当前导航控制器 需要把原来的子控制器都取出来重新添加
                else {
                    [navigationController pushViewController:viewController animated:animated];
                } // 进行push
            }
            else {
                navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                [[self sharedInstance] applicationDelegate].window.rootViewController = navigationController;
            } // 如果导航控制器不存在,就会创建一个新的,设置为根控制器
        }
    }
}

+ (void)presentViewController:(UIViewController *)viewController animated: (BOOL)animated completion:(void (^ __nullable)(void))completion
{
    if (!viewController) {
        return;
    }else {
        UIViewController *currentViewController = [[self sharedInstance] currentViewController];
        if (currentViewController) { // 当前控制器存在
            [currentViewController presentViewController:viewController animated:animated completion:completion];
        } else { // 将控制器设置为根控制器
            [[self sharedInstance] applicationDelegate].window.rootViewController = viewController;
        }
    }
}

// 设置为根控制器
+ (void)setRootViewController:(UIViewController *)viewController
{
    [[self sharedInstance] applicationDelegate].window.rootViewController = viewController;
}

// 通过递归拿到当前控制器
- (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } // 如果传入的控制器是导航控制器,则返回最后一个
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } // 如果传入的控制器是tabBar控制器,则返回选中的那个
    else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    else {
        return viewController;
    }
}

+ (void)popTwiceViewControllerAnimated:(BOOL)animated
{
    [self popViewControllerWithTimes:2 animated:animated];
}

+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated
{
    
    UIViewController *currentViewController = [[self sharedInstance] currentViewController];
    NSUInteger count = currentViewController.navigationController.viewControllers.count;
    if(currentViewController){
        if(currentViewController.navigationController) {
            if (count > times){
                [currentViewController.navigationController popToViewController:[currentViewController.navigationController.viewControllers objectAtIndex:count-1-times] animated:animated];
            }else { // 如果times大于控制器的数量
                NSAssert(0, @"确定可以pop掉那么多控制器?");
            }
        }
    }
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated
{
    UIViewController *currentViewController = [[self sharedInstance] currentViewController];
    NSUInteger count = currentViewController.navigationController.viewControllers.count;
    [self popViewControllerWithTimes:count-1 animated:animated];
}


+ (void)dismissTwiceViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self dismissViewControllerWithTimes:2 animated:animated completion:completion];
}


+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *rootVC = [[self sharedInstance] currentViewController];
    
    if (rootVC) {
        while (times > 0) {
            rootVC = rootVC.presentingViewController;
            times -= 1;
        }
        [rootVC dismissViewControllerAnimated:animated completion:completion];
    }
    
    if (!rootVC.presentedViewController) {
        NSAssert(0, @"确定能dismiss掉这么多控制器?");
    }
}


+ (void)dismissToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *currentViewController = [[self sharedInstance] currentViewController];
    UIViewController *rootVC = currentViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:animated completion:completion];
    
}

@end
