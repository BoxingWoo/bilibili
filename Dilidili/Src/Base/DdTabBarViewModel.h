//
//  DdTabBarViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/12.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import "HomeViewModel.h"
#import "CategoryViewController.h"
#import "AttentionViewController.h"
#import "DiscoveryViewController.h"
#import "MineViewController.h"

/**
 dilidili标签视图模型
 */
@interface DdTabBarViewModel : DdBasedViewModel

/**
 数据数组
 */
@property (nonatomic, copy) NSArray *dataArr;

@end
