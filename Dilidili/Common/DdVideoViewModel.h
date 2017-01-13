//
//  DdVideoViewModel.h
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"

/**
 *  @brief 视频视图模型
 */
@interface DdVideoViewModel : DdBasedViewModel

/**
 视频标识
 */
@property (nonatomic, copy) NSString *aid;
/**
 弹幕标识
 */
@property (nonatomic, copy) NSString *cid;
/**
 媒体URL
 */
@property (nonatomic, copy) NSURL *contentURL;


/**
 *  @brief 获取视频播放链接
 *
 *  @return RACCommand instance
 */
- (RACCommand *)requestVideoURL;

@end
