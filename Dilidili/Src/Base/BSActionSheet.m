//
//  BSActionSheet.m
//  Dilidili
//
//  Created by iMac on 2016/10/26.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BSActionSheet.h"
#import <UIKit/UIKit.h>

@interface BSActionSheet ()

/**
 警告视图控制器
 */
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation BSActionSheet

#pragma mark 构造方法
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles onButtonTouchUpInside:(void (^)(BSActionSheet * _Nonnull, NSInteger))onButtonTouchUpInsideBlock
{
    if (self = [super init]) {
        NSInteger buttonCount = otherButtonTitles.count;
        if (cancelButtonTitle) buttonCount++;
        if (destructiveButtonTitle) buttonCount++;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        _alertController = alertController;
        
        if (cancelButtonTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (onButtonTouchUpInsideBlock) {
                    onButtonTouchUpInsideBlock(self, buttonCount - 1);
                }
                [alertController dismissViewControllerAnimated:YES completion:NULL];
            }];
            [alertController addAction:cancelAction];
        }
        
        if (destructiveButtonTitle) {
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (onButtonTouchUpInsideBlock) {
                    onButtonTouchUpInsideBlock(self, otherButtonTitles.count);
                }
                [alertController dismissViewControllerAnimated:YES completion:NULL];
            }];
            [alertController addAction:destructiveAction];
        }
        
        for (NSInteger i = 0; i < otherButtonTitles.count; i++) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (onButtonTouchUpInsideBlock) {
                    onButtonTouchUpInsideBlock(self, i);
                }
                [alertController dismissViewControllerAnimated:YES completion:NULL];
            }];
            [alertController addAction:alertAction];
        }
    }
    return self;
}

#pragma mark Setter

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.alertController.view.tintColor = tintColor;
}

#pragma mark 显示
- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].windows.firstObject;
    UIViewController *currentViewController = [self _currentViewControllerFrom:rootWindow.rootViewController];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *popover = self.alertController.popoverPresentationController;
        if (popover) {
            popover.sourceView = rootWindow;
        }
    }
    [currentViewController presentViewController:self.alertController animated:YES completion:NULL];
}

#pragma mark 通过递归拿到当前控制器
- (UIViewController *)_currentViewControllerFrom:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self _currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } // 如果传入的控制器是导航控制器,则返回最后一个
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self _currentViewControllerFrom:tabBarController.selectedViewController];
    } // 如果传入的控制器是标签控制器,则返回选中的那个
    else if(viewController.presentedViewController != nil) {
        return [self _currentViewControllerFrom:viewController.presentedViewController];
    } // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    else {
        return viewController;
    }
}

@end
