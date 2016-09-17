//
//  DdOwnerModel.h
//  Dilidili
//
//  Created by iMac on 16/9/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  @brief 作者模型
 */
@interface DdOwnerModel : NSObject

/** 标识 */
@property (nonatomic, assign) NSInteger mid;
/** 昵称 */
@property (nonatomic, copy) NSString *name;
/** 头像 */
@property (nonatomic, copy) NSString *face;

@end
