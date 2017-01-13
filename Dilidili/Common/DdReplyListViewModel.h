//
//  DdReplyListViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/10.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdReplyModel.h"
#import "DdVideoReplyCell.h"
#import "DdVideoReplySubCell.h"
#import "DdVideoReplySectionFooter.h"

/**
 评论列表视图模型
 */
@interface DdReplyListViewModel : NSObject

/** 评论模型 */
@property (nonatomic, strong) DdReplyModel *model;
/** 回复视图模型数组 */
@property (nonatomic, copy) NSArray <DdReplyListViewModel *> *replies;

/**
 *  @brief 构造方法
 *
 *  @param model 模型
 *
 *  @return 评论视图模型实例
 */
- (instancetype)initWithModel:(DdReplyModel *)model;

@end
