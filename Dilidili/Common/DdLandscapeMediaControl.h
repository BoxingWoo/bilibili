//
//  DdLandscapeMediaControl.h
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IJKMediaPlayback;

/**
 *  @brief 横屏媒体控制器
 */
@interface DdLandscapeMediaControl : UIView

/** 视频标题 */
@property (nonatomic, copy) NSString *title;
/** 返回命令 */
@property (nonatomic, weak) RACCommand *handleBackCommand;
/** 屏幕方向切换命令 */
@property (nonatomic, weak) RACCommand *handleFullScreenCommand;
/** 显示/隐藏状态栏命令 */
@property (nonatomic, weak) RACCommand *handleStatusBarHiddenCommand;
/** 状态栏隐藏状态 */
@property (nonatomic, assign) BOOL statusBarHidden;
/** 媒体播放器 */
@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;

/**
 *  @brief 刷新媒体控制器
 */
- (void)refreshLandscapeMediaControl;

/**
 *  @brief 清理
 */
- (void)clean;

@end
