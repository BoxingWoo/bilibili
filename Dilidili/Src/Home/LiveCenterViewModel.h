//
//  LiveCenterViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/12.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import "LiveCenterCell.h"
#import "LiveCenterSectionHeader.h"

static NSString *const kliveCenterCellID = @"LiveCenterCell";
static NSString *const kliveCenterSectionHeaderID = @"LiveCenterSectionHeader";

/**
 直播中心视图模型
 */
@interface LiveCenterViewModel : DdBasedViewModel

/**
 数据数组
 */
@property (nonatomic, copy) NSArray *dataArr;

/**
 *  @brief 配置单元格
 *
 *  @param cell      单元格
 *  @param indexPath indexPath
 */
- (void)configureCell:(LiveCenterCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief 配置推荐列表头部视图
 *
 *  @param sectionHeader 列表头部视图
 *  @param section       索引
 */
- (void)configureSectionHeader:(LiveCenterSectionHeader *)sectionHeader atIndex:(NSInteger)section;

@end
