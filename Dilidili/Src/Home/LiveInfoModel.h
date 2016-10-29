//
//  LiveInfoModel.h
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveScheduleModel.h"
#import "LiveMetaModel.h"
#import "LiveHotWordModel.h"
#import "LiveGiftModel.h"
#import "LiveModel.h"

/**
 直播信息模型
 */
@interface LiveInfoModel : NSObject

/**
 房间ID
 */
@property (nonatomic, assign) NSInteger room_id;
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 封面
 */
@property (nonatomic, copy) NSString *cover;
/**
 标识
 */
@property (nonatomic, assign) NSInteger mid;
/**
 用户名称
 */
@property (nonatomic, copy) NSString *uname;
/**
 头像
 */
@property (nonatomic, copy) NSString *face;
/**
 头像
 */
@property (nonatomic, copy) NSString *m_face;
/**
 背景ID
 */
@property (nonatomic, assign) NSInteger background_id;
/**
 关注数
 */
@property (nonatomic, assign) NSUInteger attention;
/**
 是否关注
 */
@property (nonatomic, assign) BOOL is_attention;
/**
 在线人数
 */
@property (nonatomic, assign) NSUInteger online;
/**
 创建日期
 */
@property (nonatomic, assign) NSTimeInterval create;
/**
 创建日期
 */
@property (nonatomic, copy) NSString *create_at;
/**
 时间表ID
 */
@property (nonatomic, assign) NSInteger sch_id;
/**
 状态
 */
@property (nonatomic, copy) NSString *status;
/**
 分区
 */
@property (nonatomic, copy) NSString *area;
/**
 分区ID
 */
@property (nonatomic, assign) NSInteger are_id;
/**
 cmt
 */
@property (nonatomic, copy) NSString *cmt;
/**
 cmt_port
 */
@property (nonatomic, copy) NSString *cmt_port;
/**
 cmt_port_goim
 */
@property (nonatomic, copy) NSString *cmt_port_goim;
/**
 是否vip
 */
@property (nonatomic, assign) BOOL isvip;
/**
 打开时间
 */
@property (nonatomic, assign) NSUInteger opentime;
/**
 准备标题
 */
@property (nonatomic, copy) NSString *prepare;
/**
 是否管理员
 */
@property (nonatomic, assign) BOOL isadmin;
/**
 信息长度
 */
@property (nonatomic, assign) NSUInteger msg_length;
/**
 大师等级
 */
@property (nonatomic, assign) NSUInteger master_level;
/**
 大师等级颜色值
 */
@property (nonatomic, assign) int master_level_color;
/**
 广播类型
 */
@property (nonatomic, assign) NSInteger broadcast_type;
/**
 检查版本
 */
@property (nonatomic, assign) NSInteger check_version;
/**
 活动ID
 */
@property (nonatomic, assign) NSInteger activity_id;
/**
 事件数组
 */
@property (nonatomic, copy) NSArray *event_corner;
/**
 直播时间表
 */
@property (nonatomic, strong) LiveScheduleModel *schedule;
/**
 直播元数据
 */
@property (nonatomic, strong) LiveMetaModel *meta;
/**
 推荐直播数组
 */
@property (nonatomic, copy) NSArray <LiveModel *> *recommend;
/**
 顶部展示
 */
@property (nonatomic, copy) NSArray *toplist;
/**
 热门关键字数组
 */
@property (nonatomic, copy) NSArray <LiveHotWordModel *> *hot_word;
/**
 房间礼物数组
 */
@property (nonatomic, copy) NSArray <LiveGiftModel *> *roomgifts;
/**
 忽略的礼物数组
 */
@property (nonatomic, copy) NSArray <LiveGiftModel *> *ignore_gift;
/**
 活动礼物数组
 */
@property (nonatomic, copy) NSArray <LiveGiftModel *> *activity_gift;

@end
