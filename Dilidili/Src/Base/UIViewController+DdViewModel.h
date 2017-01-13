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

@interface UIViewController (DdViewModel)

@property (nonatomic, strong) DdBasedViewModel *viewModel;

+ (instancetype)initWithViewModel:(DdBasedViewModel *)viewModel;

- (void)bindViewModel NS_REQUIRES_SUPER;

@end
