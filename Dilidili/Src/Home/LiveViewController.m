//
//  LiveViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveViewController.h"
#import <pop/POP.h>
#import "LiveCenterViewController.h"
#import "LiveVideoViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DdProgressHUD.h"
#import "DdRefreshMainHeader.h"
#import "DdImageManager.h"
#import "LiveFlowLayout.h"
#import "LiveViewModel.h"

@interface LiveViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BSLoopScrollViewDataSource, BSLoopScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL _isNoData;  // 没有数据
}

/** 集合视图 */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 自定义流式布局 */
@property (nonatomic, weak) LiveFlowLayout *flowLayout;
/** 直播视图模型数组 */
@property (nonatomic, strong) NSMutableArray <LiveViewModel *> *dataArr;
/** 直播横幅广告数组 */
@property (nonatomic, strong) NSMutableArray <LiveBannerModel *> *banners;

/** 是否需要重载循环滚动视图 */
@property (nonatomic, assign) BOOL shouldRefreshLoopScrollView;

@end

@implementation LiveViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self createUI];
    
    [self requestData:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (NSMutableArray<LiveViewModel *> *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (NSMutableArray<LiveBannerModel *> *)banners
{
    if (!_banners) {
        _banners = [[NSMutableArray alloc] init];
    }
    return _banners;
}

- (void)createUI
{
    LiveFlowLayout *flowLayout = [[LiveFlowLayout alloc] init];
    _flowLayout = flowLayout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView = collectionView;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.emptyDataSetSource = self;
    collectionView.emptyDataSetDelegate = self;
    collectionView.layer.cornerRadius = 6.0;
    collectionView.layer.masksToBounds = YES;
    collectionView.backgroundColor = kBgColor;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[LiveCell class] forCellWithReuseIdentifier:kliveCellID];
    [collectionView registerClass:[LiveRefreshCell class] forCellWithReuseIdentifier:kliveRefreshCellID];
    [collectionView registerClass:[LiveSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kliveSectionHeaderID];
    [collectionView registerClass:[LiveHeaderView class] forSupplementaryViewOfKind:kLiveCollectionElementKindHeaderView withReuseIdentifier:kliveHeaderViewID];
    [collectionView registerClass:[LiveFooterView class] forSupplementaryViewOfKind:kLiveCollectionElementKindFooterView withReuseIdentifier:kliveFooterViewID];
    collectionView.mj_header = (MJRefreshHeader *)[DdRefreshMainHeader headerWithRefreshingBlock:^{
        [self requestData:YES];
    }];
    
    [self.view addSubview:collectionView];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        LiveViewModel *viewModel = self.dataArr[section];
        return viewModel.model.lives.count;
    }else {
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveViewModel *viewModel = self.dataArr[indexPath.section];
    LiveCell *cell = nil;
    if (indexPath.item == [self collectionView:collectionView numberOfItemsInSection:indexPath.section] - 1) {
        LiveRefreshCell *refreshCell = [collectionView dequeueReusableCellWithReuseIdentifier:kliveRefreshCellID forIndexPath:indexPath];
        cell = refreshCell;
        NSArray *actions = [refreshCell.refreshBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if (![actions containsObject:NSStringFromSelector(@selector(handleRefresh:))]) {
            [refreshCell.refreshBtn addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kliveCellID forIndexPath:indexPath];
    }
    [viewModel configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:kLiveCollectionElementKindHeaderView]) {
        LiveHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kliveHeaderViewID forIndexPath:indexPath];
        headerView.loopScrollView.dataSource = self;
        headerView.loopScrollView.delegate = self;
        if (self.shouldRefreshLoopScrollView) {
            self.shouldRefreshLoopScrollView = NO;
            [headerView.loopScrollView reloadData];
        }
#pragma mark Action - 功能选项
        if (!headerView.actionSubject) {
            headerView.actionSubject = [RACSubject subject];
            @weakify(self);
            [headerView.actionSubject subscribeNext:^(NSNumber *x) {
                @strongify(self);
                NSInteger index = x.integerValue;
                if (index == 1) {  // 直播中心
                    LiveCenterViewController *cvc = [[LiveCenterViewController alloc] init];
                    [self.navigationController pushViewController:cvc animated:YES];
                }
            }];
        }
        return headerView;
    }
    
    if ([kind isEqualToString:kLiveCollectionElementKindFooterView]) {
        LiveFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kliveFooterViewID forIndexPath:indexPath];
        NSArray *actions = [footerView.allBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if (![actions containsObject:NSStringFromSelector(@selector(handleAll))]) {
            [footerView.allBtn addTarget:self action:@selector(handleAll) forControlEvents:UIControlEventTouchUpInside];
        }
        return footerView;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LiveViewModel *viewModel = self.dataArr[indexPath.section];
        LiveSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kliveSectionHeaderID forIndexPath:indexPath];
        [viewModel configureSectionHeader:sectionHeader atIndex:indexPath.section];
        NSArray *actions = [sectionHeader.moreBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if (![actions containsObject:NSStringFromSelector(@selector(handleMore:))]) {
            [sectionHeader.moreBtn addTarget:self action:@selector(handleMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        return sectionHeader;
    }
    
    return nil;
}

#pragma mark - CollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveViewModel *viewModel = self.dataArr[indexPath.section];
    LiveModel *model = viewModel.model.lives[indexPath.item];
    LiveVideoViewController *vvc = [[LiveVideoViewController alloc] init];
    vvc.room_id = model.room_id;
    vvc.playurl = model.playurl;
    [self.navigationController pushViewController:vvc animated:YES];
}

#pragma mark - LoopScrollView

- (NSUInteger)numberOfItemsInLoopScrollView:(BSLoopScrollView *)loopScrollView
{
    return self.banners.count;
}

- (UIView *)loopScrollView:(BSLoopScrollView *)loopScrollView contentViewAtIndex:(NSUInteger)index
{
    LiveBannerModel *bannerModel = self.banners[index];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImageWithURL:[NSURL URLWithString:bannerModel.img] placeholder:[DdImageManager banner_placeholderImageBySize:CGSizeMakeEx(320, 96)]];
    return imageView;
}

- (void)loopScrollView:(BSLoopScrollView *)loopScrollView didTouchContentView:(UIView *)contentView atIndex:(NSUInteger)index
{
    LiveBannerModel *bannerModel = self.banners[index];
    [DCURLRouter pushURLString:bannerModel.link query:@{@"title":bannerModel.title, @"cover":bannerModel.img} animated:YES];
}

#pragma mark - HandleAction
#pragma mark 查看全部
- (void)handleAll
{
    
}

#pragma mark 查看更多
- (void)handleMore:(UIButton *)button
{
    
}


#pragma mark 刷新数据
- (void)handleRefresh:(UIButton *)button
{
    POPBasicAnimation *rotateAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotateAnimation.fromValue = @(0);
    rotateAnimation.toValue = @(2 * M_PI);
    rotateAnimation.duration = 0.8;
    rotateAnimation.repeatForever = YES;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    [button.layer pop_addAnimation:rotateAnimation forKey:@"refresh_rotate"];
    
    button.enabled = NO;
    @weakify(self);
    LiveViewModel *viewModel = self.dataArr[button.tag];
    [[[viewModel refreshLiveDataAtIndex:button.tag] execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        button.enabled = YES;
        [button.layer pop_removeAnimationForKey:@"refresh_rotate"];
        button.layer.transform = CATransform3DIdentity;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:button.tag]];
    } error:^(NSError *error) {
        button.enabled = YES;
        [button.layer pop_removeAnimationForKey:@"refresh_rotate"];
        button.layer.transform = CATransform3DIdentity;
        [DdProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Utility
#pragma mark 请求数据
- (void)requestData:(BOOL)forceReload
{
    _isNoData = NO;
    [[[LiveViewModel requestLiveData:forceReload] execute:nil] subscribeNext:^(RACTuple *x) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.dataArr removeAllObjects];
        [self.banners removeAllObjects];
        
        LiveListModel *recommendedModel = x.first;
        LiveViewModel *recommendedViewModel = [[LiveViewModel alloc] initWithModel:recommendedModel];
        [self.dataArr addObject:recommendedViewModel];
        
        RACTuple *tuple = x.second;
        RACTupleUnpack(NSArray *partitions, NSArray *banners) = tuple;
        for (LiveListModel *model in partitions) {
            LiveViewModel *viewModel = [[LiveViewModel alloc] initWithModel:model];
            [self.dataArr addObject:viewModel];
        }
        [self.banners addObjectsFromArray:banners];
        
        self.shouldRefreshLoopScrollView = YES;
        self.flowLayout.viewModels = self.dataArr;
        [self.collectionView reloadData];
        
    } error:^(NSError * _Nullable error) {
        _isNoData = YES;
        [self.collectionView.mj_header endRefreshing];
        [DdProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - EmptyDataSet

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    UIView *customView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = kTextColor;
    if (_isNoData) {
        titleLabel.text = @"电波无法到达哟 code:0";
    }else {
        titleLabel.text = @"正在玩命加载数据...";
    }
    [customView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(customView.mas_centerY).offset(-10.0);
        make.centerX.equalTo(customView.mas_centerX);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    if (_isNoData) {
        imageView.image = [UIImage imageNamed:@"common_loading_noData"];
    }else {
        NSMutableArray *animationImages = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i <= 2; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"common_loading_loading_%li", i]];
            [animationImages addObject:image];
        }
        imageView.animationImages = animationImages;
        imageView.animationDuration = animationImages.count * 0.5;
        imageView.animationRepeatCount = 0;
        [imageView startAnimating];
    }
    [customView addSubview:imageView];
    CGFloat width = widthEx(200.0);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(customView.mas_centerX);
        make.bottom.equalTo(titleLabel.mas_top);
        make.width.height.mas_equalTo(width);
    }];
    
    return customView;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    if (_isNoData) {
        return YES;
    }else {
        return NO;
    }
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
