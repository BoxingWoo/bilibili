//
//  DdDanmakuViewModel.h
//  Dilidili
//
//  Created by iMac on 2016/9/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BarrageRenderer/BarrageRenderer.h>
#import "DdDanmakuModel.h"

/**
 弹幕视图模型
 */
@interface DdDanmakuViewModel : NSObject

/**
 弹幕模型
 */
@property (nonatomic, strong) DdDanmakuModel *model;

/**
 弹幕描述模型
 */
@property (nonatomic, strong) BarrageDescriptor *descriptor;

/**
 构造方法

 @param model 弹幕模型

 @return 弹幕视图模型实例
 */
- (instancetype)initWithModel:(DdDanmakuModel *)model;

/**
 请求弹幕数据

 @param cid 标识

 @return RACCommand instance
 */
+ (RACCommand *)requestDanmakuDataByCid:(NSString *)cid;

@end
