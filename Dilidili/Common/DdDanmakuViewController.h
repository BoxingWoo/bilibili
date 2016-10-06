//
//  DdDanmakuViewController.h
//  Dilidili
//
//  Created by iMac on 2016/9/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BarrageRenderer/BarrageRenderer.h>
#import "DdDanmakuUserDefaults.h"

@protocol IJKMediaPlayback;
/**
 弹幕视图控制器
 */
@interface DdDanmakuViewController : UIViewController

/**
 标识
 */
@property (nonatomic, copy) NSString *cid;

/**
 媒体播放器
 */
@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;

/**
 弹幕引擎
 */
@property (nonatomic, strong) BarrageRenderer *renderer;

/**
 是否隐藏弹幕
 */
@property (nonatomic, assign) BOOL shouldHideDanmakus;

/**
 请求数据

 @return RACSignal instance
 */
- (RACSignal *)requestData;

@end
