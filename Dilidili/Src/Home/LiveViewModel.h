//
//  LiveViewModel.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveListModel.h"
#import "LiveBannerModel.h"
#import "LiveHeaderView.h"
#import "LiveFooterView.h"
#import "LiveSectionHeader.h"
#import "LiveCell.h"

static NSString *const liveHeaderViewID = @"LiveHeaderView";
static NSString *const liveFooterViewID = @"LiveFooterView";
static NSString *const liveSectionHeaderID = @"LiveSectionHeader";
static NSString *const liveCellID = @"LiveCell";
static NSString *const liveRefreshCellID = @"LiveRefreshCell";
static NSString *const liveBannerCellID = @"LiveBannerCell";

/**
 直播视图模型
 */
@interface LiveViewModel : NSObject

/**
 直播列表模型
 */
@property (nonatomic, strong) LiveListModel *model;

/**
 构造方法

 @param model 直播列表模型

 @return 直播视图模型实例
 */
- (instancetype)initWithModel:(LiveListModel *)model;

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
 刷新直播列表数据
 
 @param section       索引
 @return RACCommand instance
 */
- (RACCommand *)refreshLiveDataAtIndex:(NSInteger)section;


/**
 请求直播模块数据
 
 @param  forceReload 是否强制刷新
 @return RACCommand instance
 */
+ (RACCommand *)requestLiveData:(BOOL)forceReload;

@end
