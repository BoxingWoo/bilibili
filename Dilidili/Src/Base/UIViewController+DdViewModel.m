//
//  UIViewController+DdViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "UIViewController+DdViewModel.h"

@implementation UIViewController (DdViewModel)
@dynamic viewModel;  // 视图控制器必须动态实现viewModel的getter和setter方法

#pragma mark 构造方法
+ (instancetype)initWithViewModel:(DdBasedViewModel *)viewModel
{
    UIViewController *VC = nil;
    if (viewModel.className != nil) {
        NSString *className = viewModel.className;
        VC = [[NSClassFromString(className) alloc] init];
    }
    if (VC != nil) {
        VC.viewModel = viewModel;
    }else {
        NSAssert(NO, @"类名错误！");
    }
    
    return VC;
}

#pragma mark 绑定
- (void)bindViewModel
{
    RAC(self.navigationItem, title) = RACObserve(self.viewModel, title);
}

@end
