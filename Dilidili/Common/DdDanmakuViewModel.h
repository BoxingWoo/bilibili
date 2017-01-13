//
//  DdDanmakuViewModel.h
//  Dilidili
//
//  Created by iMac on 2016/9/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "DdDanmakuUserDefaults.h"
#import "DdDanmakuListViewModel.h"

/**
 弹幕视图模型
 */
@interface DdDanmakuViewModel : DdBasedViewModel

/**
 弹幕请求链接
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
 弹幕视图模型数组
 */
@property (nonatomic, copy) NSArray <DdDanmakuListViewModel *> *danmakus;
/**
 最大弹幕数
 */
@property (nonatomic, assign) NSUInteger maxlimit;
/**
 请求弹幕信号
 */
@property (nonatomic, strong) RACSignal *danmakuSignal;

/**
 请求弹幕数据

 @return RACCommand instance
 */
- (RACCommand *)requestDanmakuData;

@end
