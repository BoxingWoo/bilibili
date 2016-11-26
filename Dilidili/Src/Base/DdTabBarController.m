//
//  DdTabBarController.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdTabBarController.h"
#import "DdNavigationController.h"
#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "AttentionViewController.h"
#import "DiscoveryViewController.h"
#import "MineViewController.h"

@interface DdTabBarController ()

@end

@implementation DdTabBarController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization
#pragma mark 添加子视图控制器
- (void)addChildViewControllers
{
    NSArray *normalImages = @[@"home_home_tab", @"home_category_tab", @"home_attention_tab", @"home_discovery_tab", @"home_mine_tab"];
    NSArray *selectedImages = @[@"home_home_tab_s", @"home_category_tab_s", @"home_attention_tab_s", @"home_discovery_tab_s", @"home_mine_tab_s"];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        UIViewController *childVc = nil;
        switch (i) {
            case 0:
                childVc = [[HomeViewController alloc] init];
                break;
            case 1:
                childVc = [[CategoryViewController alloc] init];
                break;
            case 2:
                childVc = [[AttentionViewController alloc] init];
                break;
            case 3:
                childVc = [[DiscoveryViewController alloc] init];
                break;
            case 4:
                childVc = [[MineViewController alloc] init];
            default:
                break;
        }
        DdNavigationController *nvc = [[DdNavigationController alloc] initWithRootViewController:childVc];
        
        UIImage *image = [UIImage imageNamed:normalImages[i]];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nvc.tabBarItem.image = image;
        UIImage *selectedImage = [UIImage imageNamed:selectedImages[i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nvc.tabBarItem.selectedImage = selectedImage;
        
        nvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

        [viewControllers addObject:nvc];
    }
    self.viewControllers = viewControllers;
}

#pragma mark - Others

- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
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
