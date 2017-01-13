//
//  LiveVideoViewModel.h
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"
#import "LiveInfoModel.h"

/**
 直播视频视图模型
 */
@interface LiveVideoViewModel : DdBasedViewModel

/**
 房间ID
 */
@property (nonatomic, assign) NSInteger room_id;
/**
 播放地址
 */
@property (nonatomic, copy) NSString *playurl;
/** 
 直播信息模型 
 */
@property (nonatomic, strong) LiveInfoModel *model;

/**
 请求直播信息

 @return RACCommand instance
 */
- (RACCommand *)requestLiveInfo;


@end
