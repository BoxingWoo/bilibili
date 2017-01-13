//
//  DdReplyViewModel.h
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import "DdReplyListViewModel.h"

static NSString *const kvideoReplyCellID = @"DdVideoReplyCell";
static NSString *const kvideoReplySubCellID = @"DdVideoReplySubCell";
static NSString *const kvideoReplySectionFooterID = @"DdVideoReplySectionFooter";

/**
 *  @brief 评论视图模型
 */
@interface DdReplyViewModel : DdBasedViewModel

/** 视频标识 */
@property (nonatomic, copy) NSString *oid;
/** 页面信息 */
@property (nonatomic, copy) NSDictionary *page;
/** 热门评论数组 */
@property (nonatomic, copy) NSArray <DdReplyListViewModel *> *hots;
/** 回复视图模型数组 */
@property (nonatomic, strong) NSMutableArray <DdReplyListViewModel *> *replies;
/** 请求信息信号 */
@property (nonatomic, strong) RACSignal *replySignal;


/**
 *  @brief 配置单元格
 *
 *  @param cell      单元格
 *  @param indexPath indexPath
 *  @param isHot     是否热门评论
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath isHot:(BOOL)isHot;

/**
 *  @brief 单元格高度
 *
 *  @param tableView 表视图
 *  @param indexPath indexPath
 *  @param isHot     是否热门评论
 *
 *  @return 单元格高度
 */
- (CGFloat)heightForCellOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath isHot:(BOOL)isHot;

/**
 *  @brief 请求评论数据
 *
 *  @param pageNum 页数
 *
 *  @return RACCommand instance
 */
- (RACCommand *)requestReplyDataByPageNum:(NSUInteger)pageNum;

@end
