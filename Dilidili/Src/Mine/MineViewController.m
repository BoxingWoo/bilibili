//
//  MineViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "MineViewController.h"
#import "DdCornerView.h"
#import "BSCentralButton.h"
#import "DdEmptyHeader.h"

@interface MineViewController ()

/** 滚动视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 头像视图 */
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
/** 姓名标签 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 等级图片 */
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
/** 性别图片 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
/** 会员类型标签 */
@property (weak, nonatomic) IBOutlet UILabel *vipTypeLabel;
/** 硬币标签 */
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;

@end

@implementation MineViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubviews];
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
    
    UIImage *faceImage = [UIImage imageNamed:@"avatar3.jpg"];
    self.faceImageView.image = [faceImage imageByRoundCornerRadius:faceImage.size.width / 2];
    self.vipTypeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.vipTypeLabel.layer.borderWidth = 1.0;
    self.vipTypeLabel.layer.cornerRadius = 2.0;
    self.vipTypeLabel.layer.masksToBounds = YES;
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
