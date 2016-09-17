//
//  DCURLRouter.m
//  DCURLRouterDemo
//
//  Created by Dariel on 16/8/17.
//  Copyright © 2016年 DarielChen. All rights reserved.
//  

#import "DCURLRouter.h"
#import "DCURLNavgation.h"

@interface DCURLRouter()

/** 存储读取的plist文件数据 */
@property(nonatomic,strong) NSDictionary *configDict;

@end

@implementation DCURLRouter

+ (instancetype)sharedDCURLRouter
{
    static DCURLRouter *sharedDCURLRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDCURLRouter = [[self alloc] _init];
    });
    return sharedDCURLRouter;
}

- (instancetype)_init
{
    if (self = [super init]) {
        [self loadConfigDictFromPlist:@"DdURLRouter"];
    }
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"Use +[DCURLRouter sharedDCURLRouter]");
    return nil;
}

- (void)loadConfigDictFromPlist:(NSString *)pistName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pistName ofType:@"plist"];
    NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:path];

    if (configDict) {
        _configDict = configDict;
    }else {
        NSAssert(0, @"请按照说明添加对应的plist文件");
    }
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [DCURLNavgation pushViewController:viewController animated:animated replace:NO];
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace {
    [DCURLNavgation pushViewController:viewController animated:animated replace:replace];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated {

    [self pushURLString:urlString query:@{} animated:animated replace:NO];
}

+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated{
    
    [self pushURLString:urlString query:query animated:animated replace:NO];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated replace:(BOOL)replace{
    
    [self pushURLString:urlString query:@{} animated:animated replace:replace];
}

+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[DCURLRouter sharedDCURLRouter].configDict];
        [DCURLNavgation pushViewController:viewController animated:animated replace:replace];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
    [DCURLNavgation presentViewController:viewControllerToPresent animated:flag completion:completion];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion {

    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewControllerToPresent];
        [DCURLNavgation presentViewController:nav animated:flag completion:completion];
    }
}


+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[DCURLRouter sharedDCURLRouter].configDict];
    [DCURLNavgation presentViewController:viewController animated:animated completion:completion];
}


+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[DCURLRouter sharedDCURLRouter].configDict];
    [DCURLNavgation presentViewController:viewController animated:animated completion:completion];
}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion{
    
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[DCURLRouter sharedDCURLRouter].configDict];
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewController];
        [DCURLNavgation presentViewController:nav animated:animated completion:completion];
    }
}

+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)clazz completion:(void (^ __nullable)(void))completion{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[DCURLRouter sharedDCURLRouter].configDict];
    if ([clazz isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[clazz alloc]initWithRootViewController:viewController];
        [DCURLNavgation presentViewController:nav animated:animated completion:completion];
    }
}

+ (void)popViewControllerAnimated:(BOOL)animated {
    [DCURLNavgation popViewControllerWithTimes:1 animated:animated];
}

+ (void)popTwiceViewControllerAnimated:(BOOL)animated {
    [DCURLNavgation popTwiceViewControllerAnimated:animated];
}
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated {
    [DCURLNavgation popViewControllerWithTimes:times animated:animated];
}
+ (void)popToRootViewControllerAnimated:(BOOL)animated {
    [DCURLNavgation popToRootViewControllerAnimated:animated];
}


+ (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [DCURLNavgation dismissViewControllerWithTimes:1 animated:flag completion:completion];
}
+ (void)dismissTwiceViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [DCURLNavgation dismissTwiceViewControllerAnimated:flag completion:completion];
}

+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [DCURLNavgation dismissViewControllerWithTimes:times animated:flag completion:completion];
}

+ (void)dismissToRootViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [DCURLNavgation dismissToRootViewControllerAnimated:flag completion:completion];
}

- (UIViewController*)currentViewController {
    return [DCURLNavgation sharedDCURLNavgation].currentViewController;
}

- (UINavigationController*)currentNavigationViewController {
    return [DCURLNavgation sharedDCURLNavgation].currentNavigationViewController;
}


@end
