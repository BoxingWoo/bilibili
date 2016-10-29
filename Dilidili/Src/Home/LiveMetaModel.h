//
//  LiveMetaModel.h
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播元数据模型
 */
@interface LiveMetaModel : NSObject

/**
 标签数组
 */
@property (nonatomic, copy) NSArray<NSString *> *tag;
/**
 描述
 */
@property (nonatomic, copy) NSString *desc;
/**
 类型ID
 */
@property (nonatomic, assign) NSInteger type_id;
/**
 类型ID字典
 */
@property (nonatomic, copy) NSDictionary *tag_ids;
/**
 封面
 */
@property (nonatomic, copy) NSString *cover;
/**
 检查状态
 */
@property (nonatomic, copy) NSString *check_status;
/**
 标识
 */
@property (nonatomic, assign) NSInteger aid;

@end
