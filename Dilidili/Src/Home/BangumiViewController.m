//
//  BangumiViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BangumiViewController.h"
#import "BangumiViewModel.h"
#import <pop/POP.h>
#import "UIScrollView+EmptyDataSet.h"
#import "DdProgressHUD.h"
#import "DdRefreshMainHeader.h"
#import "DdRefreshActivityIndicatorFooter.h"
#import "DdImageManager.h"
#import "BangumiFlowLayout.h"

@interface BangumiViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BSLoopScrollViewDataSource, BSLoopScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL _isNoData;  // 是否没有数据
}

/**
 番剧视图模型
 */
@property (nonatomic, strong) BangumiViewModel *viewModel;
/**
 集合视图
 */
@property (nonatomic, weak) UICollectionView *collectionView;
/**
 番剧列表流式布局
 */
@property (nonatomic, weak) BangumiFlowLayout *flowLayout;

/**
 连载
 */
@property (nonatomic, copy) NSArray <BangumiListViewModel *> *serializing;
/**
 完结
 */
@property (nonatomic, copy) NSArray <BangumiListViewModel *> *previous;
/**
 推荐
 */
@property (nonatomic, copy) NSArray <BangumiListViewModel *> *recommend;
/**
 广告
 */
@property (nonatomic, copy) NSDictionary *ad;
/**
 季度
 */
@property (nonatomic, assign) NSUInteger season;
/**
 节头模型
 */
@property (nonatomic, copy) NSArray *sectionHeaderModels;

/**
 是否要刷新滚动视图
 */
@property (nonatomic, assign) BOOL shouldRefreshLoopScrollView;

@end

@implementation BangumiViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self createUI];
    
    [self requestIndexData:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (NSArray *)sectionHeaderModels
{
    if (!_sectionHeaderModels) {
        NSArray *seasonIcons = @[@"season_spring_icon", @"season_summer_icon", @"season_autumn_icon", @"season_winter_icon"];
        _sectionHeaderModels = @[@{@"icon":@"home_region_icon_33", @"title":@"新番连载", @"more":@"更多连载"}, @{@"icon":seasonIcons[self.season - 1], @"title":@"季度新番", @"more":@"分季列表"}, @{@"icon":@"home_bangumi_tableHead_bangumiRecommend", @"title":@"番剧推荐", @"more":@""}];
    }
    return _sectionHeaderModels;
}

- (void)createUI
{
    BangumiFlowLayout *flowLayout = [[BangumiFlowLayout alloc] init];
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
    
    [collectionView registerClass:[BangumiGirdCell class] forCellWithReuseIdentifier:kBangumiGirdCellID];
    [collectionView registerClass:[BangumiListCell class] forCellWithReuseIdentifier:kBangumiListCellID];
    [collectionView registerClass:[BangumiSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kBangumiSectionHeaderID];
    [collectionView registerClass:[BangumiSectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kBangumiSectionFooterID];
    [collectionView registerClass:[BangumiHeaderView class] forSupplementaryViewOfKind:kBangumiCollectionElementKindHeaderView withReuseIdentifier:kBangumiHeaderViewID];
    collectionView.mj_header = (MJRefreshHeader *)[DdRefreshMainHeader headerWithRefreshingBlock:^{
        [self requestIndexData:YES];
    }];
//    collectionView.mj_footer = [DdRefreshActivityIndicatorFooter footerWithRefreshingBlock:^{
//        [self requestRecommendData:YES];
//    }];
    
    [self.view addSubview:collectionView];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.serializing.count;
    }else if (section == 1) {
        return self.previous.count;
    }else {
        return self.recommend.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BangumiListViewModel *viewModel = nil;
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        viewModel = self.serializing[indexPath.row];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBangumiGirdCellID forIndexPath:indexPath];
    }else if (indexPath.section == 1) {
        viewModel = self.previous[indexPath.row];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBangumiGirdCellID forIndexPath:indexPath];
    }else {
        viewModel = self.recommend[indexPath.row];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBangumiListCellID forIndexPath:indexPath];
    }
    [self.viewModel configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:kBangumiCollectionElementKindHeaderView]) {
        BangumiHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kBangumiHeaderViewID forIndexPath:indexPath];
        headerView.loopScrollView.dataSource = self;
        headerView.loopScrollView.delegate = self;
        if (self.shouldRefreshLoopScrollView) {
            self.shouldRefreshLoopScrollView = NO;
            [headerView.loopScrollView reloadData];
        }
#pragma mark Action - 分类
        if (!headerView.categorySubject) {
            headerView.categorySubject = [RACSubject subject];
            [headerView.categorySubject subscribeNext:^(NSNumber *x) {
                
            }];
        }
        
#pragma mark Action - 功能
        if (!headerView.optionSubject) {
            headerView.optionSubject = [RACSubject subject];
            [headerView.optionSubject subscribeNext:^(NSNumber *x) {
                
            }];
        }
        
        return headerView;
    }

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BangumiSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kBangumiSectionHeaderID forIndexPath:indexPath];
        NSDictionary *dict = self.sectionHeaderModels[indexPath.section];
        sectionHeader.iconImageView.image = [UIImage imageNamed:dict[@"icon"]];
        sectionHeader.titleLabel.text = dict[@"title"];
        [sectionHeader.moreBtn setTitle:dict[@"more"] forState:UIControlStateNormal];
        if (indexPath.section != 2) {
            sectionHeader.arrowImageView.hidden = NO;
            sectionHeader.moreBtn.hidden = NO;
        }else {
            sectionHeader.arrowImageView.hidden = YES;
            sectionHeader.moreBtn.hidden = YES;
        }
        NSArray *actions = [sectionHeader.moreBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if (![actions containsObject:NSStringFromSelector(@selector(handleMore:))]) {
            [sectionHeader.moreBtn addTarget:self action:@selector(handleMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return sectionHeader;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        BangumiSectionFooter *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kBangumiSectionFooterID forIndexPath:indexPath];
        BangumiBannerModel *bannnerModel = [self.ad[@"body"] firstObject];
        [sectionFooter.coverBtn setBackgroundImageWithURL:[NSURL URLWithString:bannnerModel.img] forState:UIControlStateNormal placeholder:[DdImageManager banner_placeholderImageBySize:CGSizeMake(kScreenWidth - 20, (kScreenWidth - 20) * 0.3)] options:0 progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            
            return [image imageByRoundCornerRadius:kCornerRadius];
            
        } completion:NULL];
        
        if (!sectionFooter.coverBtn.rac_command) {
            @weakify(self);
            sectionFooter.coverBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                @strongify(self);
                return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                    BangumiBannerModel *bannerModel = [self.ad[@"body"] firstObject];
                    [DdViewModelRouter pushURLString:bannerModel.link params:@{@"title":bannerModel.title, @"cover":bannerModel.img} animated:YES replace:NO];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }];
        }
        
        return sectionFooter;
    }
    
    return nil;
}

#pragma mark - CollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - LoopScrollView

- (NSUInteger)numberOfItemsInLoopScrollView:(BSLoopScrollView *)loopScrollView
{
    return [self.ad[@"head"] count];
}

- (UIView *)loopScrollView:(BSLoopScrollView *)loopScrollView contentViewAtIndex:(NSUInteger)index
{
    BangumiBannerModel *bannerModel = [self.ad[@"head"] objectAtIndex:index];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImageWithURL:[NSURL URLWithString:bannerModel.img] placeholder:[DdImageManager banner_placeholderImageBySize:CGSizeMakeEx(320, 96)]];
    return imageView;
}

- (void)loopScrollView:(BSLoopScrollView *)loopScrollView didTouchContentView:(UIView *)contentView atIndex:(NSUInteger)index
{
    BangumiBannerModel *bannerModel = [self.ad[@"head"] objectAtIndex:index];
    [DdViewModelRouter pushURLString:bannerModel.link params:@{@"title":bannerModel.title, @"cover":bannerModel.img} animated:YES replace:NO];
}

#pragma mark - HandleAction
#pragma mark 查看更多
- (void)handleMore:(UIButton *)button
{
    
}

#pragma mark - Utility
#pragma mark 请求索引数据
- (void)requestIndexData:(BOOL)forceReload
{
    _isNoData = NO;
    @weakify(self);
    [[[self.viewModel requestBangumiIndexData:forceReload] execute:nil] subscribeNext:^(id x) {
        
        @strongify(self);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer resetNoMoreData];
        
        self.serializing = self.viewModel.serializing;
        self.previous = self.viewModel.previous;
        self.ad = self.viewModel.ad;
        self.season = self.viewModel.season;
        
        self.shouldRefreshLoopScrollView = YES;
        [self.flowLayout.viewModelDict setObject:self.serializing forKey:@"serializing"];
        [self.flowLayout.viewModelDict setObject:self.previous forKey:@"previous"];
        [self.flowLayout.viewModelDict setObject:@[] forKey:@"recommend"];
        self.flowLayout.refreshType = BangumiFlowLayoutRefreshAll;
        [self.collectionView reloadData];
        
    } error:^(NSError * _Nullable error) {
        _isNoData = YES;
        [self.collectionView.mj_header endRefreshing];
        [DdProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark 请求推荐数据
- (void)requestRecommendData:(BOOL)forceReload
{
    @weakify(self);
    [[[self.viewModel requestBangumiRecommendData:forceReload] execute:nil] subscribeNext:^(id x) {
        
        @strongify(self);
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        self.recommend = self.viewModel.recommend;
        [self.flowLayout.viewModelDict setObject:self.recommend forKey:@"recommend"];
        self.flowLayout.refreshType = BangumiFlowLayoutRefreshRecommend;
        [self.collectionView reloadData];
        
    } error:^(NSError * _Nullable error) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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
