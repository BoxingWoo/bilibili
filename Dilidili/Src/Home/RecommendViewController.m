//
//  RecommendViewController.m
//  Dilidili
//
//  Created by iMac on 16/8/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendViewController.h"
#import "DdCollectionView.h"
#import "DdProgressHUD.h"
#import "DdRefreshHeader.h"
#import "RecommendViewModel.h"

@interface RecommendViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BSLoopScrollViewDelegate>

@property (nonatomic, weak) DdCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <RecommendViewModel *> *dataArr;

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

- (NSMutableArray<RecommendViewModel *> *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)createUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.0;
    flowLayout.minimumLineSpacing = 8.0;
    DdCollectionView *collectionView = [[DdCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView = collectionView;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = kBgColor;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    collectionView.scrollIndicatorInsets = collectionView.contentInset;
    
    [collectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:recommendCellID];
    [collectionView registerClass:[RecommendRefreshCell class] forCellWithReuseIdentifier:recommendRefreshCellID];
    [collectionView registerClass:[RecommendLiveCell class] forCellWithReuseIdentifier:recommendLiveCellID];
    [collectionView registerClass:[RecommendBangumiCell class] forCellWithReuseIdentifier:recommendBangumiCellID];
    [collectionView registerClass:[RecommendScrollCell class] forCellWithReuseIdentifier:recommendScrollCellID];
    [collectionView registerClass:[RecommendSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:recommendSectionHeaderID];
    [collectionView registerClass:[RecommendBannerSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:recommendBannerSectionHeaderID];
    [collectionView registerClass:[RecommendSectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:recommendSectionFooterID];
    [collectionView registerClass:[RecommendBangumiFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:recommendBangumiFooterID];
    
    collectionView.mj_header = [DdRefreshHeader headerWithRefreshingBlock:^{
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
    RecommendViewModel *viewModel = self.dataArr[section];
    if ([viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        return 1;
    }else {
        return viewModel.model.body.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendViewModel *viewModel = self.dataArr[indexPath.section];
    if ([viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        
        RecommendScrollCell *scrollCell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendScrollCellID forIndexPath:indexPath];
        [viewModel configureCell:scrollCell atIndexPath:indexPath];
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
            RecommendLiveCell *liveCell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendLiveCellID forIndexPath:indexPath];
            cell = liveCell;
            NSArray *actions = [liveCell.refreshBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
            if (![actions containsObject:NSStringFromSelector(@selector(handleRefresh:))]) {
                [liveCell.refreshBtn addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else if ([viewModel.model.type isEqualToString:RecommendTypeBangumi]) {
            RecommendBangumiCell *bangumiCell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendBangumiCellID forIndexPath:indexPath];
            cell = bangumiCell;
        }else {
            if (indexPath.item == viewModel.model.body.count - 1) {
                RecommendRefreshCell *refreshCell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendRefreshCellID forIndexPath:indexPath];
                cell = refreshCell;
                NSArray *actions = [refreshCell.refreshBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
                if (![actions containsObject:NSStringFromSelector(@selector(handleRefresh:))]) {
                    [refreshCell.refreshBtn addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventTouchUpInside];
                }
            }else {
                RecommendCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendCellID forIndexPath:indexPath];
                cell = normalCell;
            }
        }
        [viewModel configureCell:cell atIndexPath:indexPath];
        return cell;
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RecommendViewModel *viewModel = self.dataArr[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RecommendSectionHeader *sectionHeader;
        if (viewModel.model.bannerTop.count > 0) {
            sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:recommendBannerSectionHeaderID forIndexPath:indexPath];
            RecommendBannerSectionHeader *bannerSectionHeader = (RecommendBannerSectionHeader *)sectionHeader;
            bannerSectionHeader.loopScrollView.delegate = self;
        }else {
            sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:recommendSectionHeaderID forIndexPath:indexPath];
        }
        [viewModel configureSectionHeader:sectionHeader atIndex:indexPath.section];
        sectionHeader.moreBtn.tag = indexPath.section;
        NSArray *actions = [sectionHeader.moreBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if (![actions containsObject:NSStringFromSelector(@selector(handleMore:))]) {
            [sectionHeader.moreBtn addTarget:self action:@selector(handleMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        return sectionHeader;
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if ([viewModel.model.type isEqualToString:RecommendTypeBangumi]) {
            RecommendBangumiFooter *bangumiFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:recommendBangumiFooterID forIndexPath:indexPath];
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
                RecommendSectionFooter *secionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:recommendSectionFooterID forIndexPath:indexPath];
                [viewModel configureSectionFooter:secionFooter atIndex:indexPath.section];
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
    RecommendViewModel *viewModel = self.dataArr[section];
    if ([viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        return UIEdgeInsetsZero;
    }else {
        return UIEdgeInsetsMake(8, 10, 8, 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendViewModel *viewModel = self.dataArr[indexPath.section];
    return viewModel.cellSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    RecommendViewModel *viewModel = self.dataArr[section];
    return CGSizeMake(collectionView.width, viewModel.sectionHeaderHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    RecommendViewModel *viewModel = self.dataArr[section];
    return CGSizeMake(collectionView.width, viewModel.sectionFooterHeight);
}

#pragma mark - CollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendViewModel *viewModel = self.dataArr[indexPath.section];
    if (![viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        
    }
}

#pragma mark - LoopScrollViewDelegate

- (void)loopScrollView:(BSLoopScrollView *)loopScrollView didTouchContentView:(UIView *)contentView atIndex:(NSUInteger)index
{
    RecommendViewModel *viewModel = self.dataArr[loopScrollView.tag];
    BannerModel *bannerModel;
    if ([loopScrollView.superview isKindOfClass:[RecommendSectionHeader class]]) {
        bannerModel = viewModel.model.bannerTop[index];
    }else if ([loopScrollView.superview isKindOfClass:[RecommendSectionFooter class]]) {
        bannerModel = viewModel.model.bannerBottom[index];
    }
    [DCURLRouter pushURLString:bannerModel.uri animated:YES];
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
    RecommendViewModel *viewModel = self.dataArr[button.tag];
    [[[viewModel refreshRecommendData] execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:button.tag]];
    } error:^(NSError *error) {
        [DdProgressHUD showErrorWithStatus:error.localizedDescription];
    } completed:^{
        button.enabled = YES;
        [button.layer pop_removeAnimationForKey:@"refresh_rotate"];
        button.layer.transform = CATransform3DIdentity;
    }];
}

#pragma mark 跳转
- (void)handleLink:(UIControl *)sender
{
    
}

#pragma mark - Utility
#pragma mark 请求数据
- (void)requestData:(BOOL)forceReload
{
    [[[RecommendViewModel requestRecommendData:forceReload] execute:nil] subscribeNext:^(NSArray *modelArr) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.dataArr removeAllObjects];
        for (RecommendListModel *model in modelArr) {
            RecommendViewModel *viewModel = [[RecommendViewModel alloc] initWithModel:model];
            [self.dataArr addObject:viewModel];
        }
        [self.collectionView reloadData];
        
    } error:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [DdProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
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
