//
//  RecommendModel.h
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 推荐内容模型
 */
@interface RecommendModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 封面 */
@property (nonatomic, copy) NSString *cover;
/** URI */
@property (nonatomic, copy) NSString *uri;
/** 标识 */
@property (nonatomic, copy) NSString *param;
/** 跳转类型 */
@property (nonatomic, copy) NSString *go;

#pragma mark 普通类型
/** 播放数 */
@property (nonatomic, assign) NSUInteger play;
/** 弹幕数 */
@property (nonatomic, assign) NSUInteger danmaku;

#pragma mark 直播类型
/** 区域 */
@property (nonatomic, copy) NSString *area;
/** 区域ID */
@property (nonatomic, assign) NSInteger area_id;
/** up主名字 */
@property (nonatomic, copy) NSString *name;
/** up主头像 */
@property (nonatomic, copy) NSString *face;
/** 在线观看人数 */
@property (nonatomic, assign) NSUInteger online;

#pragma mark 番剧类型
/** 第几话 */
@property (nonatomic, copy) NSString *index;
/** 番剧更新时间 */
@property (nonatomic, copy) NSString *mtime;

@end
