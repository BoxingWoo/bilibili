//
//  DdRefreshMainHeader.h
//  Dilidili
//
//  Created by iMac on 2016/9/22.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface DdRefreshMainHeader : MJRefreshComponent

/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

@end
