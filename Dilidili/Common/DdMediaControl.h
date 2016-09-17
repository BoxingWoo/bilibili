//
//  DdMediaControl.h
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IJKMediaPlayback;

/**
 *  @brief 媒体控制器
 */
@interface DdMediaControl : UIView

/** 视频标题 */
@property (nonatomic, copy) NSString *title;
/** 返回命令 */
@property (nonatomic, strong) RACCommand *handleBackCommand;
/** 更多命令 */
@property (nonatomic, strong) RACCommand *handleMoreCommand;
/** 显示/隐藏状态栏命令 */
@property (nonatomic, strong) RACCommand *handleStatusBarHiddenCommand;

/** 屏幕方向 */
@property (nonatomic, assign) UIInterfaceOrientationMask interfaceOrientationMask;
/** 状态栏隐藏状态 */
@property (nonatomic, assign) BOOL statusBarHidden;
/** 加载描述 */
@property (nonatomic, copy) NSString *loadingDetail;
/** 媒体播放器 */
@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;

/**
 *  @brief 刷新媒体控制器
 */
- (void)refreshMediaControl;

@end