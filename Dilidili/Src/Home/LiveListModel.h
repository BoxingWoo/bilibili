//
//  LiveListModel.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivePartitionModel.h"
#import "LiveModel.h"

/**
 直播列表模型
 */
@interface LiveListModel : NSObject

/**
 分区
 */
@property (nonatomic, strong) LivePartitionModel *partition;
/**
 直播数组
 */
@property (nonatomic, copy) NSArray <LiveModel *> *lives;

/**
 横幅广告数组
 */
@property (nonatomic, copy) NSArray <LiveModel *> *banner_data;

@end
