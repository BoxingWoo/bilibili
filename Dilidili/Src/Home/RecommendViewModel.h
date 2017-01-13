//
//  RecommendViewModel.h
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import "RecommendListViewModel.h"

#import <pop/POP.h>

static NSString *const krecommendSectionHeaderID = @"RecommendSectionHeader";
static NSString *const krecommendBannerSectionHeaderID = @"RecommendBannerSectionHeader";
static NSString *const krecommendSectionFooterID = @"RecommendSectionFooter";
static NSString *const krecommendBangumiFooterID = @"RecommendBangumiFooter";
static NSString *const krecommendCellID = @"RecommendCell";
static NSString *const krecommendRefreshCellID = @"RecommendRefreshCell";
static NSString *const krecommendLiveCellID = @"RecommendLiveCell";
static NSString *const krecommendBangumiCellID = @"RecommendBangumiCell";
static NSString *const krecommendScrollCellID = @"RecommendScrollCell";

/**
 *  @brief 推荐模块视图模型
 */
@interface RecommendViewModel : DdBasedViewModel

@property (nonatomic, copy) NSArray <RecommendListViewModel *> *dataArr;

/**
 *  @brief 配置单元格
 *
 *  @param cell      单元格
 *  @param indexPath indexPath
 */
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief 配置推荐列表头部视图
 *
 *  @param sectionHeader 推荐列表头部视图
 *  @param section       索引
 */
- (void)configureSectionHeader:(RecommendSectionHeader *)sectionHeader atIndex:(NSInteger)section;

/**
 *  @brief 配置推荐列表尾部视图
 *
 *  @param sectionFooter 推荐列表尾部视图
 *  @param section       索引
 */
- (void)configureSectionFooter:(RecommendSectionFooter *)sectionFooter atIndex:(NSInteger)section;


/**
 *  @brief 请求推荐模块数据
 *
 *  @param  forceReload 是否强制刷新
 *  @return RACCommand instance
 */
- (RACCommand *)requestRecommendData:(BOOL)forceReload;

@end
