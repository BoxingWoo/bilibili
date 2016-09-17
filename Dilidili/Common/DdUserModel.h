//
//  DdUserModel.h
//  Dilidili
//
//  Created by iMac on 16/9/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdNameplateModel.h"

/**
 *  @brief 用户模型
 */
@interface DdUserModel : NSObject

/** 经验 */
@property (nonatomic, copy) NSString *DisplayRank;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 标识 */
@property (nonatomic, copy) NSString *mid;
/** 经验 */
@property (nonatomic, copy) NSString *rank;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 签名 */
@property (nonatomic, copy) NSString *sign;
/** 用户名 */
@property (nonatomic, copy) NSString *uname;
/** 头衔 */
@property (nonatomic, strong) DdNameplateModel *nameplate;
/** 等级信息 */
@property (nonatomic, copy) NSDictionary *level_info;
/** 官方认证 */
@property (nonatomic, copy) NSDictionary *official_verify;
/** 装饰 */
@property (nonatomic, copy) NSDictionary *pendant;
/** 会员信息 */
@property (nonatomic, copy) NSDictionary *vip;

/** 关注数 */
@property (nonatomic, assign) NSInteger attention;
/** 收藏数 */
@property (nonatomic, assign) NSInteger favorite;

@end
