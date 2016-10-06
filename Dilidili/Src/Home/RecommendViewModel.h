//
//  RecommendViewModel.h
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendListModel.h"
#import "RecommendSectionHeader.h"
#import "RecommendSectionFooter.h"
#import "RecommendBangumiFooter.h"
#import "RecommendCell.h"
#import "RecommendLiveCell.h"
#import "RecommendBangumiCell.h"
#import "RecommendScrollCell.h"

#import <pop/POP.h>

static NSString *const recommendSectionHeaderID = @"RecommendSectionHeader";
static NSString *const recommendBannerSectionHeaderID = @"RecommendBannerSectionHeader";
static NSString *const recommendSectionFooterID = @"RecommendSectionFooter";
static NSString *const recommendBangumiFooterID = @"RecommendBangumiFooter";
static NSString *const recommendCellID = @"RecommendCell";
static NSString *const recommendRefreshCellID = @"RecommendRefreshCell";
static NSString *const recommendLiveCellID = @"RecommendLiveCell";
static NSString *const recommendBangumiCellID = @"RecommendBangumiCell";
static NSString *const recommendScrollCellID = @"RecommendScrollCell";

/**
 *  @brief 推荐模块视图模型
 */
@interface RecommendViewModel : NSObject

/** 推荐列表数据 */
@property (nonatomic, strong) RecommendListModel *model;


/**
 *  @brief 构造方法
 *
 *  @param model 推荐列表模型
 *
 *  @return 推荐模块视图模型实例
 */
- (instancetype)initWithModel:(RecommendListModel *)model;

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
 *  @brief 单元格大小
 *
 *  @return 单元格大小
 */
- (CGSize)cellSize;

/**
 *  @brief 推荐列表头部视图高度
 *
 *  @return 推荐列表头部视图高度
 */
- (CGFloat)sectionHeaderHeight;

/**
 *  @brief 推荐列表尾部视图高度
 *
 *  @return 推荐列表尾部视图高度
 */
- (CGFloat)sectionFooterHeight;

/**
 *  @brief 刷新推荐列表数据
 *
 *  @return RACCommand instance
 */
- (RACCommand *)refreshRecommendData;


/**
 *  @brief 请求推荐模块数据
 *
 *  @param  forceReload 是否强制刷新
 *  @return RACCommand instance
 */
+ (RACCommand *)requestRecommendData:(BOOL)forceReload;

@end
