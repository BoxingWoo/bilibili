//
//  YPPlayerFPSLabel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/25.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

/**
 视频帧速率标签
 */
@interface YPPlayerFPSLabel : UILabel

/**
 视频播放器
 */
@property (nonatomic, weak) IJKFFMoviePlayerController *player;

/**
 单例方法

 @return 单例对象
 */
+ (instancetype)sharedFPSLabel;

/**
 展示

 @param player 视频播放器
 */
+ (void)showWithPlayer:(IJKFFMoviePlayerController *)player;

/**
 移除
 */
+ (void)dismiss;

@end
