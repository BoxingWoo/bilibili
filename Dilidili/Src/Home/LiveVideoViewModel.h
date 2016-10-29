//
//  LiveVideoViewModel.h
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveInfoModel.h"

/**
 直播视频视图模型
 */
@interface LiveVideoViewModel : NSObject

/** 直播信息模型 */
@property (nonatomic, strong) LiveInfoModel *model;

/**
 *  @brief 构造方法
 *
 *  @param model 直播信息模型
 *
 *  @return 直播视频视图模型实例
 */
- (instancetype)initWithModel:(LiveInfoModel *)model;


/**
 请求直播信息

 @param room_id 房间ID

 @return RACCommand instance
 */
+ (RACCommand *)requestLiveInfoByRoomID:(NSInteger)room_id;


@end
