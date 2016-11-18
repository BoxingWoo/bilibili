//
//  BangumiListModel.h
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 番剧列表模型
 */
@interface BangumiListModel : NSObject

/**
 封面
 */
@property (nonatomic, copy) NSString *cover;
/**
 收藏数
 */
@property (nonatomic, copy) NSString *favourites;
/**
 是否完结
 */
@property (nonatomic, assign) BOOL is_finish;
/**
 是否开播
 */
@property (nonatomic, assign) BOOL is_started;
/**
 上次更新
 */
@property (nonatomic, assign) NSTimeInterval last_time;
/**
 最新回
 */
@property (nonatomic, copy) NSString *newest_ep_index;
/**
 发布时间
 */
@property (nonatomic, assign) NSTimeInterval pub_time;
/**
 季ID
 */
@property (nonatomic, assign) NSInteger season_id;
/**
 季状态
 */
@property (nonatomic, assign) NSInteger season_status;
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 观看数量
 */
@property (nonatomic, assign) NSUInteger watching_count;


/**
 指示器
 */
@property (nonatomic, assign) NSInteger cursor;
/**
 描述
 */
@property (nonatomic, copy) NSString *desc;
/**
 标识
 */
@property (nonatomic, assign) NSInteger bangumi_id;
/**
 是否新番
 */
@property (nonatomic, assign) BOOL is_new;
/**
 链接
 */
@property (nonatomic, copy) NSString *link;
/**
 更新时间
 */
@property (nonatomic, copy) NSString *onDt;

@end
