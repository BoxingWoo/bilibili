//
//  UIViewController+DdViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DdNavigationController.h"
#import "DdBasedViewModel.h"

/**
 视图控制器（视图模型分类)
 */
@interface UIViewController (DdViewModel)

/**
 视图模型
 */
@property (nonatomic, strong) DdBasedViewModel *viewModel;

/**
 类构造方法

 @param viewModel 视图模型
 @return 视图控制器实例
 */
+ (instancetype)initWithViewModel:(DdBasedViewModel *)viewModel;

/**
 绑定
 */
- (void)bindViewModel NS_REQUIRES_SUPER;

@end
