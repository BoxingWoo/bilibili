//
//  HomeViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

#pragma mark - MultiViewControlDataSource

- (NSUInteger)numberOfItemsInMultiViewControl:(BSMultiViewControl *)multiViewControl
{
    return 3;
}

- (UIButton *)multiViewControl:(BSMultiViewControl *)multiViewControl buttonAtIndex:(NSUInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    switch (index) {
        case 0:
            [button setTitle:@"直播" forState:UIControlStateNormal];
            break;
        case 1:
            [button setTitle:@"推荐" forState:UIControlStateNormal];
            break;
        case 2:
            [button setTitle:@"番剧" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    return button;
}

- (UIViewController *)multiViewControl:(BSMultiViewControl *)multiViewControl viewControllerAtIndex:(NSUInteger)index
{
    DdBasedViewModel *viewModel;
    if (index == 0) {
        viewModel = [[LiveViewModel alloc] initWithClassName:@"LiveViewController" params:nil];
    }else if (index == 1) {
        viewModel = [[RecommendViewModel alloc] initWithClassName:@"RecommendViewController" params:nil];
    }else if (index == 2) {
        viewModel = [[BangumiViewModel alloc] initWithClassName:@"BangumiViewController" params:nil];
    }
    UIViewController *vc = [UIViewController initWithViewModel:viewModel];
    return vc;
}

@end
