//
//  DdNavigationController.h
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义导航视图控制器
 */
@interface DdNavigationController : UINavigationController

/**
 push视图控制器

 @param viewController 目标视图控制器
 @param animated       是否使用动画
 @param replace        是否将当前视图控制器替换为目标视图控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace;

@end
