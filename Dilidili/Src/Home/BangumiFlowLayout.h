//
//  BangumiFlowLayout.h
//  Dilidili
//
//  Created by iMac on 2016/11/14.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 番剧列表流式布局刷新类型

 - BangumiFlowLayoutRefreshAll: 刷新所有
 - BangumiFlowLayoutRefreshRecommend: 刷新推荐
 */
typedef NS_ENUM(NSInteger, BangumiFlowLayoutRefreshType) {
    BangumiFlowLayoutRefreshAll = 0,
    BangumiFlowLayoutRefreshRecommend = 1
};

@class BangumiViewModel;

extern NSString *const kBangumiCollectionElementKindHeaderView;  //番剧集合视图头部视图标识

/**
 番剧列表流式布局
 */
@interface BangumiFlowLayout : UICollectionViewFlowLayout

/**
 番剧视图模型字典
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *viewModelDict;
/**
 番剧列表流式布局刷新类型
 */
@property (nonatomic, assign) BangumiFlowLayoutRefreshType refreshType;

@end
