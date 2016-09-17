//
//  DdVideoModel.h
//  Dilidili
//
//  Created by iMac on 16/9/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdRightsModel.h"
#import "DdOwnerModel.h"
#import "DdStatModel.h"
#import "DdRelativeVideoModel.h"
#import "DdUserModel.h"

/**
 *  @brief 视频模型
 */
@interface DdVideoModel : NSObject

/** 标识 */
@property (nonatomic, assign) NSInteger aid;
/** 系列标识 */
@property (nonatomic, assign) NSInteger tid;
/** 系列名称 */
@property (nonatomic, copy) NSString *tname;
/** 版权©️ */
@property (nonatomic, assign) NSInteger copyright;
/** 图片 */
@property (nonatomic, copy) NSString *pic;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 发布时间 */
@property (nonatomic, assign) NSTimeInterval pubdate;
/** 创建时间 */
@property (nonatomic, assign) NSTimeInterval ctime;
/** 描述 */
@property (nonatomic, copy) NSString *desc;
/** 状态 */
@property (nonatomic, assign) NSInteger state;
/** 属性 */
@property (nonatomic, assign) NSInteger attribute;
/** 时长 */
@property (nonatomic, assign) NSTimeInterval duration;
/** 标签 */
@property (nonatomic, copy) NSArray *tags;
/** 版权 */
@property (nonatomic, strong) DdRightsModel *rights;
/** up主 */
@property (nonatomic, strong) DdOwnerModel *owner;
/** 统计 */
@property (nonatomic, strong) DdStatModel *stat;
/** up主附加信息
 *  official_verify  官方认证
 *  vip              vip信息
 */
@property (nonatomic, copy) NSDictionary *owner_ext;
/** 分集信息 */
@property (nonatomic, copy) NSArray *pages;
/** 请求用户信息 */
@property (nonatomic, strong) DdUserModel *req_user;
/** 相关视频 */
@property (nonatomic, copy) NSArray <DdRelativeVideoModel *> *relates;

@end
