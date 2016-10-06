//
//  LiveModel.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdOwnerModel.h"

/**
 直播模型
 */
@interface LiveModel : NSObject

/**
 主播
 */
@property (nonatomic, strong) DdOwnerModel *owner;
/**
 封面
 */
@property (nonatomic, copy) NSString *cover;
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 房间号
 */
@property (nonatomic, assign) NSInteger room_id;
/**
 版本号
 */
@property (nonatomic, assign) NSInteger check_version;
/**
 在线人数
 */
@property (nonatomic, assign) NSUInteger online;
/**
 专区
 */
@property (nonatomic, copy) NSString *area;
/**
 专区号
 */
@property (nonatomic, assign) NSInteger area_id;
/**
 播放地址
 */
@property (nonatomic, copy) NSString *playurl;
/**
 质量
 */
@property (nonatomic, copy) NSString *accept_quality;
/**
 播放类型
 */
@property (nonatomic, assign) NSInteger broadcast_type;
/**
 是否电视节目
 */
@property (nonatomic, assign) BOOL is_tv;

@end
