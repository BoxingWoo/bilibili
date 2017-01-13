//
//  DdDanmakuListViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/11.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BarrageRenderer/BarrageRenderer.h>
#import "DdDanmakuModel.h"

@interface DdDanmakuListViewModel : NSObject

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

@end
