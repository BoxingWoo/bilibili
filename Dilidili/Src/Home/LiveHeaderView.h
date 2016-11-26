//
//  LiveHeaderView.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLoopScrollView.h"

/**
 直播头部视图
 */
@interface LiveHeaderView : UICollectionReusableView

/** 循环滚动视图 */
@property (nonatomic, weak) BSLoopScrollView *loopScrollView;
/** 事件响应 */
@property (nonatomic, strong) RACSubject *actionSubject;

@end
