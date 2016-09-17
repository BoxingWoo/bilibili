//
//  DdRelativeVideoModel.h
//  Dilidili
//
//  Created by iMac on 16/9/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdOwnerModel.h"
#import "DdStatModel.h"

/**
 *  @brief 相关视频模型
 */
@interface DdRelativeVideoModel : NSObject

/** 标识 */
@property (nonatomic, assign) NSInteger aid;
/** 图片 */
@property (nonatomic, copy) NSString *pic;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** up主 */
@property (nonatomic, strong) DdOwnerModel *owner;
/** 统计 */
@property (nonatomic, strong) DdStatModel *stat;

@end
