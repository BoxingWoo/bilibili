//
//  DdBufferProgressView.h
//  Dilidili
//
//  Created by iMac on 16/9/10.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 视频缓冲进度视图
 */
@interface DdBufferProgressView : UIVisualEffectView

/** 缓冲进度 */
@property (nonatomic, assign) NSInteger bufferingProgress;

@end
