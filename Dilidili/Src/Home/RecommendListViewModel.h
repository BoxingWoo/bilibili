//
//  RecommendListViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendSectionHeader.h"
#import "RecommendSectionFooter.h"
#import "RecommendBangumiFooter.h"
#import "RecommendCell.h"
#import "RecommendLiveCell.h"
#import "RecommendBangumiCell.h"
#import "RecommendScrollCell.h"
#import "RecommendListModel.h"

/**
 推荐列表视图模型
 */
@interface RecommendListViewModel : NSObject <BSLoopScrollViewDataSource>

/** 推荐列表数据 */
@property (nonatomic, strong, readonly) RecommendListModel *model;


/**
 *  @brief 构造方法
 *
 *  @param model 推荐列表模型
 *
 *  @return 推荐模块视图模型实例
 */
- (instancetype)initWithModel:(RecommendListModel *)model;

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

@end
