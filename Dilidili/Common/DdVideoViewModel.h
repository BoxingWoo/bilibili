//
//  DdVideoViewModel.h
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdVideoModel.h"

/**
 *  @brief 视频视图模型
 */
@interface DdVideoViewModel : NSObject

/** 视频模型 */
@property (nonatomic, strong) DdVideoModel *model;
/** 视频URL */
@property (nonatomic, copy) NSURL *contentURL;

/**
 *  @brief 构造方法
 *
 *  @param model 视频模型
 *
 *  @return 视频视图模型实例
 */
- (instancetype)initWithModel:(DdVideoModel *)model;

/**
 *  @brief 获取视频播放链接
 *  @return RACCommand instance
 */
+ (RACCommand *)requestVideoPathByAid:(NSString *)aid;

/**
 *  @brief 获取视频信息链接
 *
 *  @param aid  视频标识
 *  @param from 分类标识
 *
 *  @return RACCommand instance
 */
+ (RACCommand *)requestVideoInfoByAid:(NSString *)aid from:(NSString *)from;


@end
