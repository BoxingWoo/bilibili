//
//  DdReplyContentModel.h
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdUserModel.h"

/**
 *  @brief 评论内容模型
 */
@interface DdReplyContentModel : NSObject

/** 设备 */
@property (nonatomic, copy) NSString *device;
/** 内容 */
@property (nonatomic, copy) NSString *message;
/** 平台 */
@property (nonatomic, assign) NSInteger plat;
/** 成员数组 */
@property (nonatomic, copy) NSArray <DdUserModel *> *members;

@end
