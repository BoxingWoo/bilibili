//
//  DdStatModel.h
//  Dilidili
//
//  Created by iMac on 16/9/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 统计模型
 */
@interface DdStatModel : NSObject

/** 浏览数 */
@property (nonatomic, assign) NSUInteger view;
/** 弹幕数 */
@property (nonatomic, assign) NSUInteger danmaku;
/** 评论数 */
@property (nonatomic, assign) NSUInteger reply;
/** 收藏数 */
@property (nonatomic, assign) NSUInteger favorite;
/** 硬币数 */
@property (nonatomic, assign) NSUInteger coin;
/** 分享数 */
@property (nonatomic, assign) NSUInteger share;
/** 评级 */
@property (nonatomic, assign) NSUInteger now_rank;
/** 历史评级 */
@property (nonatomic, assign) NSUInteger his_rank;

@end
