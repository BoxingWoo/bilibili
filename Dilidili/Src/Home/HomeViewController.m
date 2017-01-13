//
//  HomeViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "YYFPSLabel.h"

@interface HomeViewController () <BSMultiViewControlDelegate>

/** 视图模型 */
@property (nonatomic, strong) HomeViewModel *viewModel;
/** 复合视图控制器 */
@property (nonatomic, weak) BSMultiViewControl *multiViewControl;

@end

@implementation HomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = kThemeColor;
    
    [self createUI];
    
#ifdef DEBUG
    [YYFPSLabel show];
#endif
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)createUI
{
    BSMultiViewControl *multiViewControl = [[BSMultiViewControl alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20) andStyle:BSMultiViewControlFixedPageSize owner:self];
    _multiViewControl = multiViewControl;
    multiViewControl.dataSource = self.viewModel;
    multiViewControl.delegate = self;
    multiViewControl.listBarWidth = 160.0;
    multiViewControl.listBarHeight = 28.0;
    multiViewControl.selectedButtonBottomLineColor = [UIColor whiteColor];
    multiViewControl.fixedPageSize = 3;
    multiViewControl.bounces = NO;
    multiViewControl.showSeparatedLine = NO;
    multiViewControl.selectedIndex = 1;
    [self.view addSubview:multiViewControl];
    
    [multiViewControl reloadData];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
