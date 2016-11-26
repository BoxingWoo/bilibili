//
//  CategoryViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryCell.h"

@interface CategoryViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** 集合视图 */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 数据数组 */
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation CategoryViewController

static NSString *const kCategoryCellID = @"CategoryCell";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = kThemeColor;
    
    [self createUI];
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

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@{@"icon":@"home_region_icon_live", @"title":@"直播"}, @{@"icon":@"home_region_icon_13", @"title":@"番剧"}, @{@"icon":@"home_region_icon_1", @"title":@"动画"}, @{@"icon":@"home_region_icon_3", @"title":@"音乐"}, @{@"icon":@"home_region_icon_129", @"title":@"舞蹈"}, @{@"icon":@"home_region_icon_4", @"title":@"游戏"}, @{@"icon":@"home_region_icon_36", @"title":@"科技"}, @{@"icon":@"home_region_icon_160", @"title":@"生活"}, @{@"icon":@"home_region_icon_119", @"title":@"鬼畜"}, @{@"icon":@"home_region_icon_5", @"title":@"时尚"}, @{@"icon":@"home_region_icon_165", @"title":@"广告"}, @{@"icon":@"home_region_icon_155", @"title":@"娱乐"}, @{@"icon":@"home_region_icon_23", @"title":@"电影"}, @{@"icon":@"home_region_icon_11", @"title":@"电视剧"}, @{@"icon":@"home_region_gamecenter", @"title":@"游戏中心"}];
    }
    return _dataArr;
}

- (void)createUI
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 28.0)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"分区";
    [self.view addSubview:titleLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMakeEx(64, 78);
    flowLayout.minimumInteritemSpacing = widthEx(30.0);
    flowLayout.minimumLineSpacing = heightEx(10.0);
    CGFloat insetTop = (kScreenHeight - titleLabel.bottom - kTabBarHeight - ceil(self.dataArr.count / 3.0) * (flowLayout.itemSize.height + flowLayout.minimumLineSpacing) + flowLayout.minimumLineSpacing) / 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(insetTop, 30.0, insetTop, 30.0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, kScreenWidth, kScreenHeight - titleLabel.bottom) collectionViewLayout:flowLayout];
    _collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.layer.cornerRadius = 6.0;
    collectionView.layer.masksToBounds = YES;
    collectionView.backgroundColor = kBgColor;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:kCategoryCellID];
    if (![[UIDevice currentDevice].machineModelName isEqualToString:@"iPhone 4S"]) {
        collectionView.scrollEnabled = NO;
    }
    [self.view addSubview:collectionView];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryCellID forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.item];
    cell.iconImageView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}

#pragma mark - CollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
