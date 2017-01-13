//
//  LiveViewModel.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import "LiveListViewModel.h"

static NSString *const kliveHeaderViewID = @"LiveHeaderView";
static NSString *const kliveFooterViewID = @"LiveFooterView";
static NSString *const kliveSectionHeaderID = @"LiveSectionHeader";
static NSString *const kliveCellID = @"LiveCell";
static NSString *const kliveRefreshCellID = @"LiveRefreshCell";
static NSString *const kliveBannerCellID = @"LiveBannerCell";

/**
 直播视图模型
 */
@interface LiveViewModel : DdBasedViewModel

/**
 直播列表视图模型数组
 */
@property (nonatomic, strong) NSMutableArray <LiveListViewModel *> *lives;
/** 
 直播横幅广告数组 
 */
@property (nonatomic, copy) NSArray <LiveBannerModel *> *banners;

/**
 配置单元格
 
 @param cell      单元格
 @param indexPath indexPath
 */
- (void)configureCell:(LiveCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 配置直播列表头部视图

 @param sectionHeader 直播列表头部视图
 @param section       索引
 */
- (void)configureSectionHeader:(LiveSectionHeader *)sectionHeader atIndex:(NSInteger)section;


/**
 请求直播模块数据
 
 @param  forceReload 是否强制刷新
 @return RACCommand instance
 */
- (RACCommand *)requestLiveData:(BOOL)forceReload;

@end
