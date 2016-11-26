//
//  DiscoveryViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "SKTagView.h"
#import "DdCornerView.h"
#import "DdEmptyHeader.h"

@interface DiscoveryViewController ()

/** 标签视图 */
@property (weak, nonatomic) IBOutlet SKTagView *tagView;
/** 滚动视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DiscoveryViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubviews];
    
    [self requestData];
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

- (void)configureSubviews
{
    self.scrollView.layer.cornerRadius = 6.0;
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    self.scrollView.mj_header = [DdEmptyHeader headerWithRefreshingBlock:NULL];
    
    self.tagView.lineSpace = 8.0;
    self.tagView.insets = 6.0;
#pragma mark Action - 搜索标签
    [self.tagView setDidClickTagAtIndex:^(NSUInteger index) {
        
    }];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

#pragma mark - Utility
#pragma mark 请求数据
- (void)requestData
{
    [self.dataArr addObjectsFromArray:@[@"法医秦明", @"吃货木下", @"暴走大事件", @"极乐净土", @"哔哩哔哩篮球队", @"校对女孩河野悦子", @"心里的声音"]];
    for (NSString *text in self.dataArr) {
        SKTag *tag = [SKTag tagWithText:text];
        tag.bgColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        tag.textColor = [UIColor whiteColor];
        tag.fontSize = 11;
        tag.cornerRadius = 6.0;
        tag.padding = UIEdgeInsetsMake(8, 8, 8, 8);
        [self.tagView addTag:tag];
    }
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
