//
//  LiveScheduleModel.h
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播时间表模型
 */
@interface LiveScheduleModel : NSObject

/**
 标识
 */
@property (nonatomic, assign) NSInteger cid;
/**
 时间表标识
 */
@property (nonatomic, assign) NSInteger sch_id;
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 标识
 */
@property (nonatomic, assign) NSInteger mid;
/**
 管理员数组
 */
@property (nonatomic, copy) NSArray *manager;
/**
 开始时间
 */
@property (nonatomic, assign) NSTimeInterval start;
/**
 开始时间
 */
@property (nonatomic, copy) NSString *start_at;
/**
 标识
 */
@property (nonatomic, assign) NSInteger aid;
/**
 流标识
 */
@property (nonatomic, assign) NSInteger stream_id;
/**
 在线人数
 */
@property (nonatomic, assign) NSUInteger online;
/**
 状态
 */
@property (nonatomic, copy) NSString *status;
/**
 元数据ID
 */
@property (nonatomic, assign) NSInteger meta_id;
/**
 等待中的元数据ID
 */
@property (nonatomic, assign) NSInteger pending_meta_id;

@end
