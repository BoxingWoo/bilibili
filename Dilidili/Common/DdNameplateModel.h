//
//  DdNameplateModel.h
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 头衔模型
 */
@interface DdNameplateModel : NSObject

/** 条件 */
@property (nonatomic, copy) NSString *condition;
/** 图片 */
@property (nonatomic, copy) NSString *image;
/** 图片(小) */
@property (nonatomic, copy) NSString *image_small;
/** 等级 */
@property (nonatomic, copy) NSString *level;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 标识 */
@property (nonatomic, assign) NSInteger nid;

@end
