//
//  DdForwardBackwardProgressHUD.h
//  Dilidili
//
//  Created by iMac on 16/9/10.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 快进/快退指示器
 */
@interface DdForwardBackwardProgressHUD : UIView

/** 当前视频播放时间 */
@property (nonatomic, assign) NSTimeInterval currentPlaybackTime;
/** 视频总时长 */
@property (nonatomic, assign)  NSTimeInterval duration;
/** 进退时长 */
@property (nonatomic, assign) NSTimeInterval seekingDuration;
/** 是否快进 */
@property (nonatomic, assign) BOOL isForward;
/** 是否取消 */
@property (nonatomic, assign, readonly) BOOL wasCancelled;

/**
 *  @brief 单例方法
 *
 *  @return 快进/快退指示器单例
 */
+ (instancetype)sharedProgressHUD;

/**
 *  @brief 展示
 */
- (void)show;

/**
 *  @brief 隐藏
 */
- (void)hide;

/**
 *  @brief 取消快进/快退
 */
- (void)cancel;

@end
