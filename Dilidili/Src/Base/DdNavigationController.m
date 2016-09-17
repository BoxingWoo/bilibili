//
//  DdNavigationController.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdNavigationController.h"

@interface DdNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation DdNavigationController

#pragma mark - Initialization

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    bar.tintColor = kTintColor;
    bar.barTintColor = kThemeColor;
    bar.translucent = NO;
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    titleAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [bar setTitleTextAttributes:titleAttrs];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Push & Pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *fromViewController = self.topViewController;
    fromViewController.hidesBottomBarWhenPushed = YES;
    if (fromViewController) {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back_v2"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack)];
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    [super pushViewController:viewController animated:animated];
    if (fromViewController == self.viewControllers.firstObject) {
        fromViewController.hidesBottomBarWhenPushed = NO;
    }
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self.viewControllers.firstObject) {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back_v2"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack)];
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }else {
        viewController.navigationItem.leftBarButtonItem = nil;
    }
    return [super popToViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    NSUInteger index = [self.viewControllers indexOfObject:self.topViewController];
    if (index > 1) {
        UIViewController *viewController = [self.viewControllers objectAtIndex:index - 1];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back_v2"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack)];
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }else if (index == 1) {
        UIViewController *viewController = self.viewControllers.firstObject;
        viewController.navigationItem.leftBarButtonItem = nil;
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    UIViewController *viewController = self.viewControllers.firstObject;
    viewController.navigationItem.leftBarButtonItem = nil;
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - HandleAction

- (void)handleBack
{
    [self popViewControllerAnimated:YES];
}

#pragma mark gestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Others

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
