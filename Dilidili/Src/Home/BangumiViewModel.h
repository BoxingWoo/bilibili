//
//  BangumiViewModel.h
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import "BangumiListViewModel.h"

static NSString *const kBangumiHeaderViewID = @"BangumiHeaderView";
static NSString *const kBangumiSectionHeaderID = @"BangumiSectionHeader";
static NSString *const kBangumiSectionFooterID = @"BangumiSectionFooter";
static NSString *const kBangumiGirdCellID = @"BangumiGirdCell";
static NSString *const kBangumiListCellID = @"BangumiListCell";

/**
 番剧视图模型
 */
@interface BangumiViewModel : DdBasedViewModel

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
@property (nonatomic, strong) NSMutableArray <BangumiListViewModel *> *recommend;
/**
 广告
 */
@property (nonatomic, copy) NSDictionary *ad;
/**
 季度
 */
@property (nonatomic, assign) NSUInteger season;

/**
 配置单元格
 
 @param cell      单元格
 @param indexPath indexPath
 */
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 单元格大小

 @param cell      单元格
 @param indexPath indexPath
 @return 单元格大小
 */
- (CGSize)cellSize:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 请求番剧索引列表数据
 
 @param  forceReload 是否强制刷新
 @return RACCommand instance
 */
- (RACCommand *)requestBangumiIndexData:(BOOL)forceReload;


/**
 请求番剧推荐列表数据
 
 @param  forceReload 是否强制刷新
 @return RACCommand instance
 */
- (RACCommand *)requestBangumiRecommendData:(BOOL)forceReload;

@end
