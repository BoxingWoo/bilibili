//
//  DdTabBarController.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdTabBarController.h"
#import "DdTabBarViewModel.h"

@interface DdTabBarController ()

/**
 dilidili标签视图模型
 */
@property (nonatomic, strong) DdTabBarViewModel *viewModel;

@end

@implementation DdTabBarController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)setViewModel:(DdBasedViewModel *)viewModel
{
    _viewModel = (DdTabBarViewModel *)viewModel;
    [self addChildViewControllers];
}

#pragma mark 添加子视图控制器
- (void)addChildViewControllers
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.viewModel.dataArr.count; i++) {
        NSDictionary *dict = self.viewModel.dataArr[i];
        DdBasedViewModel *viewModel = nil;
        UIViewController *childVc = nil;
        switch (i) {
            case 0:
                viewModel = [[HomeViewModel alloc] initWithClassName:dict[@"className"] params:nil];
                childVc = [UIViewController initWithViewModel:viewModel];
                break;
            case 1:
                childVc = [[NSClassFromString(dict[@"className"]) alloc] init];
                break;
            case 2:
                childVc = [[NSClassFromString(dict[@"className"]) alloc] init];
                break;
            case 3:
                childVc = [[NSClassFromString(dict[@"className"]) alloc] init];
                break;
            case 4:
                childVc = [[NSClassFromString(dict[@"className"]) alloc] init];
            default:
                break;
        }
        DdNavigationController *nvc = [[DdNavigationController alloc] initWithRootViewController:childVc];

        UIImage *image = [UIImage imageNamed:dict[@"normalImage"]];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nvc.tabBarItem.image = image;
        UIImage *selectedImage = [UIImage imageNamed:dict[@"selectedImage"]];
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
