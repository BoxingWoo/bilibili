//
//  RecommendViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DdProgressHUD.h"
#import "DdRefreshMainHeader.h"
#import "RecommendViewModel.h"

@interface RecommendViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BSLoopScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL _isNoData;  // 没有数据
}

@property (nonatomic, strong) RecommendViewModel *viewModel;
/** 集合视图 */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 推荐模块视图模型数组 */
@property (nonatomic, copy) NSArray <RecommendListViewModel *> *dataArr;

@end

@implementation RecommendViewController

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

- (void)createUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 8.0;
    flowLayout.minimumLineSpacing = 8.0;
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
    
    [collectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:krecommendCellID];
    [collectionView registerClass:[RecommendRefreshCell class] forCellWithReuseIdentifier:krecommendRefreshCellID];
    [collectionView registerClass:[RecommendLiveCell class] forCellWithReuseIdentifier:krecommendLiveCellID];
    [collectionView registerClass:[RecommendBangumiCell class] forCellWithReuseIdentifier:krecommendBangumiCellID];
    [collectionView registerClass:[RecommendScrollCell class] forCellWithReuseIdentifier:krecommendScrollCellID];
    [collectionView registerClass:[RecommendSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:krecommendSectionHeaderID];
    [collectionView registerClass:[RecommendBannerSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:krecommendBannerSectionHeaderID];
    [collectionView registerClass:[RecommendSectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:krecommendSectionFooterID];
    [collectionView registerClass:[RecommendBangumiFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:krecommendBangumiFooterID];
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
    RecommendListViewModel *viewModel = self.dataArr[section];
    if ([viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        return 1;
    }else {
        return viewModel.model.body.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendListViewModel *viewModel = self.dataArr[indexPath.section];
    if ([viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        
        RecommendScrollCell *scrollCell = [collectionView dequeueReusableCellWithReuseIdentifier:krecommendScrollCellID forIndexPath:indexPath];
        [self.viewModel configureCell:scrollCell atIndexPath:indexPath];
        for (RecommendScrollContentView *contentView in scrollCell.contentViews) {
            NSArray *actions = [contentView actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
            if (![actions containsObject:NSStringFromSelector(@selector(handleLink:))]) {
                [contentView addTarget:self action:@selector(handleLink:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        return scrollCell;
        
    }else {
        
        UICollectionViewCell *cell;
        if ([viewModel.model.type isEqualToString:RecommendTypeLive]) {
            RecommendLiveCell *liveCell = [collectionView dequeueReusableCellWithReuseIdentifier:krecommendLiveCellID forIndexPath:indexPath];
            cell = liveCell;
            NSArray *actions = [liveCell.refreshBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
            if (![actions containsObject:NSStringFromSelector(@selector(handleRefresh:))]) {
                [liveCell.refreshBtn addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else if ([viewModel.model.type isEqualToString:RecommendTypeBangumi]) {
            RecommendBangumiCell *bangumiCell = [collectionView dequeueReusableCellWithReuseIdentifier:krecommendBangumiCellID forIndexPath:indexPath];
            cell = bangumiCell;
        }else {
            if (indexPath.item == viewModel.model.body.count - 1) {
                RecommendRefreshCell *refreshCell = [collectionView dequeueReusableCellWithReuseIdentifier:krecommendRefreshCellID forIndexPath:indexPath];
                cell = refreshCell;
                NSArray *actions = [refreshCell.refreshBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
                if (![actions containsObject:NSStringFromSelector(@selector(handleRefresh:))]) {
                    [refreshCell.refreshBtn addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventTouchUpInside];
                }
            }else {
                RecommendCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:krecommendCellID forIndexPath:indexPath];
                cell = normalCell;
            }
        }
        [self.viewModel configureCell:cell atIndexPath:indexPath];
        return cell;
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RecommendListViewModel *viewModel = self.dataArr[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RecommendSectionHeader *sectionHeader;
        if (viewModel.model.bannerTop.count > 0) {
            sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:krecommendBannerSectionHeaderID forIndexPath:indexPath];
            RecommendBannerSectionHeader *bannerSectionHeader = (RecommendBannerSectionHeader *)sectionHeader;
            bannerSectionHeader.loopScrollView.delegate = self;
        }else {
            sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:krecommendSectionHeaderID forIndexPath:indexPath];
        }
        [self.viewModel configureSectionHeader:sectionHeader atIndex:indexPath.section];
        sectionHeader.moreBtn.tag = indexPath.section;
        NSArray *actions = [sectionHeader.moreBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if (![actions containsObject:NSStringFromSelector(@selector(handleMore:))]) {
            [sectionHeader.moreBtn addTarget:self action:@selector(handleMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        return sectionHeader;
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if ([viewModel.model.type isEqualToString:RecommendTypeBangumi]) {
            RecommendBangumiFooter *bangumiFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:krecommendBangumiFooterID forIndexPath:indexPath];
            //Timeline
            bangumiFooter.timelineBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                    [subscriber sendCompleted];
                    return nil;
                }];
                return signal;
            }];
            //Category
            bangumiFooter.categoryBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    
                    [subscriber sendCompleted];
                    return nil;
                }];
                return signal;
            }];
            return bangumiFooter;
        }else {
            if (viewModel.model.bannerBottom.count > 0) {
                RecommendSectionFooter *secionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:krecommendSectionFooterID forIndexPath:indexPath];
                [self.viewModel configureSectionFooter:secionFooter atIndex:indexPath.section];
                secionFooter.loopScrollView.delegate = self;
                return secionFooter;
            }
        }
        
    }
    return nil;
}


#pragma mark - CollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    RecommendListViewModel *viewModel = self.dataArr[section];
    if ([viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        return UIEdgeInsetsZero;
    }else {
        return UIEdgeInsetsMake(8, 10, 8, 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendListViewModel *viewModel = self.dataArr[indexPath.section];
    return viewModel.cellSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    RecommendListViewModel *viewModel = self.dataArr[section];
    return CGSizeMake(collectionView.width, viewModel.sectionHeaderHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    RecommendListViewModel *viewModel = self.dataArr[section];
    return CGSizeMake(collectionView.width, viewModel.sectionFooterHeight);
}

#pragma mark - CollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendListViewModel *viewModel = self.dataArr[indexPath.section];
    if (![viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        RecommendModel *model = viewModel.model.body[indexPath.item];
        [DdViewModelRouter pushURLString:model.uri params:@{@"from":viewModel.model.param, @"title":model.title, @"cover":model.cover} animated:YES replace:NO];
    }
}

#pragma mark - LoopScrollViewDelegate

- (void)loopScrollView:(BSLoopScrollView *)loopScrollView didTouchContentView:(UIView *)contentView atIndex:(NSUInteger)index
{
    RecommendListViewModel *viewModel = self.dataArr[loopScrollView.tag];
    BannerModel *bannerModel;
    if ([loopScrollView.superview isKindOfClass:[RecommendSectionHeader class]]) {
        bannerModel = viewModel.model.bannerTop[index];
    }else if ([loopScrollView.superview isKindOfClass:[RecommendSectionFooter class]]) {
        bannerModel = viewModel.model.bannerBottom[index];
    }
    [DdViewModelRouter pushURLString:bannerModel.uri params:@{@"from":viewModel.model.param, @"title":bannerModel.title, @"cover":bannerModel.image} animated:YES replace:NO];
}

#pragma mark - HandleAction
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
    RecommendListViewModel *viewModel = self.dataArr[button.tag];
    [[[viewModel refreshRecommendData] execute:nil] subscribeNext:^(id x) {
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

#pragma mark 跳转
- (void)handleLink:(RecommendScrollContentView *)sender
{
    RecommendListViewModel *viewModel = self.dataArr[sender.indexPath.section];
    RecommendModel *model = viewModel.model.body[sender.indexPath.item];
    [DdViewModelRouter pushURLString:model.uri animated:YES];
}

#pragma mark - Utility
#pragma mark 请求数据
- (void)requestData:(BOOL)forceReload
{
    _isNoData = NO;
    @weakify(self);
    [[[self.viewModel requestRecommendData:forceReload] execute:nil] subscribeNext:^(NSArray *dataArr) {
        @strongify(self);
        [self.collectionView.mj_header endRefreshing];
        self.dataArr = dataArr;
        [self.collectionView reloadData];
    } error:^(NSError *error) {
        @strongify(self);
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
