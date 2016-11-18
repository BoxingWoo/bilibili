//
//  DdReplyViewModel.h
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdReplyModel.h"
#import "DdVideoReplyCell.h"
#import "DdVideoReplySubCell.h"
#import "DdVideoReplySectionFooter.h"

static NSString *const kvideoReplyCellID = @"DdVideoReplyCell";
static NSString *const kvideoReplySubCellID = @"DdVideoReplySubCell";
static NSString *const kvideoReplySectionFooterID = @"DdVideoReplySectionFooter";

/**
 *  @brief 评论视图模型
 */
@interface DdReplyViewModel : NSObject

/** 评论模型 */
@property (nonatomic, strong) DdReplyModel *model;
/** 回复视图模型数组 */
@property (nonatomic, copy) NSArray <DdReplyViewModel *> *replies;
/** 是否回复的视图模型 */
@property (nonatomic, assign) BOOL isSub;
/** 是否热门评论 */
@property (nonatomic, assign) BOOL isHot;

/**
 *  @brief 构造方法
 *
 *  @param model 模型
 *
 *  @return 评论视图模型实例
 */
- (instancetype)initWithModel:(DdReplyModel *)model;

/**
 *  @brief 配置单元格
 *
 *  @param cell      单元格
 *  @param indexPath indexPath
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief 单元格高度
 *
 *  @param tableView 表视图
 *  @param indexPath indexPath
 *
 *  @return 单元格高度
 */
- (CGFloat)heightForCellOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief 请求评论数据
 *
 *  @param oid     标识
 *  @param pageNum 页数
 *
 *  @return RACCommand instance
 */
+ (RACCommand *)requestReplyDataByOid:(NSString *)oid pageNum:(NSUInteger)pageNum;

@end
