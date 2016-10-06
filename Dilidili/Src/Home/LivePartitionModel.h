//
//  LivePartitionModel.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播分区模型
 */
@interface LivePartitionModel : NSObject

/**
 分区ID
 */
@property (nonatomic, assign) NSInteger partition_id;
/**
 分区名
 */
@property (nonatomic, copy) NSString *name;
/**
 分区
 */
@property (nonatomic, copy) NSString *area;
/**
 分区图标
 */
@property (nonatomic, copy) NSString *src;
/**
 分区当前直播数量
 */
@property (nonatomic, assign) NSUInteger count;

@end
