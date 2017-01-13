//
//  DdVideoInfoViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/10.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import "DdVideoModel.h"

/**
 视频信息视图模型
 */
@interface DdVideoInfoViewModel : DdBasedViewModel

/**
 视频模型
 */
@property (nonatomic, strong) DdVideoModel *model;
/**
 视频标识
 */
@property (nonatomic, copy) NSString *aid;
/**
 视频来源
 */
@property (nonatomic, copy) NSString *from;
/**
 请求信息信号
 */
@property (nonatomic, strong) RACSignal *infoSignal;

/**
 *  @brief 获取视频信息
 *
 *  @return RACCommand instance
 */
- (RACCommand *)requestVideoInfo;

@end
