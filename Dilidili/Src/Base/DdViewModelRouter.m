//
//  DdViewModelRouter.m
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdViewModelRouter.h"
#import "DdViewModelNavigation.h"

@interface DdViewModelRouter()

/** 存储读取的plist文件数据 */
@property (nonatomic, copy) NSDictionary *configDict;

@end

@implementation DdViewModelRouter

+ (instancetype)sharedInstance
{
    static DdViewModelRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] _init];
    });
    return router;
}

- (instancetype)_init
{
    if (self = [super init]) {
        [self loadConfigDictFromPlist:@"DdViewModelRouter"];
    }
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"Use +[DdViewModelRouter sharedInstance]");
    return nil;
}

- (void)loadConfigDictFromPlist:(NSString *)pistName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pistName ofType:@"plist"];
    NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (configDict) {
        _configDict = configDict;
    }else {
        NSAssert(0, @"请添加对应的plist文件");
    }
}

+ (void)pushViewModel:(DdBasedViewModel *)viewModel animated:(BOOL)animated
{
    [self pushViewModel:viewModel animated:animated replace:NO];
}

+ (void)pushViewModel:(DdBasedViewModel *)viewModel animated:(BOOL)animated replace:(BOOL)replace
{
    UIViewController *viewController = [UIViewController initWithViewModel:viewModel];
    [DdViewModelNavigation pushViewController:viewController animated:animated replace:replace];
    [viewController bindViewModel];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated
{
    [self pushURLString:urlString params:nil animated:animated replace:NO];
}

+ (void)pushURLString:(NSString *)urlString params:(NSDictionary *)params animated:(BOOL)animated replace:(BOOL)replace
{
    DdBasedViewModel *viewModel = nil;
    NSString *name = nil;
    NSDictionary *configDict = [[self sharedInstance] configDict];
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *home = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    if([configDict.allKeys containsObject:url.scheme]){ // 字典中的所有的key是否包含传入的协议头
        id config = [configDict objectForKey:url.scheme]; // 根据协议头取出值
        Class class = nil;
        if([config isKindOfClass:[NSString class]]){ //当协议头是http https的情况
            name = config;
        }else if([config isKindOfClass:[NSDictionary class]]){ // 自定义的url情况
            NSDictionary *dict = (NSDictionary *)config;
            if([dict.allKeys containsObject:home]){
                name = [dict objectForKey:home];
            }
        }
        NSString *className = [NSString stringWithFormat:@"%@ViewModel", name];
        class =  NSClassFromString(className);
        
        if (class !=nil) {
            viewModel = [[class alloc] init];
            viewModel.className = [NSString stringWithFormat:@"%@ViewController", name];
            viewModel.URL = url;
            viewModel.params = params;
            [self pushViewModel:viewModel animated:animated replace:replace];
        }
    }
}

+ (void)presentViewModel:(DdBasedViewModel *)viewModel animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *viewController = [UIViewController initWithViewModel:viewModel];
    DdNavigationController *nvc = [[DdNavigationController alloc] initWithRootViewController:viewController];
    [DdViewModelNavigation presentViewController:nvc animated:animated completion:completion];
    [viewController bindViewModel];
}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self presentURLString:urlString params:nil animated:animated completion:completion];
}

+ (void)presentURLString:(NSString *)urlString params:(NSDictionary *)params animated:(BOOL)animated completion:(void (^)(void))completion
{
    DdBasedViewModel *viewModel = nil;
    NSString *name = nil;
    NSDictionary *configDict = [[self sharedInstance] configDict];
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *home = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    if([configDict.allKeys containsObject:url.scheme]){ // 字典中的所有的key是否包含传入的协议头
        id config = [configDict objectForKey:url.scheme]; // 根据协议头取出值
        Class class = nil;
        if([config isKindOfClass:[NSString class]]){ //当协议头是http https的情况
            name = config;
        }else if([config isKindOfClass:[NSDictionary class]]){ // 自定义的url情况
            NSDictionary *dict = (NSDictionary *)config;
            if([dict.allKeys containsObject:home]){
                name = [dict objectForKey:home];
            }
        }
        NSString *className = [NSString stringWithFormat:@"%@ViewModel", name];
        class =  NSClassFromString(className);
        
        if (class !=nil) {
            viewModel = [[class alloc] init];
            viewModel.className = [NSString stringWithFormat:@"%@ViewController", name];
            viewModel.URL = url;
            viewModel.params = params;
            [self presentViewModel:viewModel animated:animated completion:completion];
        }
    }
}

+ (void)popViewControllerAnimated:(BOOL)animated
{
    [DdViewModelNavigation popViewControllerWithTimes:1 animated:animated];
}

+ (void)popTwiceViewControllerAnimated:(BOOL)animated
{
    [DdViewModelNavigation popTwiceViewControllerAnimated:animated];
}

+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated
{
    [DdViewModelNavigation popViewControllerWithTimes:times animated:animated];
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated
{
    [DdViewModelNavigation popToRootViewControllerAnimated:animated];
}

+(void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [DdViewModelNavigation dismissViewControllerWithTimes:1 animated:animated completion:completion];
}

+ (void)dismissTwiceViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [DdViewModelNavigation dismissTwiceViewControllerAnimated:animated completion:completion];
}

+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated completion:(void (^)(void))completion
{
    [DdViewModelNavigation dismissViewControllerWithTimes:times animated:animated completion:completion];
}

+ (void)dismissToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [DdViewModelNavigation dismissToRootViewControllerAnimated:animated completion:completion];
}

+ (UIViewController*)currentViewController
{
    return [DdViewModelNavigation sharedInstance].currentViewController;
}

+ (UINavigationController*)currentNavigationViewController
{
    return [DdViewModelNavigation sharedInstance].currentNavigationViewController;
}

@end
