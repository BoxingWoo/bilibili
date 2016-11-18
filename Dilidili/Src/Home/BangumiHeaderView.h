//
//  BangumiHeaderView.h
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLoopScrollView.h"

/**
 番剧头部视图
 */
@interface BangumiHeaderView : UICollectionReusableView

/**
 循环滚动视图
 */
@property (nonatomic, weak) BSLoopScrollView *loopScrollView;
/**
 分类响应事件，信号值：NSNumber *index（0：连载动画，1：完结动画，2：国产动画，3：官方延伸）
 */
@property (nonatomic, strong) RACSubject *categorySubject;
/**
 功能响应事件，信号值：NSNumber *index（0：追番，1：放送表，2：索引）
 */
@property (nonatomic, strong) RACSubject *optionSubject;

@end
