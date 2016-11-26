//
//  LaunchViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LaunchViewController.h"
#import "DdTabBarController.h"

@interface LaunchViewController ()

/** 溅起图片视图 */
@property (nonatomic, weak) UIImageView *splashImageView;

@end

@implementation LaunchViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self launchWithAnimate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)createUI
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgImageView.image = [UIImage imageNamed:@"bilibili_splash_iphone_bg"];
    [self.view addSubview:bgImageView];
    
    UIImage *splashImage = [UIImage imageNamed:@"bilibili_splash_default"];
    UIImageView *splashImageView = [[UIImageView alloc] initWithImage:splashImage];
    _splashImageView = splashImageView;
    splashImageView.centerY = kScreenHeight / 2;
    splashImageView.left = 30.0;
    splashImageView.width = kScreenWidth - 2 * splashImageView.left;
    splashImageView.height = splashImageView.width * splashImage.size.height / splashImage.size.width;
    splashImageView.layer.anchorPoint = CGPointMake(0.5, 0.8);
    [self.view addSubview:splashImageView];
}

#pragma mark - Utility
#pragma mark 动画加载
- (void)launchWithAnimate
{
    self.splashImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:1.5 delay:0.5 options:0 animations:^{
        self.splashImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].keyWindow.rootViewController = [[DdTabBarController alloc] init];
        });
    }];
}

#pragma mark - Others

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
