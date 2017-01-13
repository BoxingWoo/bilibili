//
//  DdTabBarViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/12.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdTabBarViewModel.h"

@implementation DdTabBarViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = @[@{@"normalImage":@"home_home_tab", @"selectedImage":@"home_home_tab_s", @"className":@"HomeViewController"}, @{@"normalImage":@"home_category_tab", @"selectedImage":@"home_category_tab_s", @"className":@"CategoryViewController"}, @{@"normalImage":@"home_attention_tab", @"selectedImage":@"home_attention_tab_s", @"className":@"AttentionViewController"}, @{@"normalImage":@"home_discovery_tab", @"selectedImage":@"home_discovery_tab_s", @"className":@"DiscoveryViewController"}, @{@"normalImage":@"home_mine_tab", @"selectedImage":@"home_mine_tab_s", @"className":@"MineViewController"}];
    }
    return self;
}

@end
