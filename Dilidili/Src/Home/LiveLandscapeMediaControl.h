//
//  LiveLandscapeMediaControl.h
//  Dilidili
//
//  Created by iMac on 2016/10/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveInfoModel.h"

@protocol IJKMediaPlayback;
@class DdDanmakuViewController;

/**
 *  @brief 直播横屏媒体控制器
 */
@interface LiveLandscapeMediaControl : UIView

/** 视频信息 */
@property (nonatomic, strong) LiveInfoModel *model;
/** 返回命令 */
@property (nonatomic, weak) RACCommand *handleBackCommand;
/** 屏幕方向切换命令 */
@property (nonatomic, weak) RACCommand *handleFullScreenCommand;
/** 更多命令 */
@property (nonatomic, weak) RACCommand *handleMoreCommand;
/** 显示/隐藏状态栏命令 */
@property (nonatomic, weak) RACCommand *handleStatusBarHiddenCommand;
/** 状态栏隐藏状态 */
@property (nonatomic, assign) BOOL statusBarHidden;
/** 媒体播放器 */
@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;
/** 弹幕视图控制器 */
@property (nonatomic, weak) DdDanmakuViewController *dvc;

/**
 *  @brief 刷新媒体控制器
 */
- (void)refreshLandscapeMediaControl;

/**
 *  @brief 清理
 */
- (void)clean;

@end
