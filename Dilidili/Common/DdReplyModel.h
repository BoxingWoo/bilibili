//
//  DdReplyModel.h
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdReplyContentModel.h"
#import "DdUserModel.h"

/**
 *  @brief 评价模型
 */
@interface DdReplyModel : NSObject

/** 动作 */
@property (nonatomic, assign) NSInteger action;
/** 评论内容 */
@property (nonatomic, strong) DdReplyContentModel *content;
/** 回复数量 */
@property (nonatomic, assign) NSUInteger count;
/** 创建时间 */
@property (nonatomic, assign) NSTimeInterval ctime;
/** 楼层 */
@property (nonatomic, assign) NSInteger floor;
/** 点赞数 */
@property (nonatomic, assign) NSUInteger like;
/** 用户 */
@property (nonatomic, strong) DdUserModel *member;
/** 用户标识 */
@property (nonatomic, assign) NSInteger mid;
/** 标识 */
@property (nonatomic, assign) NSInteger oid;
/** 父级 */
@property (nonatomic, assign) NSInteger parent;
/** 父级 */
@property (nonatomic, copy) NSString *parent_str;
/**  */
@property (nonatomic, assign) NSInteger rcount;
/**  */
@property (nonatomic, assign) NSInteger root;
/**  */
@property (nonatomic, copy) NSString *root_str;
/**  */
@property (nonatomic, assign) NSInteger rpid;
/**  */
@property (nonatomic, copy) NSString *rpid_str;
/** 状态 */
@property (nonatomic, assign) NSInteger state;
/** 类型 */
@property (nonatomic, assign) NSInteger type;
/** 回复数组 */
@property (nonatomic, copy) NSArray <DdReplyModel *> *replies;

/** 是否点赞 */
@property (nonatomic, assign) BOOL isliked;

@end
